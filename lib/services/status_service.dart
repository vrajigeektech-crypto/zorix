import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/models/status_item.dart';
import 'package:whatsapp/utils/app_constants.dart';

class StatusService extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<StatusItem> _images = <StatusItem>[];
  List<StatusItem> _videos = <StatusItem>[];
  String? _selectedFolderPath;
  final List<String> _scanLog = <String>[];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<StatusItem> get images => _images;
  List<StatusItem> get videos => _videos;
  bool get hasStatuses => _images.isNotEmpty || _videos.isNotEmpty;
  List<String> get scanLog => List<String>.unmodifiable(_scanLog);

  Future<void> loadStatuses() async {
    _setLoading(true);
    _error = null;
    _scanLog.clear();

    try {
      final bool canReadStorage = await _requestReadPermissions();
      if (!canReadStorage) {
        _error = 'Storage permission denied.';
        _images = <StatusItem>[];
        _videos = <StatusItem>[];
      } else if (Platform.isAndroid && _isAndroid11OrAbove()) {
        await _loadStatusesFromKnownPaths();
      } else {
        await _loadStatusesFromPath(AppConstants.statusPaths.first);
      }
    } catch (e) {
      _error = 'Failed to load statuses: $e';
      _images = <StatusItem>[];
      _videos = <StatusItem>[];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setStatusFolderPath(String path) async {
    final String sanitizedPath = path.trim();
    if (sanitizedPath.isEmpty) {
      _error = 'Folder path cannot be empty.';
      notifyListeners();
      return;
    }
    _selectedFolderPath = sanitizedPath;
    await loadStatuses();
  }

  Future<bool> downloadStatus(StatusItem statusItem) async {
    try {
      final bool savedByMediaStore = await _saveWithMediaStore(statusItem);
      if (savedByMediaStore) {
        _error = null;
        notifyListeners();
        return true;
      }

      final bool canWrite = await _requestWritePermissions();
      if (!canWrite) {
        _error = 'Storage permission denied. Unable to save file.';
        notifyListeners();
        return false;
      }

      final String fileName = _buildOutputFileName(statusItem);
      final bool savedToSharedStorage = await _saveToDirectory(
        sourceFile: statusItem.file,
        targetFileName: fileName,
        targetDir: Directory(AppConstants.downloadPath),
      );
      if (!savedToSharedStorage) {
        final Directory fallbackDir = await getApplicationDocumentsDirectory();
        final bool savedToAppStorage = await _saveToDirectory(
          sourceFile: statusItem.file,
          targetFileName: fileName,
          targetDir: fallbackDir,
        );
        if (!savedToAppStorage) {
          _error = 'Unable to save status file.';
          notifyListeners();
          return false;
        }
        _error = 'Saved in app storage: ${fallbackDir.path}';
        notifyListeners();
        return true;
      }

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Download failed: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> _saveWithMediaStore(StatusItem statusItem) async {
    if (!Platform.isAndroid) {
      return false;
    }
    try {
      final bool hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        final bool granted = await Gal.requestAccess(toAlbum: true);
        if (!granted) {
          return false;
        }
      }

      if (statusItem.type == StatusType.video) {
        await Gal.putVideo(statusItem.file.path, album: 'StatusSaver');
      } else {
        await Gal.putImage(statusItem.file.path, album: 'StatusSaver');
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _saveToDirectory({
    required File sourceFile,
    required String targetFileName,
    required Directory targetDir,
  }) async {
    try {
      if (!targetDir.existsSync()) {
        await targetDir.create(recursive: true);
      }
      String destinationPath = p.join(targetDir.path, targetFileName);
      File destination = File(destinationPath);
      if (destination.existsSync()) {
        final String nameOnly = p.basenameWithoutExtension(targetFileName);
        final String ext = p.extension(targetFileName);
        final String uniqueName =
            '${nameOnly}_${DateTime.now().millisecondsSinceEpoch}$ext';
        destinationPath = p.join(targetDir.path, uniqueName);
        destination = File(destinationPath);
      }

      await sourceFile.openRead().pipe(destination.openWrite());
      return true;
    } catch (e) {
      _error = 'Save failed: $e';
      return false;
    }
  }

  String _buildOutputFileName(StatusItem item) {
    final String baseName = p.basename(item.file.path);
    final String ext = p.extension(baseName).toLowerCase();
    if (ext.isNotEmpty) {
      return baseName;
    }
    return item.type == StatusType.video
        ? '${baseName}_${DateTime.now().millisecondsSinceEpoch}.mp4'
        : '${baseName}_${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  Future<void> _loadStatusesFromKnownPaths() async {
    final List<String> discoveredPaths = await _discoverStatusPaths();
    final List<String> candidatePaths = <String>[
      if (_selectedFolderPath case final String customPath) customPath,
      ...AppConstants.statusPaths,
      ...discoveredPaths,
    ];
    final Set<String> uniquePaths = <String>{...candidatePaths};
    final List<StatusItem> collectedItems = <StatusItem>[];
    final Set<String> seenPaths = <String>{};

    for (final String path in uniquePaths) {
      final List<StatusItem> pathItems = _readStatusesFromPath(path);
      if (pathItems.isNotEmpty) {
        _scanLog.add('Loaded ${pathItems.length} items from: $path');
      }
      for (final StatusItem item in pathItems) {
        final String key = item.file.path.toLowerCase();
        if (seenPaths.add(key)) {
          collectedItems.add(item);
        }
      }
    }

    _updateLists(collectedItems, notify: false);
    if (!hasStatuses) {
      _error =
          'Status folder not found. Open WhatsApp/WhatsApp Business and view a status first.';
    }
    notifyListeners();
  }

  Future<void> _loadStatusesFromPath(String path, {bool notify = true}) async {
    final List<StatusItem> items = _readStatusesFromPath(path);
    _updateLists(items, notify: notify);
  }

  List<StatusItem> _readStatusesFromPath(String path) {
    final Directory dir = Directory(path);
    if (!dir.existsSync()) {
      _scanLog.add('Not found: $path');
      return <StatusItem>[];
    }

    final List<FileSystemEntity> entities;
    try {
      entities = dir.listSync();
    } catch (_) {
      _scanLog.add('Blocked (no access): $path');
      return <StatusItem>[];
    }

    final List<StatusItem> items = <StatusItem>[];
    int imageCount = 0;
    int videoCount = 0;
    int skippedCount = 0;
    
    for (final FileSystemEntity entity in entities) {
      if (entity is! File) {
        continue;
      }
      final String filePath = entity.path.toLowerCase();
      final StatusType? type = _detectType(filePath);
      if (type == null) {
        skippedCount++;
        _scanLog.add('Skipped file: ${entity.path}');
        continue;
      }
      items.add(StatusItem(file: entity, type: type));
      if (type == StatusType.image) {
        imageCount++;
      } else {
        videoCount++;
      }
    }

    _scanLog.add('Found ${items.length} status files ($imageCount images, $videoCount videos) from $path (skipped $skippedCount files)');
    return items;
  }

  bool _isAndroid11OrAbove() {
    if (!Platform.isAndroid) {
      return false;
    }
    final String version = Platform.operatingSystemVersion;
    final RegExpMatch? match = RegExp(r'Android (\d+)').firstMatch(version);
    final int? sdk = match != null ? int.tryParse(match.group(1)!) : null;
    return (sdk ?? 0) >= 11;
  }

  StatusType? _detectType(String path) {
    // Normalize path to lowercase for case-insensitive matching
    final String normalizedPath = path.toLowerCase();
    
    if (normalizedPath.endsWith('.jpg') ||
        normalizedPath.endsWith('.jpeg') ||
        normalizedPath.endsWith('.png') ||
        normalizedPath.endsWith('.webp')) {
      return StatusType.image;
    }
    if (normalizedPath.endsWith('.mp4') ||
        normalizedPath.endsWith('.3gp') ||
        normalizedPath.endsWith('.mov') ||
        normalizedPath.endsWith('.avi') ||
        normalizedPath.endsWith('.mkv') ||
        normalizedPath.endsWith('.webm')) {
      _scanLog.add('DETECTED VIDEO: $path');
      return StatusType.video;
    }
    
    // Log unknown file types for debugging
    _scanLog.add('UNKNOWN FILE TYPE: $path');
    return null;
  }

  Future<List<String>> _discoverStatusPaths() async {
    const List<String> roots = <String>[
      '/storage/emulated/0/Android/media/com.whatsapp',
      '/storage/emulated/0/Android/media/com.whatsapp.w4b',
      '/storage/emulated/0/WhatsApp',
      '/storage/emulated/0/WhatsApp Business',
      '/storage/emulated/0/WhatsAppBusiness',
    ];

    final Set<String> found = <String>{};
    for (final String root in roots) {
      final Directory rootDir = Directory(root);
      if (!rootDir.existsSync()) {
        continue;
      }

      final List<String> rootMatches = _findStatusDirectories(rootDir);
      found.addAll(rootMatches);
    }

    return found.toList();
  }

  List<String> _findStatusDirectories(Directory root) {
    final Set<String> matches = <String>{};
    final List<Directory> queue = <Directory>[root];
    int visited = 0;
    const int maxVisitedDirs = 3000;

    while (queue.isNotEmpty && visited < maxVisitedDirs) {
      final Directory current = queue.removeAt(0);
      visited++;

      final String base = p.basename(current.path).toLowerCase();
      if (base == '.statuses' || base == 'statuses') {
        matches.add(current.path);
        continue;
      }

      List<FileSystemEntity> children;
      try {
        children = current.listSync(followLinks: false);
      } catch (_) {
        // Skip only this blocked folder and continue the rest.
        continue;
      }

      for (final FileSystemEntity child in children) {
        if (child is Directory) {
          queue.add(child);
        }
      }
    }

    return matches.toList();
  }

  Future<bool> _requestReadPermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final PermissionStatus photosPermission = await Permission.photos.request();
    final PermissionStatus videosPermission = await Permission.videos.request();
    final PermissionStatus storagePermission = await Permission.storage
        .request();
    final PermissionStatus manageStoragePermission = await Permission
        .manageExternalStorage
        .request();
    _scanLog.add(
      'Permissions -> photos: $photosPermission, videos: $videosPermission, '
      'storage: $storagePermission, manageAllFiles: $manageStoragePermission',
    );

    return photosPermission.isGranted ||
        videosPermission.isGranted ||
        photosPermission.isLimited ||
        videosPermission.isLimited ||
        storagePermission.isGranted ||
        storagePermission.isLimited ||
        manageStoragePermission.isGranted;
  }

  Future<bool> _requestWritePermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }
    final PermissionStatus photosPermission = await Permission.photos.request();
    final PermissionStatus videosPermission = await Permission.videos.request();
    final PermissionStatus storagePermission = await Permission.storage
        .request();
    final PermissionStatus manageStoragePermission = await Permission
        .manageExternalStorage
        .request();
    return photosPermission.isGranted ||
        videosPermission.isGranted ||
        photosPermission.isLimited ||
        videosPermission.isLimited ||
        storagePermission.isGranted ||
        storagePermission.isLimited ||
        manageStoragePermission.isGranted;
  }

  void _updateLists(List<StatusItem> items, {bool notify = true}) {
    _images =
        items.where((StatusItem item) => item.type == StatusType.image).toList()
          ..sort((StatusItem a, StatusItem b) => b.name.compareTo(a.name));
    _videos =
        items.where((StatusItem item) => item.type == StatusType.video).toList()
          ..sort((StatusItem a, StatusItem b) => b.name.compareTo(a.name));
    
    _scanLog.add('UPDATE LISTS: Total items: ${items.length}, Images: ${_images.length}, Videos: ${_videos.length}');
    
    // Log video file details for debugging
    for (int i = 0; i < _videos.length; i++) {
      _scanLog.add('VIDEO $i: ${_videos[i].file.path}');
    }
    
    if (_images.isEmpty && _videos.isEmpty) {
      _error = 'No statuses found. View a status first in WhatsApp.';
    } else {
      _error = null;
    }
    if (notify) {
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
