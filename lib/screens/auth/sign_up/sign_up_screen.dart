import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/screens/auth/sign_up/sign_up_controller.dart';
import 'package:whatsapp/utils/app_colors.dart';
import 'package:whatsapp/utils/app_images.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());
    return Scaffold(
      backgroundColor: AppColors.primaryBGColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                  color: Color(0xff000000).withOpacity(.15),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 74.h),
                Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: Offset(0, 10),
                        color: Color(0xff000000).withOpacity(.50),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(AppImages.logo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Create Account',
                  style: TextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Create your account to get started ',
                  style: TextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
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
                        keyboardType: TextInputType.emailAddress,
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
                    SizedBox(height: 24.h),
            
                    /// Password Field
                    Text(
                      'Password',
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
                      child: Obx(() => TextField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.primaryTextColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 12.h),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            onPressed: () => controller.togglePasswordVisibility(),
                          ),
                        ),
                      )),
                    ),
                    SizedBox(height: 24.h),
            
                    /// Confirm Password Field
                    Text(
                      'Confirm Password',
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
                      child: Obx(() => TextField(
                        controller: controller.confirmPasswordController,
                        obscureText: !controller.isConfirmPasswordVisible.value,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.primaryTextColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 12.h),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            onPressed: () => controller.toggleConfirmPasswordVisibility(),
                          ),
                        ),
                      )),
                    ),
                    SizedBox(height: 24.h),
                    // Continue Button
                    Obx(
                      () => InkWell(
                        onTap: controller.isLoading.value
                            ? null
                            : () => controller.signUpWithEmail(),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF005C55), Color(0xFF0F766E)],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (controller.isLoading.value)
                                SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    color: AppColors.whiteColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              else ...[
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 18.w,
                                  color: AppColors.whiteColor,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1.h,
                            color: AppColors.lightGrayColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Or',
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Container(
                            height: 1.h,
                            color: AppColors.lightGrayColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Obx(
                      () => InkWell(
                        onTap: controller.isLoading.value
                            ? null
                            : () => controller.signUpWithGoogle(),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(
                              width: 1.w,
                              color: AppColors.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (controller.isLoading.value) ...[
                                SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ] else ...[
                                SvgPicture.asset(
                                  height: 24.h,
                                  width: 24.w,
                                  AppImages.icGoogle,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    color: AppColors.primaryTextColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
            
                      onTap: () => Get.toNamed(AppRoutes.login),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
            
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
            
                          Text(
                            ' Log in',
                            style: TextStyle(
                              color: AppColors.greenColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
