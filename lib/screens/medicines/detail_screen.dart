import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/analytics/AppAnalyticsMappingHelpers.dart';
import 'package:med_reminder/core/constants/AppAnalyticsEventNamesConstants.dart';
import 'package:med_reminder/core/constants/AppAnalyticsParameterNamesConstants.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/services/AppFirebaseAnalyticsLoggingService.dart';
import 'package:med_reminder/core/constants/AppShadowDesignTokens.dart';
import 'package:med_reminder/core/constants/AppSpacingLayoutTokens.dart';
import 'package:med_reminder/core/scheduling/MedicineScheduleFireCalculator.dart';
import 'package:med_reminder/core/widgets/MedicinesScreenWidgets/BackNavigationHeaderWidget.dart';
import 'package:med_reminder/core/widgets/MedicinesScreenWidgets/DetailRowsCardWidget.dart';
import 'package:med_reminder/core/widgets/common/AdBannerWidget.dart';
import 'package:med_reminder/core/widgets/common/MedicinePillIconWidget.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

class MedicineDetailScreen extends ConsumerStatefulWidget {
  const MedicineDetailScreen({super.key, required this.medicineRowId});
  final String medicineRowId;
  @override
  ConsumerState<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends ConsumerState<MedicineDetailScreen> {
  var _detailViewLogged = false;

  void _logDetailViewIfNeeded(MedicineStoredRecordModel medicine) {
    if (_detailViewLogged) return;
    _detailViewLogged = true;
    ref.read(appFirebaseAnalyticsLoggingServiceProvider).logPrdEvent(
      AppAnalyticsEventNamesConstants.meddetailView,
      {
        AppAnalyticsParameterNamesConstants.medicineId: medicine.medicineId,
        AppAnalyticsParameterNamesConstants.category:
            AppAnalyticsMappingHelpers.categorySlug(medicine.categoryFormLabel),
        AppAnalyticsParameterNamesConstants.scheduleType:
            AppAnalyticsMappingHelpers.scheduleTypeValue(medicine.scheduleKind),
        AppAnalyticsParameterNamesConstants.hasStockTracking:
            medicine.stockRemaining != null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final medicine = ref.watch(medicineAppDataNotifierProvider).valueOrNull == null
        ? null
        : ref.read(medicineAppDataNotifierProvider.notifier).medicineById(widget.medicineRowId);

    if (medicine == null) {
      return CupertinoPageScaffold(
        child: SafeArea(
          child: Center(child: Text(l10n.medicineDetailsTitle)),
        ),
      );
    }

    _logDetailViewIfNeeded(medicine);

    if (medicine.isOnDemand) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(appPrdAnalyticsBridgeProvider).meddetailMaxPerDayWarn(
              medicineId: medicine.medicineId,
              countToday: 0,
              maxSet: 4,
            );
      });
    }

    final doseValue = MedicineScheduleFireCalculator.buildDoseDescription(
      amount: medicine.doseAmount,
      unit: medicine.doseUnit,
    );
    final scheduleValue = MedicineScheduleFireCalculator.buildScheduleSummary(medicine);
    final durationValue = switch (medicine.durationKind) {
      MedicineDurationKind.ongoing => 'Ongoing',
      MedicineDurationKind.untilDate => medicine.endDateIso ?? 'Until date',
      MedicineDurationKind.forDays => 'For ${medicine.durationDayCount ?? 0} days',
    };
    final stockValue = medicine.stockRemaining != null
        ? '${medicine.stockRemaining!.toInt()} left'
        : '—';

    return CupertinoPageScaffold(
      backgroundColor: AppColorsDesignTokens.backgroundSecondary,
      child: SafeArea(
        child: Column(
          children: [
            BackNavigationHeader(
              title: l10n.medicineDetailsTitle,
              trailingLabel: l10n.edit,
              onTrailingTap: () {
                ref.read(appPrdAnalyticsBridgeProvider).meddetailEditTapped(widget.medicineRowId);
                context.push('/main/medicines/detail/${widget.medicineRowId}/edit');
              },
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacingLayoutTokens.phoneContentPadding),
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColorsDesignTokens.backgroundPrimary,
                      borderRadius: BorderRadius.circular(AppSpacingLayoutTokens.cardRadius),
                      boxShadow: AppShadowDesignTokens.cardShadow,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColorsDesignTokens.colorPrimaryTint,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const MedicinePillIconWidget(size: 28),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          medicine.displayName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColorsDesignTokens.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          medicine.ingredientLine,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColorsDesignTokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  DetailRowsCard(
                    rows: [
                      DetailRowData(label: 'Dose', value: doseValue),
                      DetailRowData(label: 'Schedule', value: scheduleValue),
                      DetailRowData(label: 'Duration', value: durationValue),
                      DetailRowData(label: 'Notes', value: medicine.notes ?? '—'),
                      DetailRowData(label: 'Stock', value: stockValue),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CupertinoButton.filled(
                    onPressed: () {
                      ref.read(appPrdAnalyticsBridgeProvider).meddetailEditTapped(widget.medicineRowId);
                      context.push('/main/medicines/detail/${widget.medicineRowId}/edit');
                    },
                    child: const Text('Edit medicine'),
                  ),
                  CupertinoButton(
                    onPressed: () async {
                      final paused = !medicine.isPaused;
                      await ref.read(appPrdAnalyticsBridgeProvider).meddetailPauseToggled(
                            widget.medicineRowId,
                            paused,
                          );
                      await ref
                          .read(medicineAppDataNotifierProvider.notifier)
                          .setMedicinePaused(widget.medicineRowId, paused);
                    },
                    child: Text(medicine.isPaused ? 'Resume medicine' : 'Pause medicine'),
                  ),
                ],
              ),
            ),
            const AdBanner(placement: 'med_detail'),
          ],
        ),
      ),
    );
  }
}
