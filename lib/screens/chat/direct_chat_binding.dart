import 'package:get/get.dart';
import 'package:whatsapp/screens/chat/direct_chat_controller.dart';

class DirectChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DirectChatController>(() => DirectChatController());
  }
}
