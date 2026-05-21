import 'package:get/instance_manager.dart';
import 'package:whatsapp/screens/forgot_pass/forgot_pass/forgot_pass_controller.dart';

class ForgotPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPassController>(() => ForgotPassController());
  }
}
