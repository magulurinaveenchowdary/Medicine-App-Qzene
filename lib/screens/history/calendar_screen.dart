import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/AppCardWidget.dart';
import 'package:med_reminder/core/widgets/common/TabScreenScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/SectionLabelWidget.dart';
import 'package:med_reminder/core/widgets/common/MonthCalendarGridWidget.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

class HistoryCalendarScreen extends ConsumerStatefulWidget {
  const HistoryCalendarScreen({super.key});
  @override
  ConsumerState<HistoryCalendarScreen> createState() => _HistoryCalendarScreenState();
}

class _HistoryCalendarScreenState extends ConsumerState<HistoryCalendarScreen> {
  late DateTime _visibleMonth;
  int _selectedDay = DateTime.now().day;
  String _filterMedicineId = 'all';

  String _filterLabel(List<MedicineStoredRecordModel> medicines) {
    if (_filterMedicineId == 'all') return 'All';
    for (final m in medicines) {
      if (m.medicineId == _filterMedicineId) return m.displayName;
    }
    return 'All';
  }

  Future<void> _showFilterSheet(List<MedicineStoredRecordModel> medicines) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Filter by medicine'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _filterMedicineId = 'all');
              Navigator.pop(ctx);
            },
            child: const Text('All'),
          ),
          for (final m in medicines)
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() => _filterMedicineId = m.medicineId);
                ref.read(appPrdAnalyticsBridgeProvider).historyFilterApplied(m.medicineId);
                Navigator.pop(ctx);
              },
              child: Text(m.displayName),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDay = now.day;
  }

  Widget _buildStatCol({
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: valueColor,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final today = DateTime.now();
    final dataSnapshot = ref.watch(medicineAppDataNotifierProvider).valueOrNull;
    final occurrences = dataSnapshot?.doseOccurrences ?? const [];
    final profileId = ref.watch(activeUserProfileIdProvider);

    final adherence = ref.watch(medicineAppDataNotifierProvider).maybeWhen(
          data: (_) => ref
              .read(medicineAppDataNotifierProvider.notifier)
              .adherencePercentByDayForMonth(_visibleMonth),
          orElse: () => <int, int>{},
        );
    final monthLabel = DateFormat('MMMM yyyy').format(_visibleMonth);
    final medicines = ref.watch(medicineAppDataNotifierProvider).maybeWhen(
          data: (_) => ref
              .read(medicineAppDataNotifierProvider.notifier)
              .medicinesForActiveProfile(),
          orElse: () => <MedicineStoredRecordModel>[],
        );

    // Calculate Month Stats
    final firstDayOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final lastDayOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1).subtract(const Duration(microseconds: 1));

    var takenCount = 0;
    var missedCount = 0;

    final profileOccurrences = occurrences.where((o) => o.profileId == profileId).toList();
    for (final o in profileOccurrences) {
      if (_filterMedicineId != 'all' && o.medicineId != _filterMedicineId) continue;

      final scheduled = DateTime.tryParse(o.scheduledAtIso);
      if (scheduled == null) continue;
      if (scheduled.isBefore(firstDayOfMonth) || scheduled.isAfter(lastDayOfMonth)) continue;

      var status = o.statusKind;
      if (status == MedicineDoseStatusKind.upcoming &&
          scheduled.isBefore(today.subtract(const Duration(minutes: 60)))) {
        status = MedicineDoseStatusKind.missed;
      }

      if (status == MedicineDoseStatusKind.taken) {
        takenCount++;
      } else if (status == MedicineDoseStatusKind.missed || status == MedicineDoseStatusKind.skipped) {
        missedCount++;
      }
    }

    final totalRelevant = takenCount + missedCount;
    final adherencePercent = totalRelevant > 0 ? ((takenCount / totalRelevant) * 100).round() : 0;

    return TabScreenScaffold(
      header: Material(
        color: AppColors.cardWhite,
        child: Container(
          padding: const EdgeInsets.fromLTRB(AppDimensions.paddingScreenH, 10, AppDimensions.paddingScreenH, 12),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
          child: Row(
            children: [
              Expanded(child: Text(l10n.historyTitle, style: AppTextStyles.screenTitle)),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingScreenH),
        children: [
          if (medicines.isNotEmpty)
            AppCard(
              onTap: () => _showFilterSheet(medicines),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Filter by medicine',
                      style: AppTextStyles.cardSubtitle.copyWith(fontSize: 13),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${_filterLabel(medicines)} ›',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.cardSubtitle.copyWith(
                        fontSize: 13,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppDimensions.gapMD),
          MonthCalendarGridWidget(
            monthLabel: monthLabel,
            visibleMonth: _visibleMonth,
            selectedDay: _selectedDay,
            todayDay: today.month == _visibleMonth.month && today.year == _visibleMonth.year ? today.day : -1,
            adherencePercentByDay: adherence,
            onPreviousMonth: () => setState(() {
              _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
            }),
            onNextMonth: () => setState(() {
              _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
            }),
            onDayTap: (day) {
              final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
              final today = DateTime.now();
              final daysAgo = DateTime(today.year, today.month, today.day)
                  .difference(DateTime(date.year, date.month, date.day))
                  .inDays;
              final pct = adherence[day] ?? 0;
              final color = pct >= 80 ? 'green' : (pct >= 50 ? 'amber' : 'red');
              ref.read(appPrdAnalyticsBridgeProvider).historyDayTapped(
                    daysAgo: daysAgo,
                    adherenceColor: color,
                  );
              context.push('/main/history/day/${DateFormat('yyyy-MM-dd').format(date)}');
            },
          ),
          const SizedBox(height: AppDimensions.gapMD),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(
                  text: _visibleMonth.month == today.month && _visibleMonth.year == today.year
                      ? 'THIS MONTH'
                      : DateFormat('MMMM').format(_visibleMonth).toUpperCase(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildStatCol(
                        value: '$adherencePercent%',
                        label: 'Adherence',
                        valueColor: AppColors.healthGreen,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCol(
                        value: '$takenCount',
                        label: 'Taken',
                        valueColor: AppColors.textPrimary,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCol(
                        value: '$missedCount',
                        label: 'Missed',
                        valueColor: AppColors.errorRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
