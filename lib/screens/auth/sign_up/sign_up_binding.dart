import 'package:get/instance_manager.dart';
import 'package:whatsapp/screens/auth/sign_up/sign_up_controller.dart';

class SignUpBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }

}