import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/AppAnalyticsEventNamesConstants.dart';
import '../constants/AppAnalyticsUserPropertyNamesConstants.dart';

final appFirebaseAnalyticsLoggingServiceProvider =
    Provider<AppFirebaseAnalyticsLoggingService>(
  (ref) => AppFirebaseAnalyticsLoggingService.resolveDefault(),
);

/// PRD §12 — Firebase Analytics wrapper (no PII in parameters).
class AppFirebaseAnalyticsLoggingService {
  AppFirebaseAnalyticsLoggingService({FirebaseAnalytics? analytics})
      : _analytics = analytics;

  final FirebaseAnalytics? _analytics;

  static const _prefsOnbStartedKey = 'prd_analytics_onb_started_v1';

  static final Set<String> _blockedParameterKeys = {
    'medicine_name',
    'display_name',
    'profile_name',
    'user_name',
    'notes',
    'ingredient',
    'name',
  };

  factory AppFirebaseAnalyticsLoggingService.resolveDefault() {
    if (Firebase.apps.isEmpty) {
      return AppFirebaseAnalyticsLoggingService(analytics: null);
    }
    return AppFirebaseAnalyticsLoggingService(
      analytics: FirebaseAnalytics.instance,
    );
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics?.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  Future<void> logPrdEvent(
    String eventName, [
    Map<String, Object>? parameters,
  ]) async {
    final safe = _sanitizeParameters(parameters);
    await _analytics?.logEvent(name: eventName, parameters: safe);
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics?.setUserProperty(name: name, value: value);
  }

  Future<void> logOnboardingStartedOnce() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_prefsOnbStartedKey) ?? false) return;
    await logPrdEvent(AppAnalyticsEventNamesConstants.onbStarted);
    await prefs.setBool(_prefsOnbStartedKey, true);
  }

  Future<void> syncMedicinesCountUserProperty(int count) async {
    await setUserProperty(
      name: AppAnalyticsUserPropertyNamesConstants.medicinesCount,
      value: count.toString(),
    );
  }

  Future<void> syncProfileCountUserProperty(int count) async {
    await setUserProperty(
      name: AppAnalyticsUserPropertyNamesConstants.profileCount,
      value: count.toString(),
    );
  }

  Future<void> syncUiLanguageUserProperty(String languageCode) async {
    await setUserProperty(
      name: AppAnalyticsUserPropertyNamesConstants.uiLanguage,
      value: languageCode,
    );
  }

  Future<void> syncUserRegionUserProperty(String region) async {
    await setUserProperty(
      name: AppAnalyticsUserPropertyNamesConstants.userRegion,
      value: region,
    );
  }

  Future<void> syncNotificationsGrantedUserProperty(bool granted) async {
    await setUserProperty(
      name: AppAnalyticsUserPropertyNamesConstants.notificationsGranted,
      value: granted ? 'yes' : 'no',
    );
  }

  Future<void> syncBatteryExemptUserProperty(bool exempt) async {
    await setUserProperty(
      name: AppAnalyticsUserPropertyNamesConstants.batteryExempt,
      value: exempt ? 'yes' : 'no',
    );
  }

  Future<void> syncAdsConsentUserProperty(String consentValue) async {
    await setUserProperty(
      name: AppAnalyticsUserPropertyNamesConstants.adsConsent,
      value: consentValue,
    );
  }

  // Legacy names kept for AdMob widget.
  Future<void> logAdBannerLoaded() async {
    await logPrdEvent(AppAnalyticsEventNamesConstants.adBannerLoaded);
  }

  Future<void> logAdBannerFailed({String? reason}) async {
    await logPrdEvent(
      AppAnalyticsEventNamesConstants.adBannerFailed,
      reason != null ? {'reason': reason} : null,
    );
  }

  Map<String, Object>? _sanitizeParameters(Map<String, Object>? parameters) {
    if (parameters == null || parameters.isEmpty) return null;
    final out = <String, Object>{};
    for (final entry in parameters.entries) {
      final key = entry.key.toLowerCase();
      if (_blockedParameterKeys.contains(key)) continue;
      if (key.contains('name') && key != 'screen_name') continue;
      if (key.contains('note')) continue;
      out[entry.key] = _coerceParameterValue(entry.value);
    }
    return out.isEmpty ? null : out;
  }

  /// Firebase Analytics only accepts [String] or [num] parameter values.
  Object _coerceParameterValue(Object value) {
    if (value is String || value is num) return value;
    if (value is bool) return value ? 1 : 0;
    return value.toString();
  }
}
