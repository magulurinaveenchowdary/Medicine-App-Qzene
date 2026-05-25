import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/AppAnalyticsEventNamesConstants.dart';
import 'package:med_reminder/core/constants/AppAnalyticsParameterNamesConstants.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsSupportProviders.dart';
import 'package:med_reminder/core/services/AppFirebaseAnalyticsLoggingService.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/AdBannerWidget.dart';
import 'package:med_reminder/core/widgets/common/AppCardWidget.dart';
import 'package:med_reminder/core/widgets/common/MedicineTileWidget.dart';
import 'package:med_reminder/core/widgets/common/PrimaryActionButtonWidget.dart';
import 'package:med_reminder/core/widgets/AlarmScreenWidgets/SecondaryActionButtonWidget.dart';
import 'package:med_reminder/core/widgets/common/SectionLabelWidget.dart';
import 'package:med_reminder/core/widgets/common/MedicinePillIconWidget.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

class AlarmFullscreenScreen extends ConsumerStatefulWidget {
  const AlarmFullscreenScreen({
    super.key,
    required this.isConsolidatedAlarm,
    this.showPerMedMenu = false,
    this.initialOccurrenceId,
  });

  final bool isConsolidatedAlarm;
  final bool showPerMedMenu;
  final String? initialOccurrenceId;

  @override
  ConsumerState<AlarmFullscreenScreen> createState() => _AlarmFullscreenScreenState();
}

class _AlarmFullscreenScreenState extends ConsumerState<AlarmFullscreenScreen> {
  late final DateTime _openedAt;

  @override
  void initState() {
    _openedAt = DateTime.now();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final rows = ref.read(medicineAppDataNotifierProvider).maybeWhen(
            data: (_) => ref
                .read(medicineAppDataNotifierProvider.notifier)
                .doseRowsForDate(now),
            orElse: () => <MedicineDoseDisplayRowModel>[],
          );
      final bridge = ref.read(appPrdAnalyticsBridgeProvider);
      ref.read(appFirebaseAnalyticsLoggingServiceProvider).logPrdEvent(
        AppAnalyticsEventNamesConstants.alarmFired,
        {
          AppAnalyticsParameterNamesConstants.medCount: rows.length.clamp(1, 99),
          AppAnalyticsParameterNamesConstants.isConsolidated:
              widget.isConsolidatedAlarm,
          AppAnalyticsParameterNamesConstants.timeToFireActualMs: 0,
        },
      );
      // PRD §12.3, Screen 12 — sys_alarm_late: fire if alarm fired >60s late.
      if (widget.initialOccurrenceId != null) {
        final notifier = ref.read(medicineAppDataNotifierProvider.notifier);
        final occurrence = notifier.occurrenceById(widget.initialOccurrenceId!);
        if (occurrence != null) {
          final scheduledAt = DateTime.tryParse(occurrence.scheduledAtIso);
          if (scheduledAt != null) {
            final delayMs = now.difference(scheduledAt).inMilliseconds;
            if (delayMs > 60000) {
              // Best-effort Doze detection: if delay > 5 min assume Doze was active.
              final wasInDoze = delayMs > 300000;
              bridge.sysAlarmLate(
                medicineId: occurrence.medicineId,
                delaySeconds: delayMs ~/ 1000,
                wasInDoze: wasInDoze,
              );
            }
          }
        }
      }
      if (!widget.isConsolidatedAlarm) {
        bridge.adFullscreenLoaded(rows.length.clamp(1, 99));
        bridge.adFullscreenViewed();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isConsolidatedAlarm) {
      return _ConsolidatedAlarmBody(
        openedAt: _openedAt,
        showPerMedMenu: widget.showPerMedMenu,
      );
    }
    return _SingleAlarmBody(
      openedAt: _openedAt,
      occurrenceId: widget.initialOccurrenceId,
    );
  }
}

class _AlarmClockHeader extends StatelessWidget {
  const _AlarmClockHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          CupertinoIcons.alarm,
          size: 28,
          color: AppColors.primaryBlue,
        ),
        const SizedBox(height: 4),
        Text('8:00 AM', style: AppTextStyles.bigTime),
        Text(
          'Tuesday, March 18',
          style: AppTextStyles.cardSubtitle.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}

class _SingleAlarmBody extends ConsumerWidget {
  const _SingleAlarmBody({required this.openedAt, this.occurrenceId});
  final DateTime openedAt;
  final String? occurrenceId;

  void _openSnooze(BuildContext context, MedicineDoseDisplayRowModel? row) {
    final medicineId = row?.medicineId ?? '';
    context.push('/alarm/snooze?medicineId=$medicineId&consolidated=0');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(medicineAppDataNotifierProvider).maybeWhen(
          data: (_) {
            final notifier = ref.read(medicineAppDataNotifierProvider.notifier);
            if (occurrenceId != null) {
              final all = notifier.doseRowsForDate(DateTime.now());
              final match = all.where((r) => r.occurrenceId == occurrenceId);
              if (match.isNotEmpty) return match.toList();
            }
            return notifier.upcomingDoseRowsWithinMinutes(120);
          },
          orElse: () => <MedicineDoseDisplayRowModel>[],
        );
    final row = rows.isNotEmpty ? rows.first : null;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop || row == null) return;
        final dwell = DateTime.now().difference(openedAt).inSeconds;
        await ref.read(appPrdAnalyticsBridgeProvider).alarmDismissedNoAction(
              medCount: 1,
              dwelltimeSec: dwell,
              unhandledCount: 1,
            );
      },
      child: Material(
      color: AppColors.cardWhite,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.paddingScreenH,
            20,
            AppDimensions.paddingScreenH,
            20,
          ),
          child: Column(
            children: [
              const _AlarmClockHeader(),
              const SizedBox(height: AppDimensions.gapLG),
              AppCard(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlueTint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const MedicinePillIconWidget(
                        size: 32,
                        primaryColor: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      row?.medicineDisplayName ?? 'Medicine',
                      style: AppTextStyles.screenTitle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      row?.doseDescription ?? 'Time for your dose',
                      style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryActionButton.take(
                label: 'Take ✓',
                onPressed: row == null
                    ? () => context.pop()
                    : () async {
                        await ref.read(appFirebaseAnalyticsLoggingServiceProvider).logPrdEvent(
                          AppAnalyticsEventNamesConstants.alarmTakeTapped,
                          {
                            AppAnalyticsParameterNamesConstants.medicineId:
                                row.medicineId,
                            AppAnalyticsParameterNamesConstants.snoozesBefore: 0,
                            AppAnalyticsParameterNamesConstants.secondsToAction: 0,
                          },
                        );
                        await ref.read(medicineAppDataNotifierProvider.notifier).markDoseTaken(row.occurrenceId);
                        if (context.mounted) context.pop();
                      },
              ),
              const SizedBox(height: AppDimensions.gapSM),
              Row(
                children: [
                  Expanded(
                    child: SecondaryActionButton(
                      label: 'Snooze',
                      variant: SecondaryActionButtonVariant.snooze,
                      onPressed: () => _openSnooze(context, row),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.gapSM),
                  Expanded(
                    child: SecondaryActionButton(
                      label: 'Skip',
                      variant: SecondaryActionButtonVariant.skip,
                      onPressed: () async {
                        if (row != null) {
                          await ref.read(appPrdAnalyticsBridgeProvider).alarmSkipTapped(row.medicineId);
                        }
                        if (context.mounted) context.pop();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => ref.read(appPrdAnalyticsBridgeProvider).adFullscreenClicked(),
                child: const AdBanner(placement: 'alarm_fullscreen'),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _ConsolidatedAlarmBody extends ConsumerStatefulWidget {
  const _ConsolidatedAlarmBody({
    required this.openedAt,
    required this.showPerMedMenu,
  });

  final DateTime openedAt;
  final bool showPerMedMenu;

  @override
  ConsumerState<_ConsolidatedAlarmBody> createState() => _ConsolidatedAlarmBodyState();
}

class _ConsolidatedAlarmBodyState extends ConsumerState<_ConsolidatedAlarmBody> {
  int? _openMenuIndex;

  void _openSnoozeSheet(int medCount) {
    context.push('/alarm/snooze?consolidated=1&medCount=$medCount');
  }

  Future<void> _onPopInvoked(bool didPop, List<MedicineDoseDisplayRowModel> rows) async {
    if (!didPop) return;
    final bridge = ref.read(appPrdAnalyticsBridgeProvider);
    final counts = ref.read(alarmSessionActionCountsProvider);
    final medCount = rows.length.clamp(1, 99);
    final dwell = DateTime.now().difference(widget.openedAt).inSeconds;
    if (counts.hasMixedActions) {
      await bridge.alarmMixedResolution(
        medCount: medCount,
        takeCount: counts.takeCount,
        snoozeCount: counts.snoozeCount,
        skipCount: counts.skipCount,
      );
    } else if (counts.takeCount == 0 &&
        counts.snoozeCount == 0 &&
        counts.skipCount == 0) {
      await bridge.alarmDismissedNoAction(
        medCount: medCount,
        dwelltimeSec: dwell,
        unhandledCount: medCount,
      );
    }
    ref.read(alarmSessionActionCountsProvider.notifier).state =
        const AlarmSessionActionCountsModel();
  }

  Future<void> _perMedAction({
    required MedicineDoseDisplayRowModel row,
    required int position,
    required int total,
    required String action,
    int? snoozeMin,
  }) async {
    final bridge = ref.read(appPrdAnalyticsBridgeProvider);
    await bridge.alarmPerMedActionSelected(
      medicineId: row.medicineId,
      action: action,
      position: position,
      snoozeDurationMin: snoozeMin,
    );
    var counts = ref.read(alarmSessionActionCountsProvider);
    if (action == 'take') {
      counts = counts.recordTake();
      await ref.read(medicineAppDataNotifierProvider.notifier).markDoseTaken(row.occurrenceId);
    } else if (action == 'snooze') {
      counts = counts.recordSnooze();
    } else if (action == 'skip') {
      counts = counts.recordSkip();
    }
    ref.read(alarmSessionActionCountsProvider.notifier).state = counts;
    setState(() => _openMenuIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final today = DateTime.now();
    final rows = ref.watch(medicineAppDataNotifierProvider).maybeWhen(
          data: (_) => ref
              .read(medicineAppDataNotifierProvider.notifier)
              .doseRowsForDate(today)
              .where((r) => r.statusKind == MedicineDoseStatusKind.upcoming)
              .toList(),
          orElse: () => <MedicineDoseDisplayRowModel>[],
        );

    return PopScope(
      onPopInvokedWithResult: (didPop, _) => _onPopInvoked(didPop, rows),
      child: Material(
        color: AppColors.cardWhite,
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 14, bottom: 8),
                child: _AlarmClockHeader(),
              ),
              Expanded(
                child: ColoredBox(
                  color: AppColors.backgroundGrey,
                  child: ListView(
                    padding: const EdgeInsets.all(AppDimensions.paddingScreenH),
                    children: [
                      SectionLabel(text: '${rows.length} medicines due'),
                      for (var i = 0; i < rows.length; i++)
                        MedicineTile(
                          rowModel: rows[i],
                          showKebabMenu: true,
                          showPopoverMenu: _openMenuIndex == i || (widget.showPerMedMenu && i == 0),
                          onKebabTap: () async {
                            await ref.read(appPrdAnalyticsBridgeProvider).alarmPerMedMenuOpened(
                                  medicineId: rows[i].medicineId,
                                  position: i + 1,
                                  totalMedCount: rows.length,
                                );
                            setState(() => _openMenuIndex = i);
                          },
                          onPerMedTake: () => _perMedAction(
                            row: rows[i],
                            position: i + 1,
                            total: rows.length,
                            action: 'take',
                          ),
                          onPerMedSnooze: () {
                            _perMedAction(
                              row: rows[i],
                              position: i + 1,
                              total: rows.length,
                              action: 'snooze',
                              snoozeMin: 10,
                            );
                            _openSnoozeSheet(rows.length);
                          },
                          onPerMedSkip: () => _perMedAction(
                            row: rows[i],
                            position: i + 1,
                            total: rows.length,
                            action: 'skip',
                          ),
                        ),
                      Text(
                        'Or apply one action to all',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.cardSubtitle.copyWith(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.gapSM),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryActionButton(
                              label: l10n.skipAll,
                              variant: SecondaryActionButtonVariant.skip,
                              onPressed: () async {
                                await ref.read(appPrdAnalyticsBridgeProvider).alarmSkipAllTapped(rows.length);
                                ref.read(alarmSessionActionCountsProvider.notifier).state =
                                    AlarmSessionActionCountsModel(skipCount: rows.length);
                                if (context.mounted) context.pop();
                              },
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SecondaryActionButton(
                              label: l10n.snoozeAll,
                              variant: SecondaryActionButtonVariant.snooze,
                              onPressed: () => _openSnoozeSheet(rows.length),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: PrimaryActionButton.take(
                              label: l10n.takeAll,
                              onPressed: () async {
                                await ref.read(appPrdAnalyticsBridgeProvider).alarmTakeAllTapped(rows.length);
                                ref.read(alarmSessionActionCountsProvider.notifier).state =
                                    AlarmSessionActionCountsModel(takeCount: rows.length);
                                for (final row in rows) {
                                  await ref
                                      .read(medicineAppDataNotifierProvider.notifier)
                                      .markDoseTaken(row.occurrenceId);
                                }
                                if (context.mounted) context.pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
