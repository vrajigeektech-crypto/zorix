import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileImageService extends GetxService {
  static ProfileImageService get to {
    try {
      return Get.find<ProfileImageService>();
    } catch (e) {
      print('ProfileImageService: Service not found, initializing...');
      final service = ProfileImageService();
      Get.put(service, permanent: true);
      return service;
    }
  }
  
  final RxString _profileImageUrl = ''.obs;
  final RxString _timestamp = ''.obs;
  
  String get profileImageUrl => _profileImageUrl.value.isNotEmpty 
      ? '${_profileImageUrl.value}?t=${_timestamp.value}' 
      : _profileImageUrl.value;
  
  @override
  void onInit() {
    super.onInit();
    _initializeProfileImage();
    _listenToAuthChanges();
  }
  
  void _initializeProfileImage() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _profileImageUrl.value = user.photoURL ?? '';
      _timestamp.value = DateTime.now().millisecondsSinceEpoch.toString();
      print('ProfileImageService: Initialized with image URL: ${_profileImageUrl.value}');
    } else {
      print('ProfileImageService: No user found during initialization');
    }
  }
  
  void _listenToAuthChanges() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        _profileImageUrl.value = user.photoURL ?? '';
        _timestamp.value = DateTime.now().millisecondsSinceEpoch.toString();
        print('ProfileImageService: Auth change detected, updated URL: ${_profileImageUrl.value}');
      } else {
        _profileImageUrl.value = '';
        print('ProfileImageService: User logged out, cleared image URL');
      }
    });
  }
  
  void updateProfileImage(String newImageUrl) {
    print('ProfileImageService: Updating profile image to: $newImageUrl');
    _profileImageUrl.value = newImageUrl;
    _timestamp.value = DateTime.now().millisecondsSinceEpoch.toString();
  }
  
  void refreshProfileImage() {
    _initializeProfileImage();
  }
}
