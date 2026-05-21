import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/services/auth_service.dart';
import 'package:whatsapp/utils/app_colors.dart';

class NewPassController extends GetxController {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = false.obs;
  var isOldPasswordVisible = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments.containsKey('email')) {
      email.value = arguments['email'] as String;
    } else if (_authService.currentUser != null) {
      email.value = _authService.currentUser?.email ?? '';
    }
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.redColor.withOpacity(0.9),
      colorText: AppColors.whiteColor,
      icon: Icon(Icons.error_outline, color: AppColors.whiteColor),
      margin: EdgeInsets.all(15),
      borderRadius: 15,
      duration: Duration(seconds: 3),
    );
  }

  Future<void> resetPassword() async {
    if (oldPasswordController.text.isEmpty) {
      _showErrorSnackbar('Field Required', 'Please enter your current password');
      return;
    }
    if (newPasswordController.text.isEmpty) {
      _showErrorSnackbar('Field Required', 'Please enter your new password');
      return;
    }
    if (!_validatePassword(newPasswordController.text)) {
      _showErrorSnackbar('Weak Password', 'Password must be at least 6 characters');
      return;
    }
    if (confirmPasswordController.text.isEmpty) {
      _showErrorSnackbar('Field Required', 'Please confirm your new password');
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      _showErrorSnackbar('Match Error', 'New passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      final user = _authService.currentUser;
      if (user != null) {
        // Re-authenticate with old password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPasswordController.text,
        );
        
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPasswordController.text);

        Get.snackbar(
          'Success',
          'Password has been updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.greenColor.withOpacity(0.9),
          colorText: AppColors.whiteColor,
          icon: Icon(Icons.check_circle_outline, color: AppColors.whiteColor),
          margin: EdgeInsets.all(15),
          borderRadius: 15,
          duration: Duration(seconds: 3),
        );
        Get.back();
      } else {
        // Handle scenario where user is not logged in (recovery flow)
        // For recovery, usually we don't have old password
        // But since the user asked for "old pass match", maybe they use it for something else?
        // Let's assume it's for Change Password screen.
        Get.snackbar('Error', 'User not authenticated');
      }
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is FirebaseAuthException) {
        if (e.code == 'wrong-password') {
          _showErrorSnackbar('Incorrect Password', 'The current password you entered is incorrect. Please try again.');
        } else {
          _showErrorSnackbar('Error', e.message ?? 'Failed to update password');
        }
      } else {
        _showErrorSnackbar('Error', 'An unexpected error occurred');
      }
    }
  }

  void toggleOldPasswordVisibility() {
    isOldPasswordVisible.value = !isOldPasswordVisible.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}