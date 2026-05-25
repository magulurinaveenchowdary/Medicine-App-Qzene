import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/core/services/AppAndroidPermissionsRequestService.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/TabScreenScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/PermissionSetupCardWidget.dart';
import 'package:med_reminder/core/widgets/SettingsScreenWidgets/SettingsGroupWidget.dart';
import 'package:med_reminder/l10n/app_localizations.dart';
import 'package:med_reminder/screens/onboarding/permissions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsMenuScreen extends ConsumerStatefulWidget {
  const SettingsMenuScreen({super.key});
  @override
  ConsumerState<SettingsMenuScreen> createState() => _SettingsMenuScreenState();
}

class _SettingsMenuScreenState extends ConsumerState<SettingsMenuScreen>
    with WidgetsBindingObserver {
  var vibrationOn = true;
  var afterCallOn = true;
  var selectedSoundId = 'chime';
  var selectedSnoozeMin = 10;
  var selectedAutomiss = '60';
  var selectedTheme = 'light';
  var selectedLanguage = 'en';
  var selectedRegion = 'OTHER';

  bool _notifGranted = false;
  bool _batteryGranted = false;
  bool _alarmsGranted = false;
  bool _fullScreenGranted = false;
  bool _awaitingBatteryReturn = false;
  bool _awaitingFullScreenReturn = false;

  AppAndroidPermissionsRequestService get _svc =>
      ref.read(appAndroidPermissionsRequestServiceProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _onAppResumed();
  }

  Future<void> _onAppResumed() async {
    if (_awaitingBatteryReturn) {
      final granted = await _svc.isBatteryOptimizationExemptionGranted();
      if (!mounted) return;
      if (granted) {
        _awaitingBatteryReturn = false;
        setState(() => _batteryGranted = true);
      }
    }
    if (_awaitingFullScreenReturn) {
      final granted = await _svc.isFullScreenIntentGranted();
      if (!mounted) return;
      if (granted) {
        _awaitingFullScreenReturn = false;
        setState(() => _fullScreenGranted = true);
      }
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final hasPermission = await Permission.phone.isGranted;
    final notif = (await Permission.notification.status).isGranted;
    final battery = await _svc.isBatteryOptimizationExemptionGranted();
    final alarms = await _svc.isExactAlarmPermissionGranted();
    final fullScreen = await _svc.isFullScreenIntentGranted();
    if (mounted) {
      setState(() {
        afterCallOn = hasPermission && (prefs.getBool('after_call_enabled') ?? true);
        _notifGranted = notif;
        _batteryGranted = battery;
        _alarmsGranted = alarms;
        _fullScreenGranted = fullScreen;
      });
    }
  }

  Future<void> _allowNotif() async {
    final granted = await _svc.requestNotificationPermission();
    if (!mounted) return;
    setState(() => _notifGranted = granted);
  }

  Future<void> _allowBattery() async {
    if (await _svc.isBatteryOptimizationExemptionGranted()) {
      if (!mounted) return;
      setState(() => _batteryGranted = true);
      return;
    }
    final granted = await _svc.requestBatteryOptimizationExemption();
    if (!mounted) return;
    if (granted) {
      setState(() => _batteryGranted = true);
      return;
    }
    _awaitingBatteryReturn = true;
    await _svc.openBatteryOptimizationSettings();
  }

  Future<void> _allowAlarms() async {
    final granted = await _svc.requestScheduleExactAlarm();
    if (!mounted) return;
    setState(() => _alarmsGranted = granted);
  }

  Future<void> _allowFullScreen() async {
    _awaitingFullScreenReturn = true;
    await _svc.openFullScreenIntentSettings();
  }

  Future<void> _onAfterCallToggleTap() async {
    if (afterCallOn) {
      final confirmed = await context.push<bool>('/after-call/disable-confirm');
      if (confirmed == true && mounted) {
        setState(() => afterCallOn = false);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('after_call_enabled', false);
        ref.read(appPrdAnalyticsBridgeProvider).settingsAftercallToggled(false);
      }
      return;
    }
    
    // Request phone permission when turning ON
    final status = await Permission.phone.request();
    if (status.isGranted) {
      if (mounted) {
        setState(() => afterCallOn = true);
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('after_call_enabled', true);
      ref.read(appPrdAnalyticsBridgeProvider).settingsAftercallToggled(true);
    } else {
      if (mounted) {
        setState(() => afterCallOn = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone permission is required to show reminders after calls.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bridge = ref.read(appPrdAnalyticsBridgeProvider);
    return TabScreenScaffold(
      header: Material(
        color: AppColors.cardWhite,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.paddingScreenH,
            10,
            AppDimensions.paddingScreenH,
            12,
          ),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(l10n.settingsTitle, style: AppTextStyles.screenTitle),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingScreenH),
        children: [
          SettingsGroupWidget(
            rows: [
              WireframeSettingsRowData(
                label: 'Notification sound',
                valueLabel: selectedSoundId,
                onTap: () async {
                  final next = selectedSoundId == 'chime' ? 'bell' : 'chime';
                  setState(() => selectedSoundId = next);
                  await bridge.settingsSoundChanged(next);
                },
              ),
              WireframeSettingsRowData(
                label: 'Vibration',
                showToggle: true,
                toggleOn: vibrationOn,
                onTap: () => setState(() => vibrationOn = !vibrationOn),
              ),
              WireframeSettingsRowData(
                label: 'Default snooze',
                valueLabel: '$selectedSnoozeMin min',
                onTap: () async {
                  const options = [1, 3, 5, 10, 30, 45, 60];
                  final idx = options.indexOf(selectedSnoozeMin);
                  final next = options[(idx + 1) % options.length];
                  setState(() => selectedSnoozeMin = next);
                  await bridge.settingsSnoozeDefaultChanged(next);
                },
              ),
              WireframeSettingsRowData(
                label: 'Auto-miss timeout',
                valueLabel: '$selectedAutomiss min',
                onTap: () async {
                  final next = selectedAutomiss == '60' ? '30' : '60';
                  setState(() => selectedAutomiss = next);
                  await bridge.settingsAutomissChanged(next);
                },
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.gapMD),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'APP PERMISSIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          PermissionSetupCard(
            title: 'Notifications',
            subtitle: _notifGranted
                ? 'Reminders will be delivered on time.'
                : 'Required to deliver dose reminders.',
            icon: CupertinoIcons.bell_fill,
            iconBackground: AppColorsDesignTokens.colorHealthTint,
            iconColor: AppColorsDesignTokens.colorHealth,
            isGranted: _notifGranted,
            isRequired: !_notifGranted,
            onAllow: _notifGranted ? null : _allowNotif,
          ),
          PermissionSetupCard(
            title: 'Battery optimization',
            subtitle: _batteryGranted
                ? 'Background reminders are protected.'
                : 'Prevents Android from stopping reminders in the background.',
            icon: CupertinoIcons.battery_full,
            iconBackground: AppColorsDesignTokens.colorWarningTint,
            iconColor: AppColorsDesignTokens.colorWarning,
            isGranted: _batteryGranted,
            isRequired: !_batteryGranted,
            onAllow: _batteryGranted ? null : _allowBattery,
          ),
          PermissionSetupCard(
            title: 'Exact alarms',
            subtitle: _alarmsGranted
                ? 'Reminders fire at the exact scheduled time.'
                : 'Needed to fire reminders at the exact scheduled time.',
            icon: CupertinoIcons.alarm_fill,
            iconBackground: AppColorsDesignTokens.colorPrimaryTint,
            iconColor: AppColorsDesignTokens.colorPrimary,
            isGranted: _alarmsGranted,
            isRequired: !_alarmsGranted,
            onAllow: _alarmsGranted ? null : _allowAlarms,
          ),
          PermissionSetupCard(
            title: 'Full-screen alerts',
            subtitle: _fullScreenGranted
                ? 'Alarm screens will appear automatically.'
                : 'Lets alarm screens appear automatically without tapping the notification.',
            icon: CupertinoIcons.device_phone_portrait,
            iconBackground: AppColorsDesignTokens.colorPrimaryTint,
            iconColor: AppColorsDesignTokens.colorPrimary,
            isGranted: _fullScreenGranted,
            isRequired: !_fullScreenGranted,
            onAllow: _fullScreenGranted ? null : _allowFullScreen,
          ),
          const SizedBox(height: AppDimensions.gapMD),
          SettingsGroupWidget(
            rows: [
              WireframeSettingsRowData(
                label: 'Time format',
                valueLabel: '12-hour',
              ),
              WireframeSettingsRowData(
                label: 'Language',
                valueLabel: selectedLanguage == 'en' ? 'English' : selectedLanguage,
                onTap: () async {
                  final from = selectedLanguage;
                  final to = from == 'en' ? 'es' : 'en';
                  setState(() => selectedLanguage = to);
                  await bridge.settingsLanguageChanged(from, to);
                },
              ),
              WireframeSettingsRowData(
                label: 'Region',
                valueLabel: selectedRegion,
                onTap: () async {
                  final from = selectedRegion;
                  final to = from == 'US' ? 'IN' : 'US';
                  setState(() => selectedRegion = to);
                  await bridge.settingsRegionChanged(from, to);
                },
              ),
              WireframeSettingsRowData(
                label: 'Theme',
                valueLabel: selectedTheme,
                onTap: () async {
                  final next = selectedTheme == 'light' ? 'dark' : 'light';
                  setState(() => selectedTheme = next);
                  await bridge.settingsThemeChanged(next);
                },
              ),
              WireframeSettingsRowData(
                label: 'After-call screen',
                showToggle: true,
                toggleOn: afterCallOn,
                onTap: _onAfterCallToggleTap,
              ),
              WireframeSettingsRowData(
                label: 'Profiles',
                valueLabel: 'Manage',
                onTap: () => context.push('/main/settings/profiles'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
