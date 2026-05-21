import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp/screens/status/status_preview/status_preview_controller.dart';
import 'package:whatsapp/models/status_item.dart';
import 'package:whatsapp/utils/app_colors.dart';
import 'package:whatsapp/utils/app_images.dart';

class StatusPreviewScreen extends StatelessWidget {
  const StatusPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatusPreviewController>(
      builder: (controller) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 19.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                      color: const Color(0xff000000).withOpacity(.15),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              width: 1.w,
                              color: AppColors.borderColor,
                            ),
                          ),
                          child: SvgPicture.asset(AppImages.icArrowBack),
                        ),
                      ),
                      Text(
                        'Status Saver',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      SizedBox(
                        width: 32.w,
                        height: 32.h,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h,),

              /// image & video preview
              Container(
                width: double.infinity,
                height: 587.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Center(
                  child: controller.item.type == StatusType.image
                      ? InteractiveViewer(
                          child: Image.file(controller.item.file, fit: BoxFit.contain),
                        )
                      : _buildVideo(controller),
                ),
              ),
              SizedBox(height: 24.h,),

              /// Download Button
              GestureDetector(
                onTap: controller.isDownloading ? null : controller.download,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF005C55), Color(0xFF0F766E)],
                    ),
                  ),
                  child: controller.isDownloading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Downloading...',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppImages.icDownload,
                              height: 18.w,
                              width: 21.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Download',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideo(StatusPreviewController screenController) {
    if (screenController.isVideoLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF005C55)),
        ),
      );
    }
    
    if (screenController.videoError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.w,
              color: Colors.red,
            ),
            SizedBox(height: 8.h),
            Text(
              'Video Error',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Tap to retry',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    final VideoPlayerController? controller = screenController.videoController;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF005C55)),
        ),
      );
    }
    
    return GestureDetector(
      onTap: screenController.toggleVideo,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(controller),
            if (!controller.value.isPlaying)
              Center(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 32.w,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
