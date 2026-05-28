import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/screens/home/home_controller.dart';
import 'package:whatsapp/services/ad_service.dart';
import 'package:whatsapp/services/auth_service.dart';
import 'package:whatsapp/services/profile_image_service.dart';
import 'package:whatsapp/utils/app_colors.dart';
import 'package:whatsapp/utils/app_images.dart';
import 'package:whatsapp/widgets/native_ad_factory.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.primaryBGColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───────────── Header ─────────────
          _buildHeader(controller),
          SizedBox(height: 20.h),

          // ───────────── Body ─────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreeting(controller),
                  SizedBox(height: 20.h),
                  _buildFeatureCards(controller),
                  SizedBox(height: 24.h),
                  _buildStorageCard(controller),
                  SizedBox(height: 24.h),
                  // _showAdBanner(controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────── Header ─────────────
  Widget _buildHeader(HomeController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
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
            offset: Offset(0, 4),
            color: const Color(0xff000000).withValues(alpha: 0.15),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(AppImages.lightLogo, width: 38.w, height: 34.h),
            SizedBox(width: 5.w),
            Image.asset(AppImages.zorixText, height: 14.h),
            Spacer(),
            // Sign-out button
            if (AuthService.requireAuth)
              GestureDetector(
                // onTap: () => _showProfileMenu(controller),
                onTap: () => Get.toNamed(AppRoutes.account),
                child: Obx(() {
                  final String photoUrl = ProfileImageService.to.profileImageUrl;
                  print('HomeScreen: Building profile image with URL: $photoUrl');
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 2.w,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.w,
                        color: AppColors.circleBorderColor,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: photoUrl.isNotEmpty
                          ? Image.network(
                              photoUrl,
                              width: 32.w,
                              height: 32.h,
                              fit: BoxFit.cover,
                              cacheWidth: 64,
                              cacheHeight: 64,
                              errorBuilder: (_, e, st) =>
                                  _buildProfilePlaceholder(),
                            )
                          : _buildProfilePlaceholder(),
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePlaceholder() {
    return Container(
      width: 32.w,
      height: 32.h,
      color: AppColors.lightGrayColor,
      child: Icon(
        Icons.person,
        color: AppColors.grayColor,
        size: 20.h,
      ),
    );
  }

  void _showProfileMenu(HomeController controller) {
    Get.bottomSheet<void>(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.lightGrayColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            // User info row
            Obx(() {
              final String photoUrl = controller.userPhotoUrl.value;
              return Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.w,
                        color: AppColors.circleBorderColor,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: photoUrl.isNotEmpty
                          ? Image.network(
                              photoUrl,
                              width: 48.w,
                              height: 48.h,
                              fit: BoxFit.cover,
                              errorBuilder: (_, e, st) => Container(
                                width: 48.w,
                                height: 48.h,
                                color: AppColors.lightGrayColor,
                                child: Icon(Icons.person,
                                    color: AppColors.grayColor),
                              ),
                            )
                          : Container(
                              width: 48.w,
                              height: 48.h,
                              color: AppColors.lightGrayColor,
                              child: Icon(Icons.person,
                                  color: AppColors.grayColor),
                            ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.userName.value,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Tap to sign out',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: AppColors.grayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 24.h),
            // Sign-out button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back<void>();
                  controller.signOut();
                },
                icon: Icon(Icons.logout, size: 20.h),
                label: Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red.shade700,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  // ───────────── Greeting ─────────────
  Widget _buildGreeting(HomeController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${controller.greetingText},',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: AppColors.grayColor,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            controller.greetingName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Elevate your digital workflow.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────── Feature Cards ─────────────
  Widget _buildFeatureCards(HomeController controller) {
    return Row(
      children: [
        // Status Saver card (large, left)
        _buildStatusSaverCard(controller),
        SizedBox(width: 16.w),
        // Right column: Direct Chat + Text Tools
        Expanded(
          child: Column(
            children: [
              _buildSmallCard(
                onTap: controller.openDirectChat,
                icon: Icons.chat_bubble,
                title: 'Direct Chat',
                subtitle: 'No contact saving needed.',
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  topLeft: Radius.circular(60.r),
                  bottomRight: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                isGreenDot: true
              ),
              SizedBox(height: 16.h),
              _buildSmallCard(
                onTap: controller.openTextRepeater,
                icon: Icons.text_fields,
                title: 'Text Tools',
                subtitle: 'Repeat, flip & transform.',
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60.r),
                  topLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                backgroundImage: AppImages.cnBg,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSaverCard(HomeController controller) {
    return GestureDetector(
      onTap: controller.openStatusSaver,
      child: Container(
        width: 165.w,
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 20.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            topLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(60.r),
            topRight: Radius.circular(60.r),
          ),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF005C55), Color(0xFF0F766E)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 64.h,
              width: 64.w,
              decoration: BoxDecoration(
                color: Color(0xFF2F7D73),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.download,
                    color: Color(0xFF2F7D73),
                    size: 22,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25.h),
            Text(
              'Status \nSaver',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Download stories &\nmedia instantly',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 25.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightGreenColor,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                children: [
                  Text(
                    'View\nGallery',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.greenColor,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward, size: 16.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    required BorderRadius borderRadius,
    String? backgroundImage,
    bool isGreenDot = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 20.w,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: borderRadius,
          image: backgroundImage != null
              ? DecorationImage(
                  image: AssetImage(backgroundImage), fit: BoxFit.cover)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: AppColors.greenColor,
                  size: 30.h,
                ),
               isGreenDot ? Container(
                  height: 8.h,
                  width: 8.w,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreenColor,
                    shape: BoxShape.circle,
                  ),
                ) : SizedBox(width: 8.w),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryTextColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────── Storage Card ─────────────
  Widget _buildStorageCard(HomeController controller) {
    return Obx(() {
      final bool loading = controller.isStorageLoading.value;

      return GestureDetector(
        onTap: controller.openDeviceStorage,
        child: AnimatedOpacity(
          opacity: loading ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.icStorage,
                      height: 12.h,
                      width: 12.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'STORAGE',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    Spacer(),
                    Text(
                      loading ? '...' : controller.storageUsedLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: AppColors.greenColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 12.h,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.centerLeft,
                    widthFactor: loading ? 0.0 : controller.storageWidthFactor,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.lightGreenColor,
                            AppColors.greenColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildStorageLegend(
                      color: AppColors.greenColor,
                      label: 'MEDIA',
                    ),
                    SizedBox(width: 16.w),
                    _buildStorageLegend(
                      color: Color(0xFFD1D5DB),
                      label: 'SYSTEM',
                    ),
                    Spacer(),
                    if (!loading)
                      Text(
                        '${controller.storageUsedGB.value.toStringAsFixed(1)} / ${controller.storageTotalGB.value.toStringAsFixed(0)} GB',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildStorageLegend({
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          height: 6.h,
          width: 6.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _showAdBanner(HomeController controller) {
    if (controller.bannerAd != null) {
      return Container(
        margin: EdgeInsets.only(bottom: 16.h),
        height: 70.h,
        child: AdWidget(ad: controller.bannerAd!),
      );
    }
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ads_click, color: Colors.grey.shade600, size: 20.h),
            SizedBox(width: 8.w),
            Text(
              'Test Banner Ad',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
