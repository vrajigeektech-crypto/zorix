import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:whatsapp/screens/auth/otp_verification/otp_verification_controller.dart';
import 'package:whatsapp/utils/app_colors.dart';
import 'package:whatsapp/utils/app_images.dart';

class OtpVerificationScreen extends GetView<OtpVerificationController> {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBGColor,
      body: Column(
        children: [
          Container(
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
                    'OTP Verification',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(width: 32.w),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Text(
                    'We’ve sent a verification code to',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.phoneNumber.value,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 68.h),
                  GestureDetector(
                    onTap: () => controller.focusNode.requestFocus(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Visual OTP Bubbles (Background)
                        GetBuilder<OtpVerificationController>(
                          builder: (controller) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                6,
                                (index) => _buildOtpBubble(index),
                              ),
                            );
                          },
                        ),
                        // Hidden TextField to capture input (Foreground, but transparent)
                        Opacity(
                          opacity: 0.01, // Nearly invisible but exists for hits
                          child: SizedBox(
                            width: double.infinity,
                            height: 60.r,
                            child: TextField(
                              controller: controller.otpController,
                              focusNode: controller.focusNode,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              autofocus: true,
                              onChanged: (value) {
                                controller.update(); // Trigger rebuild to update bubbles
                              },
                              decoration: const InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Obx(
                    () => RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.primaryTextColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Resend OTP in ',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.lightGrayText,
                            ),
                          ),
                          TextSpan(
                            text: '${controller.timerValue.value} sec',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),

                  Obx(
                    () => InkWell(
                      onTap: controller.isLoading.value
                          ? null
                          : () {
                              controller.verifyOtp();
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
                                'Verify & Proceed',
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
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn’t receive code? ',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.resendOtp();
                        },
                        child: Obx(
                          () => Text(
                            'Resend again',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: controller.timerValue.value == 0
                                  ? AppColors.darkGreenColor
                                  : AppColors.grayColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpBubble(int index) {
    String text = controller.otpController.text;
    bool isFilled = text.length > index;
    bool isCurrent = text.length == index;
    String char = isFilled ? text[index] : "";

    return Container(
      height: 60.r,
      width: 60.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: (isFilled || isCurrent)
              ? AppColors.primaryColor
              : AppColors.borderColor,
          width: 1.w,
        ),
        color: (isFilled || isCurrent)
            ? AppColors.whiteColor
            : AppColors.borderColor.withOpacity(0.3),
      ),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isFilled)
            Text(
              char,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryTextColor,
              ),
            )
          else
            Container(
              height: 4.r,
              width: 4.r,
              decoration: BoxDecoration(
                color: isCurrent ? AppColors.primaryColor : const Color(0xffD9D9D9),
                shape: BoxShape.circle,
              ),
            ),
          // Cursor logic: show in Current empty bubble OR in 6th bubble if full
          if (isCurrent || (text.length == 6 && index == 5))
            Obx(
              () => Opacity(
                opacity:
                    (controller.showCursor.value && controller.focusNode.hasFocus)
                        ? 1
                        : 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (text.length == 6 && index == 5) SizedBox(width: 12.w), // Offset cursor in filled bubble
                    Container(
                      height: 24.h,
                      width: 2.w,
                      color: AppColors.primaryColor,
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
