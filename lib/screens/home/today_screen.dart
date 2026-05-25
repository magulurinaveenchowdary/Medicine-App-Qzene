import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
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
              _HomePermissionWarningBanner(
                onShown: _maybeLogPermissionWarning,
                onTap: () => ref.read(appPrdAnalyticsBridgeProvider).homePermissionWarningTapped('notif|battery|alarms'),
              ),
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

class _HomePermissionWarningBanner extends StatefulWidget {
  const _HomePermissionWarningBanner({required this.onShown, required this.onTap});
  final VoidCallback onShown;
  final VoidCallback onTap;

  @override
  State<_HomePermissionWarningBanner> createState() => _HomePermissionWarningBannerState();
}

class _HomePermissionWarningBannerState extends State<_HomePermissionWarningBanner> {
  var _visible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future.microtask(widget.onShown);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    return Material(
      color: AppColorsDesignTokens.colorWarningTint,
      child: InkWell(
        onTap: widget.onTap,
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
