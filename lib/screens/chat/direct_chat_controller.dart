import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/services/ad_service.dart';

class DirectChatController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final RxBool isLaunching = false.obs;
  final RxBool showMessageField = false.obs;
  final RxString selectedCountryCode = '+91'.obs;
  final RxString selectedCountryFlag = '🇮🇳'.obs;
  final RxString selectedCountryName = 'India'.obs;

  final AdService _adService = AdService();
  BannerAd? bannerAd;

  @override
  void onClose() {
    phoneController.dispose();
    messageController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    bannerAd = _adService.buildBannerAd();
    super.onInit();
  }
  void toggleMessageField() {
    showMessageField.value = !showMessageField.value;
  }

  void selectCountry(Country country) {
    selectedCountryCode.value = '+${country.phoneCode}';
    selectedCountryFlag.value = country.flagEmoji;
    selectedCountryName.value = country.name;
  }

  Future<void> openChat() async {
    final String raw = phoneController.text.trim();
    final String normalized = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (normalized.isEmpty) {
      Get.snackbar('Invalid Input', 'Please enter a valid phone number.');
      return;
    }
    
    isLaunching.value = true;
    
    final String message = messageController.text.trim();
    final String fullNumber = '${selectedCountryCode.value}$normalized';
    String url = 'https://wa.me/$fullNumber';
    if (message.isNotEmpty) {
      url += '?text=${Uri.encodeComponent(message)}';
    }
    
    final Uri uri = Uri.parse(url);
    final bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    isLaunching.value = false;
    
    if (!launched) {
      Get.snackbar('Error', 'Unable to open WhatsApp for this number.');
    }
  }
}
