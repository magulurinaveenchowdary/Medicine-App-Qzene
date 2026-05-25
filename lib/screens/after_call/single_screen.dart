import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/widgets/common/AdBannerWidget.dart';
import 'package:med_reminder/core/widgets/common/MedicinePillIconWidget.dart';
import 'package:med_reminder/core/scheduling/MedicineScheduleFireCalculator.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

class AfterCallSingleScreen extends ConsumerStatefulWidget {
  const AfterCallSingleScreen({super.key});
  @override
  ConsumerState<AfterCallSingleScreen> createState() => _AfterCallSingleScreenState();
}

class _AfterCallSingleScreenState extends ConsumerState<AfterCallSingleScreen> {
  late final DateTime _shownAt;

  @override
  void initState() {
    super.initState();
    _shownAt = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appPrdAnalyticsBridgeProvider).adAftercallShown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = ref.watch(medicineAppDataNotifierProvider).valueOrNull;

    String title = 'No upcoming medicines';
    String subtitle = 'Add a medicine to receive reminders';

    if (data != null) {
      final activeId = ref.watch(activeUserProfileIdProvider);
      final now = DateTime.now();

      final upcomingOccurrences = data.doseOccurrences
          .where((o) => o.profileId == activeId && o.statusKind == MedicineDoseStatusKind.upcoming)
          .toList();

      upcomingOccurrences.sort((a, b) => a.scheduledAtIso.compareTo(b.scheduledAtIso));

      if (upcomingOccurrences.isNotEmpty) {
        final nextOccurrence = upcomingOccurrences.first;
        final medicine = ref.read(medicineAppDataNotifierProvider.notifier).medicineById(nextOccurrence.medicineId);
        if (medicine != null) {
          final scheduledTime = DateTime.parse(nextOccurrence.scheduledAtIso);
          final diff = scheduledTime.difference(now);
          final String timeRemainingLabel;
          if (diff.inMinutes <= 0) {
            timeRemainingLabel = 'due now';
          } else if (diff.inHours == 0) {
            timeRemainingLabel = 'in ${diff.inMinutes} minute${diff.inMinutes == 1 ? "" : "s"}';
          } else {
            timeRemainingLabel = 'in ${diff.inHours} hour${diff.inHours == 1 ? "" : "s"}';
          }
          title = 'Next medicine $timeRemainingLabel';

          final doseLine = MedicineScheduleFireCalculator.buildDoseDescription(
            amount: medicine.doseAmount,
            unit: medicine.doseUnit,
          );
          final timeStr = MedicineScheduleFireCalculator.formatMinutesOfDay(
            scheduledTime.hour * 60 + scheduledTime.minute,
          );
          subtitle = '${medicine.displayName} · $doseLine at $timeStr';
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: const BoxDecoration(
                color: AppColors.cardWhite,
                border: Border(
                  bottom: BorderSide(color: AppColors.divider),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.xmark, size: 22, color: AppColors.textSecondary),
                    onPressed: () {
                      final dwell = DateTime.now().difference(_shownAt).inSeconds;
                      ref.read(appPrdAnalyticsBridgeProvider).adAftercallDismissed(dwell);
                      context.pop();
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Call ended',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer to balance the X button
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Medicine Icon
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlueTint,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const MedicinePillIconWidget(size: 38),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Add Medicine Section Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: AppColors.cardWhite,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              ref.read(appPrdAnalyticsBridgeProvider).adAftercallAddMedClicked();
                              ref.read(appPrdAnalyticsBridgeProvider).addMedStarted('aftercall');
                              ref.read(addMedicineDraftNotifierProvider.notifier).resetDraft();
                              context.push('/add-medicine/name');
                            },
                            child: const Text(
                              '+ Add a new medicine',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Just got a prescription? Add it now.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Ad banner (300x250 medium rectangle)
                    AdBanner(
                      placement: 'after_call_single',
                      onAftercallTap: () => ref.read(appPrdAnalyticsBridgeProvider).adAftercallBannerClicked(),
                    ),
                    const Spacer(),
                    // Dismiss Button
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      onPressed: () {
                        final dwell = DateTime.now().difference(_shownAt).inSeconds;
                        ref.read(appPrdAnalyticsBridgeProvider).adAftercallDismissed(dwell);
                        context.pop();
                      },
                      child: Text(
                        l10n.dismiss,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
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
