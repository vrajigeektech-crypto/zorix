import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/models/status_item.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/services/status_service.dart';

class StatusSaverController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final TabController tabController;
  final TextEditingController folderController = TextEditingController();
  final StatusService statusService = Get.find<StatusService>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      statusService.loadStatuses(
      );
    });
  }

  void _onTabChanged() {
    update();
  }

  @override
  void onClose() {
    folderController.dispose();
    tabController.dispose();
    super.onClose();
  }

  void reloadStatuses() {
    statusService.loadStatuses();
  }

  void openPreview(StatusItem item) {
    Get.toNamed(AppRoutes.statusPreview, arguments: item);
  }

  Future<void> submitFolderPath() async {
    final String path = folderController.text.trim();
    if (path.isEmpty) {
      Get.snackbar('Invalid Path', 'Folder path cannot be empty.');
      return;
    }
    Get.back<void>();
    await statusService.setStatusFolderPath(path);
  }

  void showFolderPathDialog() {
    folderController.text =
        '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Set Status Folder Path'),
        content: TextField(
          controller: folderController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Paste the status folder path',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: submitFolderPath,
            child: const Text('Load'),
          ),
        ],
      ),
    );
  }
}
