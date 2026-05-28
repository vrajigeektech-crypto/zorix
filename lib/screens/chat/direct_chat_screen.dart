import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:whatsapp/screens/chat/direct_chat_controller.dart';
import 'package:whatsapp/services/ad_service.dart';
import 'package:whatsapp/utils/app_colors.dart';
import 'package:whatsapp/utils/app_images.dart';

class DirectChatScreen extends StatelessWidget {
  const DirectChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DirectChatController controller = Get.find<DirectChatController>();
    return Scaffold(
      backgroundColor: AppColors.primaryBGColor,
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
                    'Direct Messaging',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
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
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  Container(
                    height: 96.h,
                    width: 96.w,
                    decoration: BoxDecoration(
                      color: AppColors.radiumGreenColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chat_bubble,
                      color: AppColors.greenColor,
                      size: 30.h,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Direct Messaging.',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48.w),
                    child: Text(
                      'Enter number to start a conversation instantly without saving contacts.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightGrayText,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 15.w),
                    margin: EdgeInsets.symmetric(vertical: 24.h, horizontal: 15.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15,
                          offset: Offset(0, 4),
                          color: AppColors.blackColor.withOpacity(.15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Number',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          height: 48.h,
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
                              // Flag and Country Code (Tappable)
                              Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      onSelect: (Country country) {
                                        controller.selectCountry(country);
                                      },
                                      countryListTheme: CountryListThemeData(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.r),
                                          topRight: Radius.circular(30.r),
                                        ),
                                        inputDecoration: InputDecoration(
                                          hintText: 'Search your country',
                                          prefixIcon: const Icon(Icons.search),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20.r,
                                            ),
                                            borderSide: BorderSide(
                                              color: const Color(
                                                0xFF8C98A8,
                                              ).withOpacity(0.2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        controller.selectedCountryFlag.value,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        controller.selectedCountryCode.value,
                                        style: TextStyle(
                                          color: AppColors.primaryTextColor,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 18.sp,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Vertical Divider
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 15.h,
                                ),
                                width: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                              // TextField
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
                        SizedBox(height: 40.h),
                        // Message Field Toggle
                        GestureDetector(
                          onTap: controller.toggleMessageField,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrayColor2.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.message,
                                  size: 16.h,
                                  color: AppColors.primaryTextColor,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Add message',
                                  style: TextStyle(
                                    color: AppColors.primaryTextColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Obx(
                                  () => Icon(
                                    controller.showMessageField.value
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 16.h,
                                    color: AppColors.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Message Field (Conditional)
                        Obx(() {
                          if (controller.showMessageField.value) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Message (Optional)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryTextColor,
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
                                    controller: controller.messageController,
                                    maxLines: 3,
                                    minLines: 1,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.primaryTextColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Type your message here...',
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.4),
                                        fontSize: 14.sp,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24.h),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }),
                        Obx(
                          () => InkWell(
                            onTap: controller.isLaunching.value
                                ? null
                                : controller.openChat,
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
                                  if (controller.isLaunching.value)
                                    SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: CircularProgressIndicator(
                                        color: AppColors.whiteColor,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  else ...[
                                    SvgPicture.asset(
                                      AppImages.icBoost,
                                      height: 20.h,
                                      width: 16.w,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Start Chat',
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
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
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       Container(
                  //         padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 16.w),
                  //         decoration: BoxDecoration(
                  //           color: AppColors.radiumGreenColor,
                  //           borderRadius: BorderRadius.circular(30.r)
                  //         ),
                  //         child: Row(
                  //           children: [
                  //             SvgPicture.asset(
                  //               AppImages.icSecurity,
                  //               height: 20.h,
                  //               width: 16.w,
                  //             ),
                  //             SizedBox(width: 8.w,),
                  //             Text(
                  //               'Secure Link',
                  //               style: TextStyle(
                  //                 color: AppColors.primaryTextColor,
                  //                 fontSize: 14.sp,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //         padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 16.w),
                  //         decoration: BoxDecoration(
                  //           color: AppColors.lightGrayColor2,
                  //           borderRadius: BorderRadius.circular(30.r)
                  //         ),
                  //         child: Row(
                  //           children: [
                  //             SvgPicture.asset(
                  //               AppImages.icHistory,
                  //               height: 20.h,
                  //               width: 16.w,
                  //             ),
                  //             SizedBox(width: 8.w,),
                  //             Text(
                  //               'Recent: +1 415...',
                  //               style: TextStyle(
                  //                 color: AppColors.primaryTextColor,
                  //                 fontSize: 14.sp,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 24.h),
                  // _showAdBanner(controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showAdBanner(DirectChatController controller) {
    final AdService adService = AdService();
    final Widget? nativeAdWidget = adService.buildNativeAdWidget();

    if (controller.bannerAd != null) {
      // return Container(
      //   margin: EdgeInsets.only(bottom: 16.h),
      //   height: 70.h,
      //   child: AdWidget(ad: controller.bannerAd!),
      // );
      return SizedBox(height: 400.h, child: nativeAdWidget);
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
