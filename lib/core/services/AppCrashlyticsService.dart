import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appCrashlyticsServiceProvider = Provider<AppCrashlyticsService>(
  (ref) => AppCrashlyticsService.resolveDefault(),
);

/// PRD §12.7 — Firebase Crashlytics wrapper.
///
/// Custom keys set on every crash/non-fatal:
///   medicine_count, profile_count, current_screen, user_region, ui_language
class AppCrashlyticsService {
  AppCrashlyticsService({FirebaseCrashlytics? crashlytics})
      : _crashlytics = crashlytics;

  final FirebaseCrashlytics? _crashlytics;

  factory AppCrashlyticsService.resolveDefault() {
    if (Firebase.apps.isEmpty || kIsWeb) {
      return AppCrashlyticsService(crashlytics: null);
    }
    return AppCrashlyticsService(
      crashlytics: FirebaseCrashlytics.instance,
    );
  }

  // ── PRD §12.7: 5 required custom keys ──────────────────────────────────────

  Future<void> setMedicineCount(int count) async {
    await _crashlytics?.setCustomKey('medicine_count', count);
  }

  Future<void> setProfileCount(int count) async {
    await _crashlytics?.setCustomKey('profile_count', count);
  }

  Future<void> setCurrentScreen(String screenName) async {
    await _crashlytics?.setCustomKey('current_screen', screenName);
  }

  Future<void> setUserRegion(String region) async {
    await _crashlytics?.setCustomKey('user_region', region);
  }

  Future<void> setUiLanguage(String languageCode) async {
    await _crashlytics?.setCustomKey('ui_language', languageCode);
  }

  // ── Non-fatal logging at critical paths (PRD §12.7) ────────────────────────

  /// Log a non-fatal error at a critical path (alarm scheduling, DB, boot).
  Future<void> recordNonFatal(
    Object error,
    StackTrace stack, {
    String? context,
  }) async {
    if (context != null) {
      await _crashlytics?.setCustomKey('error_context', context);
    }
    await _crashlytics?.recordError(error, stack, fatal: false);
  }

  /// Convenience for logging a descriptive non-fatal message without an exception.
  Future<void> logNonFatalMessage(
    String message, {
    String? context,
  }) async {
    await recordNonFatal(
      Exception(message),
      StackTrace.current,
      context: context,
    );
  }
}
