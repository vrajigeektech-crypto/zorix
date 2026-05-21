import 'package:get/get.dart';
import 'package:whatsapp/screens/auth/otp_verification/otp_verification_controller.dart';

class OtpVerificationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationController>(() => OtpVerificationController());
  }
}