import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:whatsapp/screens/text_repeater/text_repeater_controller.dart';
import 'package:whatsapp/utils/app_colors.dart';
import 'package:whatsapp/utils/app_images.dart';

class TextRepeaterScreen extends StatelessWidget {
  const TextRepeaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextRepeaterController controller = Get.find<TextRepeaterController>();
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
                    'Text Repeater',
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Text Repeater',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Generate repetitive patterns or content for stress testing and creative layouts with precision.',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.lightGrayText,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 24.h,
                            horizontal: 24.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                color: const Color(0xff000000).withOpacity(.05),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CONTENT TO REPEAT',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lightGrayText,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrayColor2.withOpacity(.6),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    width: 1.w,
                                    color: AppColors.borderColor,
                                  ),
                                ),
                                child: TextField(
                                  controller: controller.textController,
                                  maxLines: 3,
                                  onChanged: (value) => controller.generateOutput(),
                                  decoration: InputDecoration(
                                    hintText: 'Type something here...',
                                    hintStyle: TextStyle(
                                      color: AppColors.lightGrayText.withOpacity(0.4),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 24.h),
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                color: const Color(0xff000000).withOpacity(.05),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Text(
                                      'REPEAT COUNT',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.lightGrayText,
                                      ),
                                    ),
                                    Spacer(),
                                    Obx(() => Text(
                                      controller.count.value.toString(),
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.lightGrayText,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 6,
                                  activeTrackColor: Color(0xFF0F766E),
                                  inactiveTrackColor: Colors.grey.shade300,
                                  thumbColor: Color(0xFF005C55),
                                  overlayColor: Color(0xFF0F766E).withOpacity(0.2),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 10,
                                  ),
                                ),
                                child: Obx(() => Slider(
                                  value: controller.count.value.toDouble(),
                                  min: 1,
                                  max: 100,
                                  divisions: 99,
                                  onChanged: (val) {
                                    controller.updateCount(val.round());
                                  },
                                )),
                              ),
                              SizedBox(height: 20.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.h,
                                          horizontal: 16.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGrayColor2,
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (controller.count.value > 1) {
                                                  controller.updateCount(controller.count.value - 1);
                                                }
                                              },
                                              child: Icon(
                                                Icons.remove,
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                            Obx(() => Text(
                                              controller.count.value.toString(),
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.lightGrayText,
                                              ),
                                            )),
                                            GestureDetector(
                                              onTap: () {
                                                if (controller.count.value < 100) {
                                                  controller.updateCount(controller.count.value + 1);
                                                }
                                              },
                                              child: Icon(
                                                Icons.add,
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.h,
                                        horizontal: 16.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.radiumGreenColor,
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: GestureDetector(
                                        onTap: controller.generateOutput,
                                        child: Icon(
                                          Icons.sync,
                                          color: Color(0xff4E6B5A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Text Transformation Options
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 12.h),
                          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                color: const Color(0xff000000).withOpacity(.05),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TEXT TRANSFORMATION',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lightGrayText,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Obx(() {
                                final selectedTransformation = controller.selectedTransformation.value;
                                return Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  children: controller.transformations.map((transformation) {
                                    final isSelected = selectedTransformation == transformation;
                                    return GestureDetector(
                                      onTap: () {
                                        controller.selectedTransformation.value = transformation;
                                        controller.generateOutput();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: isSelected ? Color(0xFF0F766E) : AppColors.lightGrayColor2,
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Text(
                                          transformation.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected ? AppColors.whiteColor : AppColors.primaryTextColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                            ],
                          ),
                        ),
                        // Separator Options
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 12.h),
                          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                color: const Color(0xff000000).withOpacity(.05),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SEPARATOR',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lightGrayText,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Obx(() {
                                final selectedSeparator = controller.selectedSeparator.value;
                                return Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  children: controller.separators.map((separator) {
                                    final isSelected = selectedSeparator == separator;
                                    return GestureDetector(
                                      onTap: () {
                                        controller.selectedSeparator.value = separator;
                                        controller.generateOutput();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: isSelected ? Color(0xFF0F766E) : AppColors.lightGrayColor2,
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Text(
                                          separator.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected ? AppColors.whiteColor : AppColors.primaryTextColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 24.h,
                            horizontal: 24.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: AppColors.darkGreenColor,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'LIVE PREVIEW',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryTextColor,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.r),
                                      color: AppColors.radiumGreenColor,
                                    ),
                                    child: Text(
                                      'DRAFT',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff4E6B5A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrayColor2.withOpacity(.6),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    width: 1.w,
                                    color: AppColors.borderColor,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Obx(() {
                                      return TextField(
                                        controller: TextEditingController(text: controller.output.value),
                                        maxLines: 15,
                                        readOnly: true,
                                        style: TextStyle(
                                          color: AppColors.primaryTextColor,
                                          fontSize: 14.sp,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: controller.output.value.isEmpty ? 'Generated text will appear here...' : null,
                                          hintStyle: TextStyle(
                                            color: AppColors.lightGrayText.withOpacity(0.4),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      );
                                    }),
                                    if (controller.isGenerating.value)
                                      Positioned(
                                        top: 8.h,
                                        right: 8.w,
                                        child: Container(
                                          padding: EdgeInsets.all(8.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.9),
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          child: SizedBox(
                                            width: 16.w,
                                            height: 16.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F766E)),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() => Text('CHARACTERS: ${controller.output.value.length}',style: TextStyle(color: AppColors.lightGrayText.withOpacity(0.6),fontSize: 11.sp),)),
                                  Obx(() => Text('WORDS: ${controller.output.value.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length}',style: TextStyle(color: AppColors.lightGrayText.withOpacity(0.6),fontSize: 11.sp),))
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Obx(() => GestureDetector(
                          onTap: controller.output.value.isNotEmpty ? controller.copyOutput : null,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: controller.output.value.isNotEmpty
                                    ? [Color(0xFF005C55), Color(0xFF0F766E)]
                                    : [Colors.grey.shade400, Colors.grey.shade300],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.content_copy_rounded,color: AppColors.whiteColor,),
                                SizedBox(width: 8.w,),
                                Text(
                                  'Copy Text',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => GestureDetector(
                                onTap: controller.output.value.isNotEmpty ? controller.shareOutput : null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 14.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: controller.output.value.isNotEmpty
                                        ? AppColors.radiumGreenColor
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.share,color: controller.output.value.isNotEmpty ? Color(0xff4E6B5A) : Colors.grey.shade600,),
                                      SizedBox(width: 8.w,),
                                      Text(
                                        'Share Result',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: controller.output.value.isNotEmpty ? Color(0xff4E6B5A) : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Obx(() => GestureDetector(
                                onTap: controller.hasGenerated.value ? controller.clearAll : null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 14.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: controller.hasGenerated.value
                                        ? Colors.red.shade50
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(30.r),
                                    border: Border.all(
                                      color: controller.hasGenerated.value
                                          ? Colors.red.shade200
                                          : Colors.transparent,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.clear,color: controller.hasGenerated.value ? Colors.red.shade600 : Colors.grey.shade600,),
                                      SizedBox(width: 8.w,),
                                      Text(
                                        'Clear All',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: controller.hasGenerated.value ? Colors.red.shade600 : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
