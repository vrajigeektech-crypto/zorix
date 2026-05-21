import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/services/auth_service.dart';

class AccountController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    if (!AuthService.requireAuth) {
      Get.offAllNamed(AppRoutes.home);
      return;
    }
    currentUser.value = _authService.currentUser;
    FirebaseAuth.instance.userChanges().listen((User? user) {
      currentUser.value = user;
    });
  }

  void logout() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}