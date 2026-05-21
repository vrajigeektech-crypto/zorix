import 'package:get/get.dart';
import 'package:whatsapp/routes/app_routes.dart';

class DisclaimerController extends GetxController {
  void acceptDisclaimer() {
    Get.offNamed(AppRoutes.home);
  }
}
