import 'package:get/get.dart';
import 'package:whatsapp/screens/account/account/account_binding.dart';
import 'package:whatsapp/screens/account/account/account_screen.dart';
import 'package:whatsapp/screens/account/edit_profile/edit_profile.dart';
import 'package:whatsapp/screens/account/edit_profile/edit_profile_binding.dart';
import 'package:whatsapp/screens/account/privacy_policy/privacy_policy_binding.dart';
import 'package:whatsapp/screens/account/privacy_policy/privacy_policy_screen.dart';
import 'package:whatsapp/screens/auth/otp_verification/otp_verification_binding.dart';
import 'package:whatsapp/screens/auth/otp_verification/otp_verification_screen.dart';
import 'package:whatsapp/screens/auth/sign_up/sign_up_binding.dart';
import 'package:whatsapp/screens/auth/sign_up/sign_up_screen.dart';
import 'package:whatsapp/screens/forgot_pass/forgot_pass/forgot_pass_binding.dart';
import 'package:whatsapp/screens/forgot_pass/forgot_pass/forgot_pass_screen.dart';
import 'package:whatsapp/screens/forgot_pass/new_pass/new_pass_binding.dart';
import 'package:whatsapp/screens/forgot_pass/new_pass/new_pass_screen.dart';
import 'package:whatsapp/screens/splash/splash_binding.dart';
import 'package:whatsapp/screens/auth/login/login_binding.dart';
import 'package:whatsapp/screens/disclaimer/disclaimer_binding.dart';
import 'package:whatsapp/screens/home/home_binding.dart';
import 'package:whatsapp/screens/status/status_saver_home/status_saver_binding.dart';
import 'package:whatsapp/screens/status/status_preview/status_preview_binding.dart';
import 'package:whatsapp/screens/chat/direct_chat_binding.dart';
import 'package:whatsapp/screens/text_repeater/text_repeater_binding.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/screens/auth/login/login_screen.dart';
import 'package:whatsapp/screens/chat/direct_chat_screen.dart';
import 'package:whatsapp/screens/disclaimer/disclaimer_screen.dart';
import 'package:whatsapp/screens/home/home_screen.dart';
import 'package:whatsapp/screens/splash/splash_screen.dart';
import 'package:whatsapp/screens/status/status_saver_home/status_saver_screen.dart';
import 'package:whatsapp/screens/text_repeater/text_repeater_screen.dart';

import '../screens/status/status_preview/status_preview_screen.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<SplashScreen>(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage<LoginScreen>(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage<SignUpScreen>(
      name: AppRoutes.signUp,
      page: () => const SignUpScreen(),
      binding: SignUpBinding(),
    ),
    GetPage<ForgotPassScreen>(
      name: AppRoutes.forgotPass,
      page: () => const ForgotPassScreen(),
      binding: ForgotPassBinding(),
    ),
    GetPage<NewPassScreen>(
      name: AppRoutes.newPass,
      page: () => const NewPassScreen(),
      binding: NewPassBinding(),
    ),
    GetPage<AccountScreen>(
      name: AppRoutes.account,
      page: () => const AccountScreen(),
      binding: AccountBinding(),
    ),
    GetPage<EditProfile>(
      name: AppRoutes.editProfile,
      page: () => const EditProfile(),
      binding: EditProfileBinding(),
    ),
    GetPage<PrivacyPolicyScreen>(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage<DisclaimerScreen>(
      name: AppRoutes.disclaimer,
      page: () => const DisclaimerScreen(),
      binding: DisclaimerBinding(),
    ),
    GetPage<HomeScreen>(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage<StatusSaverScreen>(
      name: AppRoutes.statusSaver,
      page: () => const StatusSaverScreen(),
      binding: StatusSaverBinding(),
    ),
    GetPage<StatusPreviewScreen>(
      name: AppRoutes.statusPreview,
      page: () => const StatusPreviewScreen(),
      binding: StatusPreviewBinding(),
    ),
    GetPage<DirectChatScreen>(
      name: AppRoutes.directChat,
      page: () => const DirectChatScreen(),
      binding: DirectChatBinding(),
    ),
    GetPage<TextRepeaterScreen>(
      name: AppRoutes.textRepeater,
      page: () => const TextRepeaterScreen(),
      binding: TextRepeaterBinding(),
    ),
    GetPage<OtpVerificationScreen>(
      name: AppRoutes.otpVerificationScreen,
      page: () => const OtpVerificationScreen(),
      binding: OtpVerificationBinding(),
    ),
  ];
}
