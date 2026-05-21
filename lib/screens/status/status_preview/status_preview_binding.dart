import 'package:get/get.dart';
import 'package:whatsapp/screens/status/status_preview/status_preview_controller.dart';
import 'package:whatsapp/models/status_item.dart';

class StatusPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatusPreviewController>(
      () => StatusPreviewController(Get.arguments as StatusItem),
    );
  }
}
