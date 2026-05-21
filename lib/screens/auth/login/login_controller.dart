import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/services/auth_service.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();
  
  var selectedCountryCode = '91'.obs;
  var selectedCountryFlag = '🇮🇳'.obs;
  var isLoading = false.obs;
  var isEmailLogin = true.obs;
  var isPasswordVisible = false.obs;

  void updateCountry(Country country) {
    selectedCountryCode.value = country.phoneCode;
    selectedCountryFlag.value = country.flagEmoji;
  }

  void toggleLoginMethod() {
    isEmailLogin.value = !isEmailLogin.value;
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> signInWithEmail() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }
    if (!_validateEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your password');
      return;
    }

    isLoading.value = true;
    try {
      final userCredential = await _authService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text,
      );
      isLoading.value = false;
      if (userCredential != null) {
        Get.offAllNamed(AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      Get.snackbar('Error', message);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Login failed');
    }
  }

  Future<void> verifyPhone() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return;
    }

    isLoading.value = true;
    String phoneNumber = '+${selectedCountryCode.value}${phoneController.text}';

    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onCodeSent: (verificationId, resendToken) {
          isLoading.value = false;
          Get.toNamed(AppRoutes.otpVerificationScreen, arguments: {
            'phoneNumber': phoneNumber,
            'verificationId': verificationId,
          });
        },
        onVerificationFailed: (e) {
          isLoading.value = false;
          Get.snackbar('Error', e.message ?? 'Verification failed');
        },
        onAutoVerify: (code) {
          // This will be handled in OTP screen if needed, 
          // or we can navigate directly if auto-verified.
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final userCredential = await _authService.signInWithGoogle();
      isLoading.value = false;
      if (userCredential != null) {
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Google sign in failed');
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }
    if (!_validateEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }

    try {
      await _authService.resetPassword(emailController.text.trim());
      Get.snackbar('Success', 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to send reset email';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      }
      Get.snackbar('Error', message);
    } catch (e) {
      Get.snackbar('Error', 'Failed to send reset email');
    }
  }

  void goToDisclaimer() {
    Get.offNamed(AppRoutes.disclaimer);
  }

  }


