import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/services/auth_service.dart';

class SplashController extends GetxController {
  Timer? _timer;
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    FlutterNativeSplash.remove();
    _timer = Timer(const Duration(seconds: 3), () {
      if (!AuthService.requireAuth) {
        Get.offNamed(AppRoutes.home);
        return;
      }

      if (_authService.currentUser != null) {
        _authService.refreshAndSaveIdToken();
        Get.offNamed(AppRoutes.home);
      } else {
        Get.offNamed(AppRoutes.login);
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
