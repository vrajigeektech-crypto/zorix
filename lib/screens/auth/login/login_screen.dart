import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/screens/auth/login/login_controller.dart';
import 'package:whatsapp/utils/app_colors.dart';
import 'package:whatsapp/utils/app_images.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
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
                  'Welcome back',
                  style: TextStyle(
                    color: AppColors.primaryTextColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Login to your account',
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
      
          SizedBox(height: 24.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.isEmailLogin.value ? 'Email' : 'Phone Number',
                          style: TextStyle(
                            color: AppColors.primaryTextColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        if (controller.isEmailLogin.value) ...[
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
                        ] else ...[
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
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showCountryPicker(
                                      context: context,
                                      onSelect: (Country country) {
                                        controller.updateCountry(country);
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                                    child: Row(
                                      children: [
                                        Text(
                                          controller.selectedCountryFlag.value,
                                          style: TextStyle(fontSize: 18.sp),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '+${controller.selectedCountryCode.value}',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppColors.primaryTextColor,
                                          ),
                                        ),
                                        Icon(Icons.keyboard_arrow_down, size: 16.w),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: TextField(
                                    controller: controller.phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: AppColors.primaryTextColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter your mobile number',
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
                        ],
                      ],
                    )),
                    SizedBox(height: 24.h),
                    Obx(() => controller.isEmailLogin.value
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                child: TextField(
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
                                    suffixIcon: GestureDetector(
                                      onTap: controller.togglePasswordVisibility,
                                      child: Icon(
                                        controller.isPasswordVisible.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.black.withOpacity(0.4),
                                        size: 20.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              InkWell(
                                onTap: () => Get.toNamed(AppRoutes.forgotPass),
                                child: Align(
                                  alignment: AlignmentGeometry.centerEnd,
                                  child: Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: AppColors.greenColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox.shrink()),
                    SizedBox(height: 24.h),
                    // Continue Button
                    Obx(
                      () => InkWell(
                        onTap: controller.isLoading.value
                            ? null
                            : () {
                                if (controller.isEmailLogin.value) {
                                  controller.signInWithEmail();
                                } else {
                                  controller.verifyPhone();
                                }
                              },
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
                                  controller.isEmailLogin.value ? 'Log In' : 'Continue',
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
                    // SizedBox(height: 24.h),
                    // InkWell(
                    //   onTap: () => controller.toggleLoginMethod(),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         'Login with phone number' : 'Login with email',
                    //         style: TextStyle(
                    //           color: AppColors.greenColor,
                    //           fontSize: 14.sp,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                            : () {
                                controller.signInWithGoogle();
                              },
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
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => Get.toNamed(AppRoutes.signUp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account?',
                            style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          Text(
                            ' Sign up',
                            style: TextStyle(
                              color: AppColors.greenColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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
