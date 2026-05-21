import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/services/auth_service.dart';

class ForgotPassController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();
  
  var isLoading = false.obs;

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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

    isLoading.value = true;
    try {
      await _authService.resetPassword(emailController.text.trim());
      isLoading.value = false;
      Get.snackbar('Success', 'Password reset link sent to your email');
      // Navigate back to login after successful reset
      Get.offAllNamed(AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String message = 'Failed to send reset email';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      Get.snackbar('Error', message);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to send reset email');
    }
  }

  }