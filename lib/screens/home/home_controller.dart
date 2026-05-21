import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/services/ad_service.dart';
import 'package:whatsapp/services/auth_service.dart';
import 'package:whatsapp/services/user_profile_service.dart';

class HomeController extends GetxController {
  final AdService _adService = AdService();
  final AuthService _authService = Get.find<AuthService>();
  final UserProfileService _userProfileService = Get.find<UserProfileService>();

  BannerAd? bannerAd;

  // --- User info (reactive) ---
  final RxString userName = ''.obs;
  final RxString userPhotoUrl = ''.obs;

  // --- Storage info (reactive) ---
  final RxDouble storageUsedGB = 0.0.obs;
  final RxDouble storageTotalGB = 0.0.obs;
  final RxDouble storageUsedPercent = 0.0.obs;
  final RxDouble mediaUsedGB = 0.0.obs;
  final RxBool isStorageLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    bannerAd = _adService.buildBannerAd();
    _adService.loadInterstitialAd();
    _loadUserInfo();
    _loadStorageInfo();

    // Listen for real-time user profile changes
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        userName.value = user.displayName ?? user.phoneNumber ?? 'User';
        userPhotoUrl.value = user.photoURL ?? '';
        
        // Sync user profile to Firestore
        _userProfileService.syncFromFirebaseAuth();
      }
    });
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }

  // ───────────── User Info ─────────────

  void _loadUserInfo() {
    final User? user = _authService.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? user.phoneNumber ?? 'User';
      userPhotoUrl.value = user.photoURL ?? '';
    } else {
      userName.value = 'User';
    }
  }

  /// First name only for a friendly greeting.
  String get greetingName {
    final String name = userName.value;
    if (name.isEmpty) return 'User';
    // If it's a phone number, return as-is
    if (name.startsWith('+')) return name;
    return name.split(' ').first;
  }

  /// Time-aware greeting text.
  String get greetingText {
    final int hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // ───────────── Storage Info ─────────────

  Future<void> _loadStorageInfo() async {
    isStorageLoading.value = true;
    try {
      if (Platform.isAndroid) {
        final ProcessResult dfResult = await Process.run('df', ['/data']);
        final String dfOutput = dfResult.stdout.toString();

        // Parse df output (line 2: filesystem, total, used, available, %, mount)
        final List<String> lines = dfOutput.trim().split('\n');
        if (lines.length >= 2) {
          final List<String> parts =
              lines.last.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
          if (parts.length >= 4) {
            // df outputs in 1K blocks
            final double totalKB = double.tryParse(parts[1]) ?? 0;
            final double usedKB = double.tryParse(parts[2]) ?? 0;

            storageTotalGB.value = totalKB / 1024 / 1024;
            storageUsedGB.value = usedKB / 1024 / 1024;

            if (storageTotalGB.value > 0) {
              storageUsedPercent.value =
                  (storageUsedGB.value / storageTotalGB.value * 100)
                      .clamp(0, 100);
            }

            // Estimate media usage (rough: ~40% of used storage is typically media)
            mediaUsedGB.value = storageUsedGB.value * 0.4;
          }
        }
      } else {
        // Fallback values for non-Android (dev/testing)
        storageTotalGB.value = 128.0;
        storageUsedGB.value = 83.2;
        storageUsedPercent.value = 65.0;
        mediaUsedGB.value = 33.3;
      }
    } catch (e) {
      // Graceful fallback on failure
      storageTotalGB.value = 0;
      storageUsedGB.value = 0;
      storageUsedPercent.value = 0;
      mediaUsedGB.value = 0;
    } finally {
      isStorageLoading.value = false;
    }
  }

  String get storageUsedLabel {
    final int percent = storageUsedPercent.value.round();
    return '$percent% Used';
  }

  double get storageWidthFactor {
    return (storageUsedPercent.value / 100).clamp(0.0, 1.0);
  }

  // ───────────── Navigation ─────────────

  void openStatusSaver() {
    _adService.showInterstitialIfAvailable(() {
      Get.toNamed(AppRoutes.statusSaver);
    });
  }

  void openDirectChat() {
    _adService.showInterstitialIfAvailable(() {
      Get.toNamed(AppRoutes.directChat);
    });
  }

  void openTextRepeater() {
    _adService.showInterstitialIfAvailable(() {
      Get.toNamed(AppRoutes.textRepeater);
    });
  }

  Future<void> openDeviceStorage() async {
    try {
      if (Platform.isAndroid) {
        // Launch file manager using content:// URI
        final Uri uri = Uri.parse('content://com.android.externalstorage.documents/root/primary');
        await launchUrl(uri);
      }
    } catch (e) {
      // Fallback: try to open a known file manager app
      try {
        await launchUrl(Uri.parse('file:///storage/emulated/0'));
      } catch (e2) {
        // Final fallback: open settings > storage
        await launchUrl(Uri.parse('android.settings.INTERNAL_STORAGE_SETTINGS'));
      }
    }
  }

  // ───────────── Sign Out ─────────────

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar('Error', 'Sign out failed. Please try again.');
    }
  }
}
