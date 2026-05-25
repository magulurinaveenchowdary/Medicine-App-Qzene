import 'package:flutter/foundation.dart';

/// AdMob app + unit IDs. Debug/profile use [Google sample IDs](https://developers.google.com/admob/android/test-ads).
class AppAdMobUnitIdentifiersConstants {
  AppAdMobUnitIdentifiersConstants._();

  /// Google sample app ID — debug/profile builds only.
  static const String androidTestApplicationId =
      'ca-app-pub-3940256099942544~3347511713';

  /// Production app ID — release builds only.
  static const String androidProductionApplicationId =
      'ca-app-pub-2961863855425096~2223149321';

  /// Google sample adaptive banner — all placements in non-release builds.
  static const String androidTestBanner =
      'ca-app-pub-3940256099942544/6300978111';

  static const String androidMainTabsBanner =
      'ca-app-pub-2961863855425096/4357375532';

  static const String androidAddMedicineFlowBanner =
      'ca-app-pub-2961863855425096/6498270404';

  static const String androidAfterCallBanner =
      'ca-app-pub-2961863855425096/9418130525';

  static const String androidAlarmFullscreenBanner =
      'ca-app-pub-2961863855425096/2966219504';

  static const String androidOnboardingBanner =
      'ca-app-pub-2961863855425096/2750597089';

  static bool get useGoogleTestAds => !kReleaseMode;

  /// Maps UI/analytics [placement] keys to the correct production ad unit.
  static String resolveAndroidBannerUnitId(String placement) {
    if (useGoogleTestAds) {
      return androidTestBanner;
    }
    switch (placement) {
      case 'tab_footer':
      case 'profiles':
      case 'history_day':
        return androidMainTabsBanner;
      case 'add_flow':
      case 'edit_med':
      case 'med_detail':
        return androidAddMedicineFlowBanner;
      case 'after_call_single':
      case 'after_call_multi':
        return androidAfterCallBanner;
      case 'alarm_fullscreen':
        return androidAlarmFullscreenBanner;
      case 'onboarding':
        return androidOnboardingBanner;
      default:
        return androidMainTabsBanner;
    }
  }
}
