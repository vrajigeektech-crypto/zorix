class AppConstants {
  static const String appName = 'Status Saver & Chat Tools';
  static const String disclaimer =
      'This app is not affiliated with WhatsApp. All trademarks belong to their respective owners.';

  static const String whatsappStatusPath =
      '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
  static const String whatsappBusinessStatusPath =
      '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';
  static const String whatsappBusinessStatusPathNoDot =
      '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/Statuses';
  static const String whatsappBusinessAltStatusPath =
      '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp/Media/.Statuses';
  static const String whatsappBusinessAltStatusPathNoDot =
      '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp/Media/Statuses';
  static const String whatsappBusinessNoSpaceStatusPath =
      '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsAppBusiness/Media/.Statuses';
  static const String whatsappBusinessNoSpaceStatusPathNoDot =
      '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsAppBusiness/Media/Statuses';
  static const String legacyWhatsappStatusPath =
      '/storage/emulated/0/WhatsApp/Media/.Statuses';
  static const String legacyWhatsappBusinessStatusPath =
      '/storage/emulated/0/WhatsApp Business/Media/.Statuses';
  static const String legacyWhatsappBusinessStatusPathNoDot =
      '/storage/emulated/0/WhatsApp Business/Media/Statuses';
  static const String legacyWhatsappBusinessNoSpaceStatusPath =
      '/storage/emulated/0/WhatsAppBusiness/Media/.Statuses';
  static const String legacyWhatsappBusinessNoSpaceStatusPathNoDot =
      '/storage/emulated/0/WhatsAppBusiness/Media/Statuses';
  static const List<String> statusPaths = <String>[
    whatsappStatusPath,
    whatsappBusinessStatusPath,
    whatsappBusinessStatusPathNoDot,
    whatsappBusinessAltStatusPath,
    whatsappBusinessAltStatusPathNoDot,
    whatsappBusinessNoSpaceStatusPath,
    whatsappBusinessNoSpaceStatusPathNoDot,
    legacyWhatsappStatusPath,
    legacyWhatsappBusinessStatusPath,
    legacyWhatsappBusinessStatusPathNoDot,
    legacyWhatsappBusinessNoSpaceStatusPath,
    legacyWhatsappBusinessNoSpaceStatusPathNoDot,
  ];
  static const String downloadPath = '/storage/emulated/0/Download/StatusSaver/';

  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String nativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
}
