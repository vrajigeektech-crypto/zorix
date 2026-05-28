import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp/firebase_options.dart';
import 'package:whatsapp/routes/app_pages.dart';
import 'package:whatsapp/routes/app_routes.dart';
import 'package:whatsapp/services/status_service.dart';
import 'package:whatsapp/services/auth_service.dart';
import 'package:whatsapp/services/user_profile_service.dart';
import 'package:whatsapp/services/profile_image_service.dart';
import 'package:whatsapp/services/connectivity_service.dart';
import 'package:whatsapp/utils/app_theme.dart';
import 'package:whatsapp/widgets/native_ad_factory.dart';
import 'package:whatsapp/widgets/no_internet_dialog.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }
  Get.put<StatusService>(StatusService(), permanent: true);
  Get.put<AuthService>(AuthService(), permanent: true);
  Get.put<UserProfileService>(UserProfileService(), permanent: true);
  Get.put<ProfileImageService>(ProfileImageService(), permanent: true);
  Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
  runApp(const StatusSaverApp());
}

class StatusSaverApp extends StatelessWidget {
  const StatusSaverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ConnectivityWrapper(
          child: GetMaterialApp(
            title: 'Status Saver & Chat Tools',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            getPages: AppPages.pages,
          ),
        );
      },
    );
  }
}

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    _connectivityService.isConnected.listen((isConnected) {
      if (!isConnected && !_isDialogShown) {
        _isDialogShown = true;
        NoInternetDialog.show(context);
      } else if (isConnected) {
        _isDialogShown = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_connectivityService.isConnected.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isDialogShown) {
            _isDialogShown = true;
            NoInternetDialog.show(context);
          }
        });
      }
      return widget.child;
    });
  }
}
