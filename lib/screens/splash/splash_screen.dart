import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/screens/splash/splash_controller.dart';
import 'package:whatsapp/utils/app_images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          AppImages.splash,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}