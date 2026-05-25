import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/TabScreenScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/SettingsScreenWidgets/SettingsGroupWidget.dart';
import 'package:med_reminder/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsMenuScreen extends ConsumerStatefulWidget {
  const SettingsMenuScreen({super.key});
  @override
  ConsumerState<SettingsMenuScreen> createState() => _SettingsMenuScreenState();
}

class _SettingsMenuScreenState extends ConsumerState<SettingsMenuScreen> {
  var vibrationOn = true;
  var afterCallOn = true;
  var selectedSoundId = 'chime';
  var selectedSnoozeMin = 10;
  var selectedAutomiss = '60';
  var selectedTheme = 'light';
  var selectedLanguage = 'en';
  var selectedRegion = 'OTHER';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final hasPermission = await Permission.phone.isGranted;
    if (mounted) {
      setState(() {
        afterCallOn = hasPermission && (prefs.getBool('after_call_enabled') ?? true);
      });
    }
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
