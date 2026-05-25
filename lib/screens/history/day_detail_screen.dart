import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/AdBannerWidget.dart';
import 'package:med_reminder/core/widgets/common/AppCardWidget.dart';
import 'package:med_reminder/core/widgets/common/AddFlowHeaderWidget.dart';
import 'package:med_reminder/core/widgets/common/MedicineTileWidget.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';

class HistoryDayDetailScreen extends ConsumerStatefulWidget {
  const HistoryDayDetailScreen({super.key, required this.dayKey});
  final String dayKey;
  @override
  ConsumerState<HistoryDayDetailScreen> createState() => _HistoryDayDetailScreenState();
}

class _HistoryDayDetailScreenState extends ConsumerState<HistoryDayDetailScreen> {

  DateTime? _parseDayKey() {
    try {
      return DateTime.parse(widget.dayKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = _parseDayKey() ?? DateTime.now();
    final headerTitle = DateFormat('EEEE, MMMM d').format(day);
    final rows = ref.watch(medicineAppDataNotifierProvider).maybeWhen(
          data: (_) => ref.read(medicineAppDataNotifierProvider.notifier).doseRowsForDate(day),
          orElse: () => <MedicineDoseDisplayRowModel>[],
        );
    final takenCount =
        rows.where((r) => r.statusKind == MedicineDoseStatusKind.taken).length;
    final percent = rows.isEmpty ? 0 : ((takenCount / rows.length) * 100).round();

    return Material(
      color: AppColors.backgroundGrey,
      child: SafeArea(
        child: Column(
          children: [
            AddFlowHeader(title: headerTitle),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingScreenH),
                child: Column(
                  children: [
                    AppCard(
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                      child: Column(
                        children: [
                          Text('$percent%', style: AppTextStyles.adherencePercent),
                          const SizedBox(height: 4),
                          Text(
                            rows.isEmpty
                                ? 'Add your first medicine'
                                : '$takenCount of ${rows.length} taken',
                            style: AppTextStyles.cardSubtitle.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.gapMD),
                    Expanded(
                      child: rows.isEmpty
                          ? const Center(child: Text('No dose history for this day'))
                          : ListView(
                              children: [
                                for (final r in rows)
                                  MedicineTile(
                                    rowModel: r,
                                    showScheduledTime: false,
                                    highlightMissedBorder:
                                        r.statusKind == MedicineDoseStatusKind.missed,
                                    footerLink:
                                        r.statusKind == MedicineDoseStatusKind.missed
                                            ? Text(
                                                'Log retroactively →',
                                                style: AppTextStyles.cardSubtitle.copyWith(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primaryBlue,
                                                ),
                                              )
                                            : null,
                                    onFooterTap: r.statusKind == MedicineDoseStatusKind.missed
                                        ? () async {
                                            final hoursLate = DateTime.now()
                                                .difference(day)
                                                .inHours
                                                .abs();
                                            await ref
                                                .read(appPrdAnalyticsBridgeProvider)
                                                .historyRetroLog(
                                                  medicineId: r.medicineId,
                                                  action: 'take',
                                                  hoursLate: hoursLate,
                                                );
                                            await ref
                                                .read(medicineAppDataNotifierProvider.notifier)
                                                .markDoseTaken(r.occurrenceId);
                                            setState(() {});
                                          }
                                        : null,
                                  ),
                              ],
                            ),
                    ),
                    const AdBanner(placement: 'history_day'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
