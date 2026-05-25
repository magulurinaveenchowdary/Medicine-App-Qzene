import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/widgets/common/AdBannerWidget.dart';
import 'package:med_reminder/core/widgets/common/MedicineTileWidget.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';

class AfterCallMultiScreen extends ConsumerStatefulWidget {
  const AfterCallMultiScreen({super.key});
  @override
  ConsumerState<AfterCallMultiScreen> createState() => _AfterCallMultiScreenState();
}

class _AfterCallMultiScreenState extends ConsumerState<AfterCallMultiScreen> {
  late final DateTime _shownAt;
  int? _openMenuIndex;

  @override
  void initState() {
    super.initState();
    _shownAt = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appPrdAnalyticsBridgeProvider).adAftercallShown();
    });
  }

  Future<void> _perMedAction({
    required MedicineDoseDisplayRowModel row,
    required String action,
  }) async {
    final notifier = ref.read(medicineAppDataNotifierProvider.notifier);
    if (action == 'take') {
      await notifier.markDoseTaken(row.occurrenceId);
    } else if (action == 'snooze') {
      await notifier.markDoseSnoozed(row.occurrenceId, 10);
    } else if (action == 'skip') {
      await notifier.markDoseSkipped(row.occurrenceId);
    }
    setState(() => _openMenuIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(medicineAppDataNotifierProvider.notifier);
    final rows = ref.watch(medicineAppDataNotifierProvider).maybeWhen(
          data: (_) => notifier.upcomingDoseRowsWithinMinutes(240),
          orElse: () => <MedicineDoseDisplayRowModel>[],
        );

    final title = '${rows.length} medicines due in the next 4 hours';

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
            // Header Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Tap any to take action',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // ListView with sticky bottom ad banner
            Expanded(
              child: Stack(
                children: [
                  // List
                  ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 76), // 76px bottom padding to clear the 50px ad + spacing
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final r = rows[index];
                      return MedicineTile(
                        rowModel: r,
                        showKebabMenu: true,
                        showPopoverMenu: _openMenuIndex == index,
                        onKebabTap: () {
                          setState(() {
                            if (_openMenuIndex == index) {
                              _openMenuIndex = null;
                            } else {
                              _openMenuIndex = index;
                            }
                          });
                        },
                        onPerMedTake: () => _perMedAction(row: r, action: 'take'),
                        onPerMedSnooze: () => _perMedAction(row: r, action: 'snooze'),
                        onPerMedSkip: () => _perMedAction(row: r, action: 'skip'),
                      );
                    },
                  ),
                  // Sticky Bottom Ad Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: AppColors.backgroundGrey,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: AdBanner(
                        placement: 'after_call_multi',
                        onAftercallTap: () => ref.read(appPrdAnalyticsBridgeProvider).adAftercallBannerClicked(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
