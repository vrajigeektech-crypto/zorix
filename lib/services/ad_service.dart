import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:whatsapp/utils/app_constants.dart';
import 'package:whatsapp/widgets/native_ad_factory.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool get isSupported => false;
      // !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// BannerAd
  BannerAd? buildBannerAd() {
    if (!isSupported) {
      return null;
    }
    return BannerAd(
      size: AdSize.banner,
      adUnitId: AppConstants.bannerAdUnitId,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )
      ..load();
  }

  /// InterstitialAd
  Future<void> loadInterstitialAd() async {
    if (!isSupported) {
      return;
    }
    await InterstitialAd.load(
      adUnitId: AppConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  /// RewardedAd
  Future<void> loadRewardedAd() async {
    if (!isSupported) {
      return;
    }
    await RewardedAd.load(
      adUnitId: AppConstants.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedIfAvailable({
    required VoidCallback onUserEarnedReward,
    VoidCallback? onAdDismissed,
    VoidCallback? onAdNotAvailable,
  }) {
    if (!isSupported) {
      onAdNotAvailable?.call();
      return;
    }
    final RewardedAd? ad = _rewardedAd;
    if (ad == null) {
      onAdNotAvailable?.call();
      return;
    }

    bool rewardEarned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (Ad ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd(); // preload next
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        onAdNotAvailable?.call();
      },
    );

    ad.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        if (rewardEarned) {
          return;
        }
        rewardEarned = true;
        onUserEarnedReward();
      },
    );
  }

  void showInterstitialIfAvailable(VoidCallback? onAdDismissed) {
    if (!isSupported) {
      onAdDismissed?.call();
      return;
    }
    final InterstitialAd? ad = _interstitialAd;
    if (ad == null) {
      onAdDismissed?.call();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd(); // preload next
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _interstitialAd = null;
        onAdDismissed?.call();
      },
    );
    ad.show();
  }

  /// NativeAdView widget for easy integration
  Widget? buildNativeAdWidget() {
    if (!isSupported) {
      return null;
    }
    return NativeAdView(adUnitId: AppConstants.nativeAdUnitId);
  }
}
