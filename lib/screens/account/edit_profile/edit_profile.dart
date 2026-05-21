import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:whatsapp/utils/app_colors.dart';
import 'package:whatsapp/utils/app_images.dart';
import 'package:whatsapp/screens/account/edit_profile/edit_profile_controller.dart';

class EditProfile extends GetView<EditProfileController> {
  const EditProfile({super.key});

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
                    'Edit Profile',
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  Obx(
                    () => GestureDetector(
                      onTap: controller.pickImage,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 5.w,
                                color: AppColors.greenColor,
                              ),
                            ),
                            child: Container(
                              height: 116.h,
                              width: 116.w,
                              margin: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: controller.selectedImage.value != null
                                    ? DecorationImage(
                                  image: kIsWeb
                                      ? NetworkImage(controller.selectedImage.value!.path)
                                      : FileImage(File(controller.selectedImage.value!.path))
                                  as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                                    : controller.photoUrl.value.isNotEmpty
                                    ? DecorationImage(
                                  image: NetworkImage(controller.photoUrl.value),
                                  fit: BoxFit.cover,
                                )
                                    : DecorationImage(
                                  image: AssetImage(AppImages.appLogo),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8.h,
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
                  ),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Full Name Field
                        Text(
                          'Full Name',
                          style: TextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: controller.nameController,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: AppColors.primaryTextColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your full name',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 16.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        /// Email Field
                        Text(
                          'Email',
                          style: TextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,readOnly: true,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: AppColors.primaryTextColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 16.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  // Test Firebase Storage button
                  // GestureDetector(
                  //   onTap: controller.testStoragePermissions,
                  //   child: Container(
                  //     width: double.infinity,
                  //     padding: EdgeInsets.symmetric(vertical: 10.h),
                  //     margin: EdgeInsets.symmetric(horizontal: 16.w),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.redColor ?? Colors.blue,
                  //       borderRadius: BorderRadius.circular(30.r),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         'Test Firebase Storage',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16.sp,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10.h),
                  // // Test Firestore button
                  // GestureDetector(
                  //   onTap: controller.testFirestorePermissions,
                  //   child: Container(
                  //     width: double.infinity,
                  //     padding: EdgeInsets.symmetric(vertical: 10.h),
                  //     margin: EdgeInsets.symmetric(horizontal: 16.w),
                  //     decoration: BoxDecoration(
                  //       color: Colors.green,
                  //       borderRadius: BorderRadius.circular(30.r),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         'Test Firestore',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16.sp,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: controller.updateProfile,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: AppColors.greenColor,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Center(
                        child: Obx(
                          () => controller.isLoading.value
                              ? SizedBox(
                                  height: 24.h,
                                  width: 24.h,
                                  child: CircularProgressIndicator(
                                    color: AppColors.whiteColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Save Change',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
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
}
