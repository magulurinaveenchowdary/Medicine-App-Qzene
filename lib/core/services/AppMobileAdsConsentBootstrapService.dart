import 'dart:developer' as developer;

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants/AppAdMobUnitIdentifiersConstants.dart';

/// Requests UMP consent before loading personalized ads (PRD / Play policy).
class AppMobileAdsConsentBootstrapService {
  /// Non-blocking best-effort; continues if consent SDK errors (dev without Play Services).
  static Future<void> requestConsentAndInitAds() async {
    if (AppAdMobUnitIdentifiersConstants.useGoogleTestAds) {
      developer.log(
        'AdMob: using Google test ad units (debug/profile)',
        name: 'AdsConsent',
      );
    }
    try {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () {
          developer.log('Consent info updated', name: 'AdsConsent');
        },
        (FormError error) {
          developer.log('Consent error: ${error.message}', name: 'AdsConsent');
        },
      );
    } catch (e, st) {
      developer.log('Consent bootstrap failed: $e', stackTrace: st, name: 'AdsConsent');
    }
    await MobileAds.instance.initialize();
  }
}
