import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp/services/ad_service.dart';

class TextRepeaterController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final TextEditingController countController = TextEditingController(
    text: '5',
  );
  final RxInt count = 5.obs;
  final RxString output = ''.obs;
  final RxString selectedSeparator = 'newline'.obs;
  final RxString selectedTransformation = 'none'.obs;
  final RxBool isGenerating = false.obs;
  final RxBool hasGenerated = false.obs;

  final AdService _adService = AdService();

  final List<String> separators = ['newline', 'space', 'comma', 'none'];
  final List<String> transformations = [
    'none',
    'uppercase',
    'lowercase',
    'reverse',
    'capitalize',
  ];

  @override
  void onInit() {
    super.onInit();
    _adService.loadInterstitialAd();
  }

  @override
  void onClose() {
    textController.dispose();
    countController.dispose();
    super.onClose();
  }

  String transformText(String text, String transformation) {
    switch (transformation) {
      case 'uppercase':
        return text.toUpperCase();
      case 'lowercase':
        return text.toLowerCase();
      case 'reverse':
        return text.split('').reversed.join('');
      case 'capitalize':
        return text
            .split(' ')
            .map(
              (word) => word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '',
            )
            .join(' ');
      default:
        return text;
    }
  }

  String getSeparator(String separator) {
    switch (separator) {
      case 'space':
        return ' ';
      case 'comma':
        return ', ';
      case 'none':
        return '';
      default:
        return '\n';
    }
  }

  void generateOutput() {
    final String text = textController.text.trim();
    final int countValue = int.tryParse(countController.text.trim()) ?? 0;
    count.value = countValue;
    Get.closeAllSnackbars();

    if (text.isEmpty || countValue <= 0) {
      Get.snackbar(
        'Invalid Input',
        'Please enter text and a repeat count above zero.',
      );
      return;
    }
    if (countValue > 1000) {
      Get.snackbar(
        'Invalid Count',
        'Repeat count is too high. Please use 1000 or less.',
      );
      return;
    }

    isGenerating.value = true;

    // Simulate processing for better UX
    Future.delayed(Duration(milliseconds: 300), () {
      final String transformedText = transformText(
        text,
        selectedTransformation.value,
      );
      final String separator = getSeparator(selectedSeparator.value);
      output.value = List<String>.filled(
        countValue,
        transformedText,
      ).join(separator);
      hasGenerated.value = output.value.isNotEmpty;
      isGenerating.value = false;
    });
  }

  void updateCount(int newCount) {
    count.value = newCount;
    countController.text = newCount.toString();
    generateOutput();
  }

  Future<void> copyOutput() async {
    if (output.value.isEmpty) {
      return;
    }

    _adService.showInterstitialIfAvailable(() async {
      await Clipboard.setData(ClipboardData(text: output.value));
      Get.closeAllSnackbars();
      Get.snackbar('Copied', 'Copied to clipboard.');
    });
  }

  Future<void> shareOutput() async {
    if (output.value.isEmpty) {
      return;
    }
    _adService.showInterstitialIfAvailable(() async {
      await SharePlus.instance.share(ShareParams(text: output.value));
    });
  }

  void clearAll() {
    textController.clear();
    countController.text = '5';
    count.value = 5;
    output.value = '';
    selectedSeparator.value = 'newline';
    selectedTransformation.value = 'none';
    hasGenerated.value = false;
    isGenerating.value = false;
  }
}
