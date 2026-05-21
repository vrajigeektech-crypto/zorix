import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp/models/status_item.dart';
import 'package:whatsapp/services/ad_service.dart';
import 'package:whatsapp/services/status_service.dart';
import 'package:whatsapp/utils/app_colors.dart';

class StatusPreviewController extends GetxController {
  StatusPreviewController(this.item);

  final StatusItem item;
  final AdService _adService = AdService();
  final StatusService _statusService = Get.find<StatusService>();
  VideoPlayerController? videoController;
  bool isDownloading = false;
  bool isVideoLoading = false;
  String? videoError;

  @override
  void onInit() {
    super.onInit();
    _adService.loadInterstitialAd();
    _adService.loadRewardedAd();
    if (item.type == StatusType.video) {
      _initializeVideo();
    }
  }

  Future<void> _performDownload() async {
    isDownloading = true;
    update();
    final bool success = await _statusService.downloadStatus(item);
    isDownloading = false;
    update();

    if (success) {
      final String info = _statusService.error ?? '';
      Get.snackbar(
        'Success',
        info.startsWith('Saved in app storage:')
            ? info
            : 'Status saved successfully.',
        backgroundColor: AppColors.greenColor,
      );
    } else {
      final String message =
          _statusService.error ?? 'Unable to save status right now.';
      Get.snackbar('Error', message, backgroundColor: Colors.red);
    }
  }

  void _showRewardedThenDownload({required bool allowFallbackDownload}) {
    _adService.showRewardedIfAvailable(
      onUserEarnedReward: _performDownload,
      onAdDismissed: () {
        // user closed ad without reward; do nothing
      },
      onAdNotAvailable: () async {
        await _adService.loadRewardedAd();
        if (allowFallbackDownload) {
          _showRewardedThenDownload(allowFallbackDownload: false);
        } else {
          await _performDownload();
        }
      },
    );
  }

  void _initializeVideo() {
    isVideoLoading = true;
    videoError = null;
    update();
    
    videoController = VideoPlayerController.file(item.file);
    
    videoController!.initialize().then((_) {
      isVideoLoading = false;
      videoError = null;
      update();
    }).catchError((error) {
      isVideoLoading = false;
      videoError = 'Failed to load video: $error';
      update();
    });
  }

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }

  Future<void> download() async {
    if (isDownloading) {
      return;
    }

    _showRewardedThenDownload(allowFallbackDownload: true);
  }

  void openWithApp() {
    OpenFile.open(item.file.path);
  }

  void toggleVideo() {
    if (videoError != null) {
      _initializeVideo();
      return;
    }
    
    final VideoPlayerController? controller = videoController;
    if (controller == null) {
      return;
    }
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    update();
  }
}
