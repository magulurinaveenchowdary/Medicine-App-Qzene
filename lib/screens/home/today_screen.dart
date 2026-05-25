import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/core/services/AppAndroidPermissionsRequestService.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/PermissionSetupCardWidget.dart';
import 'package:med_reminder/screens/onboarding/permissions_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:med_reminder/core/constants/AppSpacingLayoutTokens.dart';
import 'package:med_reminder/core/date/week_date_strip_helper.dart';
import 'package:med_reminder/core/constants/AppAnalyticsEventNamesConstants.dart';
import 'package:med_reminder/core/constants/AppAnalyticsParameterNamesConstants.dart';
import 'package:med_reminder/core/analytics/AppAnalyticsMappingHelpers.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsFunnelHelpers.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsSupportProviders.dart';
import 'package:med_reminder/core/services/AppFirebaseAnalyticsLoggingService.dart';
import 'package:med_reminder/core/theme/AppTypographyDesignTokens.dart';
import 'package:med_reminder/core/widgets/HomeScreenWidgets/DoseListCardWidget.dart';
import 'package:med_reminder/core/widgets/HomeScreenWidgets/HomeProfileTopBarWidget.dart';
import 'package:med_reminder/core/widgets/common/TabScreenScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/MedicinePillIconWidget.dart';
import 'package:med_reminder/core/widgets/common/SectionHeaderWidget.dart';
import 'package:med_reminder/features/home/application/AppHomeSelectedDateNotifier.dart';
import 'package:med_reminder/features/home/application/AppHomeVisibleWeekNotifier.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/l10n/app_localizations.dart';
import 'package:med_reminder/screens/home/components/date_strip.dart';
import 'package:med_reminder/screens/home/components/ProfileSwitcherSheetWidget.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});
  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  DateTime? _lastHomeViewStateDay;
  Timer? _dwellTimer;
  DateTime? _dwellLoggedDay;

  @override
  void dispose() {
    _dwellTimer?.cancel();
    super.dispose();
  }

  void _maybeLogPermissionWarning() {
    if (ref.read(homePermissionWarningShownSessionProvider)) return;
    ref.read(homePermissionWarningShownSessionProvider.notifier).state = true;
    ref.read(appPrdAnalyticsBridgeProvider).homePermissionWarningShown('notif|battery|alarms');
  }

  void _scheduleDwellLog({
    required DateTime selectedDay,
    required DateTime todayNorm,
    required bool hasMedsScheduled,
    required bool hasHistory,
  }) {
    _dwellTimer?.cancel();
    final daysDiff = DateTime(selectedDay.year, selectedDay.month, selectedDay.day)
        .difference(todayNorm)
        .inDays;
    if (daysDiff == 0) return;
    _dwellTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      final dayKey = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      if (_dwellLoggedDay == dayKey) return;
      _dwellLoggedDay = dayKey;
      final dateStr = dayKey.toIso8601String().substring(0, 10);
      final bridge = ref.read(appPrdAnalyticsBridgeProvider);
      if (daysDiff < 0) {
        bridge.homeViewPastDate(
          date: dateStr,
          daysBack: daysDiff.abs(),
          hasMedsScheduled: hasMedsScheduled,
          hasHistory: hasHistory,
        );
      } else {
        bridge.homeViewFutureDate(
          date: dateStr,
          daysAhead: daysDiff,
          hasMedsScheduled: hasMedsScheduled,
        );
      }
    });
  }

  void _logHomeViewState({
    required bool hasMedicines,
    required List<MedicineDoseDisplayRowModel> rows,
    required bool viewedDateIsToday,
  }) {
    final due = rows.where((r) => r.statusKind == MedicineDoseStatusKind.upcoming).length;
    final taken = rows.where((r) => r.statusKind == MedicineDoseStatusKind.taken).length;
    final missed = rows.where((r) => r.statusKind == MedicineDoseStatusKind.missed).length;
    ref.read(appFirebaseAnalyticsLoggingServiceProvider).logPrdEvent(
      AppAnalyticsEventNamesConstants.homeViewState,
      {
        AppAnalyticsParameterNamesConstants.state:
            hasMedicines ? 'with_meds' : 'empty',
        AppAnalyticsParameterNamesConstants.dueCount: due,
        AppAnalyticsParameterNamesConstants.takenCount: taken,
        AppAnalyticsParameterNamesConstants.missedCount: missed,
        AppAnalyticsParameterNamesConstants.viewedDateIsToday: viewedDateIsToday,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedDay = ref.watch(appHomeSelectedDateNotifierProvider);
    final todayNorm = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final dataAsync = ref.watch(medicineAppDataNotifierProvider);
    final isToday = isSameCalendarDay(selectedDay, todayNorm);

    return dataAsync.when(
      loading: () => const TabScreenScaffold(
        header: SizedBox.shrink(),
        showFab: false,
        body: Center(child: CupertinoActivityIndicator()),
      ),
      error: (e, _) => TabScreenScaffold(
        header: const SizedBox.shrink(),
        showFab: false,
        body: Center(child: Text('Unable to load medicines: $e')),
      ),
      data: (_) {
        final notifier = ref.read(medicineAppDataNotifierProvider.notifier);
        final profile = notifier.activeProfile();
        final rows = notifier.doseRowsForDate(selectedDay);
        final hasMedicines = notifier.hasAnyMedicinesForProfile;
        final dayKey = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
        if (_lastHomeViewStateDay != dayKey) {
          _lastHomeViewStateDay = dayKey;
          _logHomeViewState(
            hasMedicines: hasMedicines,
            rows: rows,
            viewedDateIsToday: isToday,
          );
          _scheduleDwellLog(
            selectedDay: selectedDay,
            todayNorm: todayNorm,
            hasMedsScheduled: rows.isNotEmpty,
            hasHistory: rows.any((r) => r.statusKind != MedicineDoseStatusKind.upcoming),
          );
        }
        return TabScreenScaffold(
          showFab: isToday,
          onFabPressed: () {
            ref.read(appFirebaseAnalyticsLoggingServiceProvider).logPrdEvent(
              AppAnalyticsEventNamesConstants.homeAddFabTapped,
              {
                AppAnalyticsParameterNamesConstants.currentMedCount:
                    notifier.medicinesForActiveProfile().length,
                AppAnalyticsParameterNamesConstants.viewedDateIsToday: true,
              },
            );
            startAddMedicineFunnelAnalytics(ref, 'home_fab');
            ref.read(addMedicineDraftNotifierProvider.notifier).resetDraft();
            context.push('/add-medicine/name');
          },
          header: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // _HomePermissionWarningBanner(
              //   onShown: _maybeLogPermissionWarning,
              //   onTap: () => ref.read(appPrdAnalyticsBridgeProvider).homePermissionWarningTapped('notif|battery|alarms'),
              // ),
              HomeProfileTopBar(
                profileName: profile.displayName,
                avatarLetter: profile.avatarLetter ?? profile.displayName.characters.first,
                onProfileTap: () => ProfileSwitcherSheetWidget.show(context),
                onCalendarTap: () {
                  ref.read(appFirebaseAnalyticsLoggingServiceProvider).logPrdEvent(
                    AppAnalyticsEventNamesConstants.homeCalendarOpened,
                    {
                      AppAnalyticsParameterNamesConstants.currentViewedDate:
                          selectedDay.toIso8601String().substring(0, 10),
                    },
                  );
                  context.push('/main/today/date-picker');
                },
                onNotificationTap: () {
                  ref.read(appFirebaseAnalyticsLoggingServiceProvider).logPrdEvent(
                    'home_notification_opened',
                    {
                      'profile': profile.displayName,
                    },
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications feature coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              DateStrip(
                selectedDay: selectedDay,
                todayDay: todayNorm,
                onDaySelected: (d) {
                  final daysFromToday = d.difference(todayNorm).inDays;
                  ref.read(appFirebaseAnalyticsLoggingServiceProvider).logPrdEvent(
                    AppAnalyticsEventNamesConstants.homeDateSelected,
                    {
                      AppAnalyticsParameterNamesConstants.selectedDate:
                          d.toIso8601String().substring(0, 10),
                      AppAnalyticsParameterNamesConstants.daysFromToday: daysFromToday,
                      AppAnalyticsParameterNamesConstants.source: 'strip',
                    },
                  );
                  ref
                      .read(appHomeSelectedDateNotifierProvider.notifier)
                      .selectCalendarDay(d);
                  ref
                      .read(appHomeVisibleWeekNotifierProvider.notifier)
                      .showWeekContaining(d);
                },
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColorsDesignTokens.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: !hasMedicines || rows.isEmpty
                    ? _EmptyBody(
                        l10n: l10n,
                        showAddPrompt: !hasMedicines,
                        onAdd: () {
                          startAddMedicineFunnelAnalytics(ref, 'empty_state');
                          ref.read(addMedicineDraftNotifierProvider.notifier).resetDraft();
                          context.push('/add-medicine/name');
                        },
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacingLayoutTokens.phoneContentPadding,
                          AppSpacingLayoutTokens.phoneContentPadding,
                          AppSpacingLayoutTokens.phoneContentPadding,
                          0,
                        ),
                        children: [
                          SectionHeaderWidget(
                            label: l10n.todaysMedicinesHeader(rows.length),
                            backToTodayLabel: !isToday ? l10n.backToToday : null,
                            onBackToToday: !isToday
                                ? () {
                                    ref
                                        .read(appFirebaseAnalyticsLoggingServiceProvider)
                                        .logPrdEvent(
                                      AppAnalyticsEventNamesConstants.homeTodayReturned,
                                      {
                                        AppAnalyticsParameterNamesConstants.fromDate:
                                            selectedDay.toIso8601String().substring(0, 10),
                                        AppAnalyticsParameterNamesConstants.daysFromToday:
                                            selectedDay.difference(todayNorm).inDays,
                                      },
                                    );
                                    ref
                                        .read(appHomeSelectedDateNotifierProvider.notifier)
                                        .jumpToToday();
                                    ref
                                        .read(appHomeVisibleWeekNotifierProvider.notifier)
                                        .showWeekContaining(todayNorm);
                                  }
                                : null,
                          ),
                          for (final r in rows)
                            GestureDetector(
                              onTap: r.statusKind == MedicineDoseStatusKind.upcoming
                                  ? () {
                                      final medicine = ref
                                          .read(medicineAppDataNotifierProvider.notifier)
                                          .medicineById(r.medicineId);
                                      ref.read(appPrdAnalyticsBridgeProvider).homeMedicineTapped(
                                            medicineId: r.medicineId,
                                            scheduleKind: medicine?.scheduleKind ??
                                                MedicineScheduleKind.daily,
                                            status: AppAnalyticsMappingHelpers.doseStatusValue(r.statusKind),
                                            viewedDate: selectedDay.toIso8601String().substring(0, 10),
                                          );
                                      _showDoseActions(context, ref, r);
                                    }
                                  : null,
                              child: DoseListCard(
                                rowModel: r,
                                showAccentBorder: r.isCriticalTint,
                                useEyeDropIcon: r.useEyeDropIcon,
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDoseActions(
    BuildContext context,
    WidgetRef ref,
    MedicineDoseDisplayRowModel row,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(row.medicineDisplayName),
        message: Text(row.doseDescription),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              final analytics = ref.read(appFirebaseAnalyticsLoggingServiceProvider);
              analytics.logPrdEvent(
                AppAnalyticsEventNamesConstants.homeQuickTake,
                {
                  AppAnalyticsParameterNamesConstants.medicineId: row.medicineId,
                  AppAnalyticsParameterNamesConstants.source: 'home_quick',
                },
              );
              ref.read(medicineAppDataNotifierProvider.notifier).markDoseTaken(row.occurrenceId);
              Navigator.pop(ctx);
            },
            child: const Text('Mark as Taken'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              ref.read(medicineAppDataNotifierProvider.notifier).markDoseSnoozed(row.occurrenceId, 10);
              Navigator.pop(ctx);
            },
            child: const Text('Snooze 10 min'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              ref.read(appFirebaseAnalyticsLoggingServiceProvider).logPrdEvent(
                AppAnalyticsEventNamesConstants.homeQuickSkip,
                {
                  AppAnalyticsParameterNamesConstants.medicineId: row.medicineId,
                  AppAnalyticsParameterNamesConstants.source: 'home_quick',
                },
              );
              ref.read(medicineAppDataNotifierProvider.notifier).markDoseSkipped(row.occurrenceId);
              Navigator.pop(ctx);
            },
            child: const Text('Skip'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}

class _HomePermissionWarningBanner extends ConsumerStatefulWidget {
  const _HomePermissionWarningBanner({required this.onShown, required this.onTap});
  final VoidCallback onShown;
  final VoidCallback onTap;

  @override
  ConsumerState<_HomePermissionWarningBanner> createState() => _HomePermissionWarningBannerState();
}

class _HomePermissionWarningBannerState extends ConsumerState<_HomePermissionWarningBanner> {
  var _visible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future.microtask(widget.onShown);
    });
  }

  void _showPermissionsDialog(BuildContext context) {
    final service = ref.read(appAndroidPermissionsRequestServiceProvider);
    showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (_) => _PermissionsReviewDialog(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    return Material(
      color: AppColorsDesignTokens.colorWarningTint,
      child: InkWell(
        onTap: () {
          widget.onTap();
          _showPermissionsDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Some permissions may block reminders. Tap to review.',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: () => setState(() => _visible = false),
                child: const Icon(CupertinoIcons.xmark, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionsReviewDialog extends StatefulWidget {
  const _PermissionsReviewDialog({required this.service});
  final AppAndroidPermissionsRequestService service;

  @override
  State<_PermissionsReviewDialog> createState() => _PermissionsReviewDialogState();
}

class _PermissionsReviewDialogState extends State<_PermissionsReviewDialog>
    with WidgetsBindingObserver {
  bool _notifGranted = false;
  bool _batteryGranted = false;
  bool _alarmsGranted = false;
  bool _fullScreenGranted = false;
  bool _loading = true;
  bool _awaitingBatteryReturn = false;
  bool _awaitingFullScreenReturn = false;

  AppAndroidPermissionsRequestService get _svc => widget.service;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStatus());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadStatus() async {
    if (!Platform.isAndroid) {
      if (mounted) setState(() { _notifGranted = true; _batteryGranted = true; _alarmsGranted = true; _fullScreenGranted = true; _loading = false; });
      return;
    }
    final notif = (await Permission.notification.status).isGranted;
    final battery = await _svc.isBatteryOptimizationExemptionGranted();
    final alarms = await _svc.isExactAlarmPermissionGranted();
    final fullScreen = await _svc.isFullScreenIntentGranted();
    if (!mounted) return;
    setState(() {
      _notifGranted = notif;
      _batteryGranted = battery;
      _alarmsGranted = alarms;
      _fullScreenGranted = fullScreen;
      _loading = false;
    });
    if (notif && battery && alarms && fullScreen) _dismiss();
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
        _maybeAutoDismiss();
      }
    }
    if (_awaitingFullScreenReturn) {
      final granted = await _svc.isFullScreenIntentGranted();
      if (!mounted) return;
      if (granted) {
        _awaitingFullScreenReturn = false;
        setState(() => _fullScreenGranted = true);
        _maybeAutoDismiss();
      }
    }
  }

  void _dismiss() {
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
  }

  void _maybeAutoDismiss() {
    if (_notifGranted && _batteryGranted && _alarmsGranted && _fullScreenGranted) _dismiss();
  }

  Future<void> _allowNotif() async {
    final granted = await _svc.requestNotificationPermission();
    if (!mounted) return;
    setState(() => _notifGranted = granted);
    _maybeAutoDismiss();
  }

  Future<void> _allowBattery() async {
    if (await _svc.isBatteryOptimizationExemptionGranted()) {
      if (!mounted) return;
      setState(() => _batteryGranted = true);
      _maybeAutoDismiss();
      return;
    }
    final granted = await _svc.requestBatteryOptimizationExemption();
    if (!mounted) return;
    if (granted) {
      setState(() => _batteryGranted = true);
      _maybeAutoDismiss();
      return;
    }
    _awaitingBatteryReturn = true;
    await _svc.openBatteryOptimizationSettings();
  }

  Future<void> _allowAlarms() async {
    final granted = await _svc.requestScheduleExactAlarm();
    if (!mounted) return;
    setState(() => _alarmsGranted = granted);
    _maybeAutoDismiss();
  }

  Future<void> _allowFullScreen() async {
    _awaitingFullScreenReturn = true;
    await _svc.openFullScreenIntentSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CupertinoActivityIndicator()),
        ),
      );
    }

    final items = <Widget>[];

    if (!_notifGranted) {
      items.add(PermissionSetupCard(
        title: 'Notifications',
        subtitle: 'Required to deliver dose reminders.',
        icon: CupertinoIcons.bell_fill,
        iconBackground: AppColorsDesignTokens.colorHealthTint,
        iconColor: AppColorsDesignTokens.colorHealth,
        isGranted: false,
        isRequired: true,
        onAllow: _allowNotif,
      ));
    }

    if (!_batteryGranted) {
      items.add(PermissionSetupCard(
        title: 'Battery optimization',
        subtitle: 'Prevents Android from stopping reminders in the background.',
        icon: CupertinoIcons.battery_full,
        iconBackground: AppColorsDesignTokens.colorWarningTint,
        iconColor: AppColorsDesignTokens.colorWarning,
        isGranted: false,
        isRequired: true,
        onAllow: _allowBattery,
      ));
    }

    if (!_alarmsGranted) {
      items.add(PermissionSetupCard(
        title: 'Exact alarms',
        subtitle: 'Needed to fire reminders at the exact scheduled time.',
        icon: CupertinoIcons.alarm_fill,
        iconBackground: AppColorsDesignTokens.colorPrimaryTint,
        iconColor: AppColorsDesignTokens.colorPrimary,
        isGranted: false,
        isRequired: true,
        onAllow: _allowAlarms,
      ));
    }

    if (!_fullScreenGranted) {
      items.add(PermissionSetupCard(
        title: 'Full-screen alerts',
        subtitle: 'Lets alarm screens appear automatically without tapping the notification.',
        icon: CupertinoIcons.device_phone_portrait,
        iconBackground: AppColorsDesignTokens.colorPrimaryTint,
        iconColor: AppColorsDesignTokens.colorPrimary,
        isGranted: false,
        isRequired: true,
        onAllow: _allowFullScreen,
      ));
    }

    if (items.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _dismiss());
      return const SizedBox.shrink();
    }

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Permissions needed',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: _dismiss,
                  child: const Icon(CupertinoIcons.xmark, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Allow these so your reminders work reliably.',
              style: TextStyle(
                fontSize: 13,
                color: AppColorsDesignTokens.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ...items,
          ],
        ),
      ),
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({
    required this.l10n,
    required this.showAddPrompt,
    required this.onAdd,
  });
  final AppLocalizations l10n;
  final bool showAddPrompt;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColorsDesignTokens.colorPrimaryTint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const MedicinePillIconWidget(size: 38),
                ),
                const SizedBox(height: 16),
                Text(
                  showAddPrompt ? l10n.addFirstMedicineTitle : 'No doses scheduled',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColorsDesignTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  showAddPrompt
                      ? l10n.addFirstMedicineBody
                      : 'Tap the + button below to start.',
                  textAlign: TextAlign.center,
                  style: AppTypographyDesignTokens.screenSubtitle.copyWith(
                    fontSize: 13,
                    color: AppColorsDesignTokens.textSecondary,
                  ),
                ),
                if (showAddPrompt) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    child: CupertinoButton.filled(
                      onPressed: onAdd,
                      child: Text(l10n.addMedicine),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
