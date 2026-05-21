import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/services/auth_service.dart';
import 'package:whatsapp/services/user_profile_service.dart';
import 'package:whatsapp/services/profile_image_service.dart';

class EditProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final UserProfileService _userProfileService = Get.find<UserProfileService>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController emailController;

  RxBool isLoading = false.obs;
  Rx<XFile?> selectedImage = Rx<XFile?>(null); // FIX 1: Use XFile instead of File for web compatibility
  RxString photoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (!AuthService.requireAuth) {
      Get.offAllNamed(AppRoutes.home);
      return;
    }
    final user = _authService.currentUser;
    nameController = TextEditingController(text: user?.displayName ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    photoUrl.value = user?.photoURL ?? '';
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (image != null) {
        selectedImage.value = image; // FIX 2: Store XFile directly
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<String> _uploadProfileImage({
    required String uid,
    required XFile imageFile,
  }) async {
    final Uint8List imageBytes = await imageFile.readAsBytes();
    debugPrint('---> bytes length: ${imageBytes.length}');

    debugPrint('---> storage bucket (sdk): ${FirebaseStorage.instance.bucket}');

    final Reference storageRef = FirebaseStorage.instance
        .ref('users/$uid/profile_${DateTime.now().millisecondsSinceEpoch}.jpg');

    debugPrint('---> uploading to: ${storageRef.fullPath}');

    try {
      // Simplest possible upload — no metadata, no timeout, no wrappers
      final TaskSnapshot snapshot = await storageRef.putData(imageBytes);

      debugPrint('---> upload state: ${snapshot.state}');

      final String url = await snapshot.ref.getDownloadURL();
      debugPrint('---> download url: $url');
      return url;
    } on FirebaseException catch (e) {
      debugPrint('---> FirebaseException code: ${e.code}');
      debugPrint('---> FirebaseException message: ${e.message}');
      debugPrint('---> FirebaseException plugin: ${e.plugin}');
      rethrow;
    }
  }

  Future<void> updateProfile() async {
    final user = _authService.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User not authenticated', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      String? newPhotoUrl;

      // STEP 1: Upload image
      if (selectedImage.value != null) {
        try {
          newPhotoUrl = await _uploadProfileImage(
            uid: user.uid,
            imageFile: selectedImage.value!,
          );
          await user.updatePhotoURL(newPhotoUrl);
          debugPrint('---> Photo URL updated: $newPhotoUrl');
        } catch (e) {
          debugPrint('---> Image upload failed: $e');
          Get.snackbar('Error', 'Image upload failed: $e', snackPosition: SnackPosition.BOTTOM);
          return; // Stop early so Firestore error doesn't hide Storage error
        }
      }

      // STEP 2: Update display name
      final String trimmedName = nameController.text.trim();
      if (trimmedName.isNotEmpty && trimmedName != (user.displayName ?? '')) {
        await user.updateDisplayName(trimmedName);
        debugPrint('---> Display name updated: $trimmedName');
      }

      await user.reload();
      final User? refreshedUser = FirebaseAuth.instance.currentUser;

      final String finalName = refreshedUser?.displayName ?? user.displayName ?? '';
      final String finalPhoto = refreshedUser?.photoURL ?? newPhotoUrl ?? user.photoURL ?? '';

      photoUrl.value = finalPhoto;
      if (finalPhoto.isNotEmpty) {
        ProfileImageService.to.updateProfileImage(finalPhoto);
      }

      // STEP 3: Save to Firestore — separate try/catch so error is clear
      try {
        await _userProfileService.createOrUpdateUserProfile(
          uid: user.uid,
          displayName: finalName,
          email: refreshedUser?.email ?? user.email,
          photoURL: finalPhoto.isNotEmpty ? finalPhoto : null,
          phoneNumber: refreshedUser?.phoneNumber ?? user.phoneNumber,
        );
        debugPrint('---> Firestore profile saved successfully');
      } catch (e) {
        debugPrint('---> Firestore save failed: $e');
        Get.snackbar('Error', 'Failed to save profile: $e', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      Get.back<void>();
      Get.snackbar('Success', 'Profile updated successfully', snackPosition: SnackPosition.BOTTOM);

    } finally {
      isLoading.value = false;
    }
  }
}