import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:med_reminder/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';

import 'core/providers/AppBootstrapInitializationProvider.dart';
import 'core/providers/AppLocalNotificationsServiceProvider.dart';
import 'core/constants/AppRootScaffoldMessengerKey.dart';
import 'core/routing/AppNavigationGoRouterConfig.dart';
import 'core/constants/AppAnalyticsEventNamesConstants.dart';
import 'core/constants/AppAnalyticsParameterNamesConstants.dart';
import 'core/analytics/AppPrdAnalyticsBootRescheduleHandler.dart';
import 'core/analytics/AppPrdAnalyticsSystemLifecycleHandler.dart';
import 'core/analytics/AppPrdAnalyticsBridge.dart';
import 'core/services/AppFirebaseAnalyticsLoggingService.dart';
import 'core/services/AppLocalNotificationsSchedulingService.dart';
import 'features/medicines/application/MedicineAppDataNotifier.dart';
import 'core/services/AppMobileAdsConsentBootstrapService.dart';
import 'core/theme/AppMedicineReminderCupertinoThemeData.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_fonts.dart';
import 'package:google_fonts/google_fonts.dart';

/// Root widget: localization, theming, and [GoRouter].
class MedicineReminderRootAppWidget extends ConsumerStatefulWidget {
  const MedicineReminderRootAppWidget({super.key});

  @override
  ConsumerState<MedicineReminderRootAppWidget> createState() =>
      _MedicineReminderRootAppWidgetState();
}

class _MedicineReminderRootAppWidgetState
    extends ConsumerState<MedicineReminderRootAppWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      registerNotificationActionHandler(ref);
      AppPrdAnalyticsBootRescheduleHandler.runAfterBootstrapIfNeeded(ref);
      AppPrdAnalyticsSystemLifecycleHandler.runAfterBootstrapIfNeeded(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bootstrap = ref.watch(appBootstrapInitializationProvider);
    final router = ref.watch(appGoRouterProvider);
    final cupertinoTheme =
        AppMedicineReminderCupertinoThemeData.buildCupertinoTheme();
    if (bootstrap.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppMedicineReminderCupertinoThemeData.buildMaterialTheme(),
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Medicine Reminder',
      scaffoldMessengerKey: appRootScaffoldMessengerKey,
      theme: AppMedicineReminderCupertinoThemeData.buildMaterialTheme(),
      routerConfig: router,
      builder: (context, child) {
        return DefaultTextStyle.merge(
          style: AppFonts.inter(color: AppColors.textPrimary),
          child: CupertinoTheme(
            data: cupertinoTheme,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;
  await GoogleFonts.pendingFonts([GoogleFonts.inter()]);

  try {
    await Firebase.initializeApp();

    // PRD §12.7 — Crashlytics: wire Flutter + async error handlers from day 1.
    final crashlytics = FirebaseCrashlytics.instance;
    FlutterError.onError = crashlytics.recordFlutterFatalError;
    // Set default values for the 5 required custom keys so they appear on
    // every crash report, even before the user profile is loaded.
    await crashlytics.setCustomKey('medicine_count', 0);
    await crashlytics.setCustomKey('profile_count', 1);
    await crashlytics.setCustomKey('current_screen', 'startup');
    await crashlytics.setCustomKey('user_region', 'unknown');
    await crashlytics.setCustomKey('ui_language', 'en');
  } catch (e, st) {
    debugPrint('Firebase init skipped until google-services.json is valid: $e');
    debugPrintStack(stackTrace: st);
  }

  await AppMobileAdsConsentBootstrapService.requestConsentAndInitAds();
  final notifications = AppLocalNotificationsSchedulingService();
  await notifications.initializeIfNeeded();

  // PRD §12.7: Wrap entire app in runZonedGuarded so async errors that escape
  // the Flutter error handler are also captured by Crashlytics.
  runZonedGuarded(
    () => runApp(
      ProviderScope(
        overrides: [
          appLocalNotificationsSchedulingServiceProvider.overrideWithValue(
            notifications,
          ),
        ],
        child: const MedicineReminderRootAppWidget(),
      ),
    ),
    (error, stack) {
      if (Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
    },
  );
}

/// Handles cold-start route navigation from Android intents
/// (post-call full-screen activity or alarm).
void registerNotificationActionHandler(WidgetRef ref) {
  const channel = MethodChannel('com.nanogear.med_reminder/alarm');
  channel.setMethodCallHandler((call) async {
    if (call.method == 'onNavigate') {
      final route = call.arguments as String?;
      if (route != null && route.isNotEmpty) {
        ref.read(appGoRouterProvider).push(route);
      }
    }
  });

  // Query startup route if launched by alarm or post-call activity
  channel.invokeMethod<String>('getInitialRoute').then((route) {
    if (route != null && route.isNotEmpty) {
      ref.read(appGoRouterProvider).push(route);
    }
  }).catchError((e) {
    print('[ERROR] getInitialRoute failed: $e');
  });

  // Flutter local notifications disabled; only Android native alarms
  // (DoseAlarmReceiver triggers /alarm route via MethodChannel above)
}
