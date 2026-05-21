import 'package:get/get.dart';
import 'package:whatsapp/screens/forgot_pass/new_pass/new_pass_controller.dart';

class NewPassBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<NewPassController>(() => NewPassController(),);
  }
}