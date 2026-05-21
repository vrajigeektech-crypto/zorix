import 'package:get/instance_manager.dart';
import 'package:whatsapp/screens/account/account/account_controller.dart';

class AccountBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AccountController>(() => AccountController(),);
  }
}