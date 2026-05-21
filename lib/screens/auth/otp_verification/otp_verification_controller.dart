import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp/services/auth_service.dart';
import 'package:whatsapp/routes/app_routes.dart';

class OtpVerificationController extends GetxController {
  final otpController = TextEditingController();
  final focusNode = FocusNode();
  final AuthService _authService = Get.find<AuthService>();
  
  var timerValue = 30.obs;
  var showCursor = true.obs;
  var isLoading = false.obs;
  var phoneNumber = ''.obs;
  
  Timer? _timer;
  Timer? _cursorTimer;

  @override
  void onInit() {
    super.onInit();
    phoneNumber.value = Get.arguments['phoneNumber'] ?? '';
    focusNode.addListener(() {
      update();
    });
    startTimer();
    startCursorTimer();
  }

  void startCursorTimer() {
    _cursorTimer?.cancel();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      showCursor.value = !showCursor.value;
    });
  }

  void startTimer() {
    timerValue.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerValue.value > 0) {
        timerValue.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length < 6) {
      Get.snackbar('Error', 'Please enter a valid 6-digit OTP');
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signInWithPhoneNumber(otpController.text);
      isLoading.value = false;
      if (user != null) {
        Get.offAllNamed(AppRoutes.disclaimer); // Or wherever the next screen is
      } else {
        Get.snackbar('Error', 'Invalid OTP');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Authentication failed: ${e.toString()}');
    }
  }

  Future<void> resendOtp() async {
    if (timerValue.value > 0) return;
    
    isLoading.value = true;
    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber.value,
        onCodeSent: (verificationId, resendToken) {
          isLoading.value = false;
          startTimer();
          Get.snackbar('Success', 'OTP resent successfully');
        },
        onVerificationFailed: (e) {
          isLoading.value = false;
          Get.snackbar('Error', e.message ?? 'Verification failed');
        },
        onAutoVerify: (code) {
          otpController.text = code;
          verifyOtp();
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to resend OTP');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    otpController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}