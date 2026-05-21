import 'package:get/get.dart';
import 'package:whatsapp/screens/disclaimer/disclaimer_controller.dart';

class DisclaimerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DisclaimerController>(() => DisclaimerController());
  }
}
