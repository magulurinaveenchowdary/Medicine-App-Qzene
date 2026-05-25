import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/AppAnalyticsEventNamesConstants.dart';
import 'package:med_reminder/core/constants/AppAnalyticsParameterNamesConstants.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/core/services/AppAndroidPermissionsRequestService.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/services/AppFirebaseAnalyticsLoggingService.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/OnboardingAnalyticsPopScopeWidget.dart';
import 'package:med_reminder/core/theme/AppTypographyDesignTokens.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/OnboardingPageLayoutWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/OnboardingPrimaryButtonWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/PermissionSetupCardWidget.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

final appAndroidPermissionsRequestServiceProvider =
    Provider<AppAndroidPermissionsRequestService>(
  (ref) => AppAndroidPermissionsRequestService(),
);

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});
  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen>
    with WidgetsBindingObserver {
  var notificationGranted = false;
  var batteryGranted = false;
  var alarmsGranted = false;
  var _awaitingBatterySettingsReturn = false;
  var _awaitingAlarmsSettingsReturn = false;
  var _notifPromptLogged = false;
  var _batteryPromptLogged = false;
  var _alarmsPromptLogged = false;

  AppFirebaseAnalyticsLoggingService get _analytics =>
      ref.read(appFirebaseAnalyticsLoggingServiceProvider);

  AppAndroidPermissionsRequestService get _permissions =>
      ref.read(appAndroidPermissionsRequestServiceProvider);

  String get _androidVersionParam =>
      Platform.isAndroid ? Platform.operatingSystemVersion : 'unknown';

  bool get _canContinue => batteryGranted && alarmsGranted;

  Future<void> _applyBatteryGranted(bool granted) async {
    if (!mounted || batteryGranted == granted) return;
    setState(() => batteryGranted = granted);
    await _analytics.logPrdEvent(
      AppAnalyticsEventNamesConstants.onbBatteryExemptionResult,
      {
        AppAnalyticsParameterNamesConstants.result:
            granted ? 'granted' : 'denied',
      },
    );
    await _analytics.syncBatteryExemptUserProperty(granted);
  }

  Future<void> _applyAlarmsGranted(bool granted) async {
    if (!mounted || alarmsGranted == granted) return;
    setState(() => alarmsGranted = granted);
    await _analytics.logPrdEvent(
      AppAnalyticsEventNamesConstants.onbAlarmsPermissionResult,
      {
        AppAnalyticsParameterNamesConstants.result:
            granted ? 'granted' : 'denied',
      },
    );
  }

  Future<void> _logNotifShownOnce() async {
    if (_notifPromptLogged) return;
    _notifPromptLogged = true;
    await _analytics.logPrdEvent(
      AppAnalyticsEventNamesConstants.onbNotifPermissionShown,
      {AppAnalyticsParameterNamesConstants.androidVersion: _androidVersionParam},
    );
  }

  Future<void> _logBatteryShownOnce() async {
    if (_batteryPromptLogged) return;
    _batteryPromptLogged = true;
    await _analytics.logPrdEvent(
      AppAnalyticsEventNamesConstants.onbBatteryExemptionShown,
    );
  }

  Future<void> _logAlarmsShownOnce() async {
    if (_alarmsPromptLogged) return;
    _alarmsPromptLogged = true;
    await _analytics.logPrdEvent(
      AppAnalyticsEventNamesConstants.onbAlarmsPermissionShown,
      {AppAnalyticsParameterNamesConstants.androidVersion: _androidVersionParam},
    );
  }

  Future<void> _onAllowNotificationTap() async {
    await _logNotifShownOnce();
    final ok = await _permissions.requestNotificationPermission();
    if (!mounted) return;
    setState(() => notificationGranted = ok);
    await _analytics.logPrdEvent(
      AppAnalyticsEventNamesConstants.onbNotifPermissionResult,
      {
        AppAnalyticsParameterNamesConstants.result: ok ? 'granted' : 'denied',
      },
    );
    await _analytics.syncNotificationsGrantedUserProperty(ok);
  }

  Future<void> _onAllowBatteryTap() async {
    await _logBatteryShownOnce();
    if (await _permissions.isBatteryOptimizationExemptionGranted()) {
      await _applyBatteryGranted(true);
      return;
    }
    _awaitingBatterySettingsReturn = true;
    final granted = await _permissions.requestBatteryOptimizationExemption();
    if (!mounted) return;
    if (granted) {
      _awaitingBatterySettingsReturn = false;
      await _applyBatteryGranted(true);
      return;
    }
    final opened = await _permissions.openBatteryOptimizationSettings();
    if (!mounted) return;
    if (!opened) {
      _awaitingBatterySettingsReturn = false;
    }
  }

  Future<void> _onAllowAlarmsTap() async {
    await _logAlarmsShownOnce();
    final launchResult = await _permissions.openExactAlarmSettingsForUserGrant(
      forceOpen: true,
    );
    if (!mounted) return;
    if (launchResult.alreadyGranted) {
      await _applyAlarmsGranted(true);
      return;
    }
    if (launchResult.openedSettings) {
      _awaitingAlarmsSettingsReturn = true;
      return;
    }
    await _analytics.logPrdEvent(
      AppAnalyticsEventNamesConstants.onbAlarmsPermissionResult,
      {AppAnalyticsParameterNamesConstants.result: 'denied'},
    );
  }

  Future<void> _onAppResumed() async {
    if (_awaitingBatterySettingsReturn) {
      final granted =
          await _permissions.isBatteryOptimizationExemptionGranted();
      if (!mounted) return;
      if (granted) {
        _awaitingBatterySettingsReturn = false;
        await _applyBatteryGranted(true);
      }
    }
    if (_awaitingAlarmsSettingsReturn) {
      _awaitingAlarmsSettingsReturn = false;
      final granted = await _permissions.isExactAlarmPermissionGranted();
      if (!mounted) return;
      await _applyAlarmsGranted(granted);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _logNotifShownOnce();
      final notif = await _permissions.requestNotificationPermission();
      if (mounted) setState(() => notificationGranted = notif);
      await _analytics.logPrdEvent(
        AppAnalyticsEventNamesConstants.onbNotifPermissionResult,
        {
          AppAnalyticsParameterNamesConstants.result:
              notif ? 'granted' : 'denied',
        },
      );
      await _analytics.syncNotificationsGrantedUserProperty(notif);
      final batteryAlreadyGranted =
          await _permissions.isBatteryOptimizationExemptionGranted();
      if (mounted && batteryAlreadyGranted) {
        setState(() => batteryGranted = true);
      }
      if (Platform.isAndroid) {
        await ref.read(appPrdAnalyticsBridgeProvider).onbAutostartShown('other');
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_onAppResumed());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OnboardingAnalyticsPopScope(
      atStep: 'notif',
      child: OnboardingPageLayout(
      stepLabel: l10n.stepProgress(2, 4),
      footerActions: [
        PrimaryButton(
          label: l10n.continueLabel,
          enabled: _canContinue,
          onPressed: () => context.push('/onboarding/language'),
        ),
        const SizedBox(height: 8),
      ],
      children: [
        Text(
          l10n.onboardingPermissionsTitle,
          style: AppTypographyDesignTokens.onboardingTitleMedium.copyWith(
            color: AppColorsDesignTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.onboardingPermissionsBody,
          style: AppTypographyDesignTokens.screenSubtitle.copyWith(
            fontSize: 14,
            height: 1.5,
            color: AppColorsDesignTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        PermissionSetupCard(
          title: l10n.permissionNotifications,
          subtitle: notificationGranted ? l10n.granted : l10n.permissionBatterySubtitle,
          icon: notificationGranted ? CupertinoIcons.checkmark : CupertinoIcons.bell,
          iconBackground: AppColorsDesignTokens.colorHealthTint,
          iconColor: AppColorsDesignTokens.colorHealth,
          isGranted: notificationGranted,
          onAllow: notificationGranted ? null : _onAllowNotificationTap,
        ),
        PermissionSetupCard(
          title: l10n.permissionBattery,
          subtitle: l10n.permissionBatterySubtitle,
          icon: CupertinoIcons.battery_100,
          iconBackground: AppColorsDesignTokens.colorPrimaryTint,
          iconColor: AppColorsDesignTokens.colorPrimary,
          isRequired: true,
          isGranted: batteryGranted,
          onAllow: batteryGranted ? null : _onAllowBatteryTap,
        ),
        PermissionSetupCard(
          title: l10n.permissionAlarms,
          subtitle: alarmsGranted ? l10n.granted : l10n.permissionBatterySubtitle,
          icon: CupertinoIcons.alarm,
          iconBackground: AppColorsDesignTokens.colorPrimaryTint,
          iconColor: AppColorsDesignTokens.colorPrimary,
          isRequired: true,
          isGranted: alarmsGranted,
          onAllow: alarmsGranted ? null : _onAllowAlarmsTap,
        ),
      ],
    ),
    );
  }
}
