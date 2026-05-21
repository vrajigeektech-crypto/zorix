import 'package:get/get.dart';
import 'package:whatsapp/screens/text_repeater/text_repeater_controller.dart';

class TextRepeaterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TextRepeaterController>(() => TextRepeaterController());
  }
}
