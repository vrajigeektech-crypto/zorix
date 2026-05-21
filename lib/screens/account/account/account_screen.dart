import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/utils/app_colors.dart';
import 'package:whatsapp/utils/app_images.dart';
import 'package:whatsapp/screens/account/account/account_controller.dart';
import 'package:whatsapp/services/profile_image_service.dart';

class AccountScreen extends GetView<AccountController> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    'Account',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(width: 30.w, height: 30.h),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.editProfile);
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 5.w, color: AppColors.greenColor),
                  ),
                  child: Obx(
                    () => Container(
                      height: 116.h,
                      width: 116.w,
                      margin: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: (() {
                                final String url = ProfileImageService.to.profileImageUrl;
                                print('AccountScreen: Building profile image with URL: $url');
                                return url.isNotEmpty
                                    ? NetworkImage(url)
                                    : AssetImage(AppImages.appLogo) as ImageProvider;
                              })(),
                              fit: BoxFit.cover
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8.w,
                  right: 6.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 8.w,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.greenColor,
                    ),
                    child: SvgPicture.asset(
                      AppImages.icEdit,
                      height: 16.h,
                      width: 16.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Obx(
            () => Text(
              controller.currentUser.value?.displayName ?? 'No Name',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
          ),
          Obx(
            () => Text(
              controller.currentUser.value?.email ?? 'No Email',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryTextColor,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                  color: const Color(0xff000000).withOpacity(.05),
                ),
              ],
            ),
            child: Column(
              children: [
                _accountItemWidget(
                  title: 'Edit Profile',
                  icon: AppImages.icPerson,
                  onTap: () => Get.toNamed(AppRoutes.editProfile),
                ),
                Divider(color: Color(0xffCBD5E1).withOpacity(0.5), height: 0),
                _accountItemWidget(
                  title: 'Forgot Password',
                  icon: AppImages.icForgotPass,
                  onTap: () => Get.toNamed(AppRoutes.newPass),
                ),
                Divider(color: Color(0xffCBD5E1).withOpacity(0.5), height: 0),
                _accountItemWidget(
                  title: 'Privacy Policy',
                  icon: AppImages.icPrivacyPolicy,
                  onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: controller.logout,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.lightRedColor,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImages.icLogout),
                  SizedBox(width: 8.w),

                  Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.redColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountItemWidget({
    required String title,
    required String icon,
    required void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.h),
              decoration: BoxDecoration(
                color: AppColors.radiumGreenColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset(icon, color: AppColors.greenColor),
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryTextColor,
              ),
            ),
            Spacer(),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: Color(0xffCBD5E1),
              size: 28.h,
            ),
          ],
        ),
      ),
    );
  }
}
