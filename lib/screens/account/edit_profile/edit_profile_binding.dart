import 'package:get/instance_manager.dart';
import 'package:whatsapp/screens/account/edit_profile/edit_profile_controller.dart';

class EditProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController(),);
  }
}