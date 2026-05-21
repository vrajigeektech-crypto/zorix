import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Utility to test Firebase Storage connectivity
class FirebaseTest {
  static Future<void> testStorageConnection() async {
    try {
      print('Testing Firebase Storage connection...');
      
      // Test 1: Check if Firebase Storage is initialized with explicit bucket
      final storage = FirebaseStorage.instanceFor(bucket: 'zorixo-9e45f.firebasestorage.app');
      print('Firebase Storage instance created for bucket: zorixo-9e45f.firebasestorage.app');
      
      // Test 2: Try to list files in root (this will test permissions)
      final ref = storage.ref();
      final listResult = await ref.listAll();
      print('Storage is accessible. Found ${listResult.items.length} items in root');
      
      // Test 3: Try to create a test file
      final testRef = storage.ref().child('test_connection.txt');
      await testRef.putString('test connection');
      print('Test file created successfully');
      
      // Clean up test file
      await testRef.delete();
      print('Test file deleted successfully');
      
      Get.snackbar('Success', 'Firebase Storage is working correctly', 
          snackPosition: SnackPosition.BOTTOM);
          
    } on FirebaseException catch (e) {
      print('Firebase Storage test failed: ${e.code} - ${e.message}');
      
      String errorMessage = 'Firebase Storage error: ';
      switch (e.code) {
        case 'object-not-found':
          errorMessage += 'Storage bucket not found. Check Firebase project setup:\n'
              '1. Go to Firebase Console → Storage\n'
              '2. Click "Get started" if not set up\n'
              '3. Select "Start in test mode"\n'
              '4. Update security rules if needed';
          break;
        case 'unauthorized':
          errorMessage += 'Permission denied. Update security rules:\n'
              'rules_version = \'2\';\n'
              'service firebase.storage {\n'
              '  match /b/{bucket}/o {\n'
              '    match /{allPaths=**} {\n'
              '      allow read, write: if request.auth != null;\n'
              '    }\n'
              '  }\n'
              '}';
          break;
        case 'retry-limit-exceeded':
          errorMessage += 'Network connection issue';
          break;
        default:
          errorMessage += e.message ?? 'Unknown error';
      }
      
      Get.snackbar('Storage Test Failed', errorMessage, 
          snackPosition: SnackPosition.BOTTOM, 
          duration: const Duration(seconds: 8));
          
    } catch (e) {
      print('Unexpected error in storage test: $e');
      Get.snackbar('Test Error', 'Unexpected error: $e', 
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
