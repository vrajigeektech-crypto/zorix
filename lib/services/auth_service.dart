import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:whatsapp/services/token_storage.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TokenStorage _tokenStorage = TokenStorage();
  static const bool requireAuth = false;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize Google Sign-In for v7.0.0+
    GoogleSignIn.instance.initialize();
  }
  
  String? verificationId;
  int? resendToken;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(FirebaseAuthException e) onVerificationFailed,
    required Function(String code) onAutoVerify,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (credential.smsCode != null) {
          onAutoVerify(credential.smsCode!);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e);
      },
      codeSent: (String vid, int? resToken) {
        verificationId = vid;
        resendToken = resToken;
        onCodeSent(vid, resToken);
      },
      codeAutoRetrievalTimeout: (String vid) {
        verificationId = vid;
      },
    );
  }

  Future<UserCredential?> signInWithPhoneNumber(String smsCode) async {
    if (verificationId == null) return null;
    
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: smsCode,
    );
    
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    await _persistIdToken(userCredential.user);
    return userCredential;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Use authenticate() instead of signIn() for v7.0.0+
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();
      if (googleUser == null) return null;

      // Obtain identity details (idToken)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Obtain authorization details (accessToken)
      // Note: We request basic scopes to ensure we get an access token
      final authClient = await googleUser.authorizationClient.authorizeScopes(['email', 'profile', 'openid']);

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authClient.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      await _persistIdToken(userCredential.user);
      return userCredential;
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _persistIdToken(userCredential.user);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error during email sign-in: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error during email sign-in: $e');
      rethrow;
    }
  }

  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _persistIdToken(userCredential.user);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Error during email sign-up: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error during email sign-up: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Error sending password reset: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error sending password reset: $e');
      rethrow;
    }
  }

  Future<void> _persistIdToken(User? user) async {
    if (user == null) return;
    final String? idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) return;
    await _tokenStorage.saveIdToken(idToken);
  }

  Future<String?> getSavedIdToken() => _tokenStorage.getIdToken();

  Future<String?> refreshAndSaveIdToken() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;
    final String? idToken = await user.getIdToken(true);
    if (idToken == null || idToken.isEmpty) return null;
    await _tokenStorage.saveIdToken(idToken);
    return idToken;
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
    await _tokenStorage.clear();
  }

  User? get currentUser => _auth.currentUser;
}

