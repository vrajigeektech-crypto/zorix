import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:whatsapp/models/status_item.dart';
import 'package:whatsapp/screens/status/status_saver_home/status_saver_controller.dart';
import 'package:whatsapp/services/status_service.dart';
import 'package:whatsapp/utils/app_colors.dart';
import 'package:whatsapp/utils/app_images.dart';
import 'package:whatsapp/widgets/status_tile.dart';

class StatusSaverScreen extends StatelessWidget {
  const StatusSaverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StatusSaverController controller = Get.find<StatusSaverController>();
    return Scaffold(
      body: GetBuilder<StatusSaverController>(
        builder: (_) {
          return Column(
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
                      Row(
                        children: [
                          IconButton(
                            onPressed: controller.reloadStatuses,
                            icon: const Icon(Icons.refresh_rounded),
                            tooltip: 'Refresh',
                          ),
                          IconButton(
                            onPressed: controller.showFolderPathDialog,
                            icon: const Icon(Icons.folder_open_rounded),
                            tooltip: 'Set folder path',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      Text(
                        'Status Saver',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Curated media from your recent updates.',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightGrayText,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      GetBuilder<StatusSaverController>(
                        builder: (controller) {
                          final bool isImages = controller.tabController.index == 0;
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.h,
                              horizontal: 6.w,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrayColor2,
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => controller.tabController.animateTo(0),
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 32.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isImages
                                          ? AppColors.primaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Images',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: isImages
                                              ? AppColors.whiteColor
                                              : AppColors.lightGrayText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => controller.tabController.animateTo(1),
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 32.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !isImages
                                          ? AppColors.primaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Videos',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: !isImages
                                              ? AppColors.whiteColor
                                              : AppColors.lightGrayText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 24.h),
                      Expanded(
                        child: _StatusBody(controller: controller),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusBody extends StatelessWidget {
  const _StatusBody({required this.controller});

  final StatusSaverController controller;

  @override
  Widget build(BuildContext context) {
    final StatusService statusService = controller.statusService;
    return AnimatedBuilder(
      animation: statusService,
      builder: (context, _) {
        if (statusService.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final String? error = statusService.error;
        if (error != null) {
          return _EmptyState(
            message: error,
            diagnostics: statusService.scanLog,
            onRetry: controller.reloadStatuses,
          );
        }

        return AnimatedBuilder(
          animation: controller.tabController,
          builder: (context, __) {
            final bool isImages = controller.tabController.index == 0;
            final List<StatusItem> items = isImages
                ? statusService.images
                : statusService.videos;

            // Debug logging
            print('TAB SWITCH: isImages=$isImages, items.length=${items.length}');
            if (!isImages) {
              print('VIDEOS COUNT: ${statusService.videos.length}');
              for (int i = 0; i < statusService.videos.length; i++) {
                print('VIDEO $i: ${statusService.videos[i].file.path}');
              }
            }

            return RefreshIndicator(
              onRefresh: () async => controller.reloadStatuses(),
              child: _MasonryStatusGrid(
                items: items,
                emptyLabel: isImages ? 'No image statuses found.' : 'No video statuses found.',
                onItemTap: controller.openPreview,
              ),
            );
          },
        );
      },
    );
  }
}

class _MasonryStatusGrid extends StatelessWidget {
  const _MasonryStatusGrid({
    required this.items,
    required this.emptyLabel,
    required this.onItemTap,
  });

  final List<StatusItem> items;
  final String emptyLabel;
  final ValueChanged<StatusItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 80.h),
          Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                '$emptyLabel Open WhatsApp and view a status first.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return MasonryGridView.count(
      padding: EdgeInsets.only(bottom: 16.h),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final StatusItem item = items[index];
        final double aspectRatio = switch (index % 3) {
          0 => 1,
          1 => 3 / 4,
          _ => 9 / 16,
        };
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: StatusTile(item: item, onTap: () => onItemTap(item)),
        );
      },
    );
  }
}

class _StatusGrid extends StatelessWidget {
  const _StatusGrid({
    required this.items,
    required this.emptyLabel,
    required this.onItemTap,
  });

  final List<StatusItem> items;
  final String emptyLabel;
  final ValueChanged<StatusItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            '$emptyLabel Open WhatsApp and view a status first.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: items.length,
      itemBuilder: (_, int index) {
        final StatusItem item = items[index];
        return StatusTile(item: item, onTap: () => onItemTap(item));
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.message,
    required this.diagnostics,
    required this.onRetry,
  });

  final String message;
  final List<String> diagnostics;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_empty_rounded, size: 56.r),
            SizedBox(height: 12.h),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 12.h),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
            if (diagnostics.isNotEmpty) ...[
              SizedBox(height: 16.h),
              // ExpansionTile(
              //   tilePadding: EdgeInsets.zero,
              //   title: const Text('Debug details'),
              //   children: diagnostics
              //       .map(
              //         (String line) => Padding(
              //           padding: EdgeInsets.only(bottom: 8.h),
              //           child: Text(
              //             line,
              //             style: Theme.of(context).textTheme.bodySmall,
              //             textAlign: TextAlign.left,
              //           ),
              //         ),
              //       )
              //       .toList(),
              // ),
            ],
          ],
        ),
      ),
    );
  }
}