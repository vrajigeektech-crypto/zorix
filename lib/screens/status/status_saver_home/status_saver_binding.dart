import 'package:get/get.dart';
import 'package:whatsapp/screens/status/status_saver_home/status_saver_controller.dart';

class StatusSaverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatusSaverController>(() => StatusSaverController());
  }
}
