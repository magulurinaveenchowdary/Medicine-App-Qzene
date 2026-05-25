import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppPrdAnalyticsBridge.dart';
import 'AppPrdAnalyticsSupportProviders.dart';
import '../../features/medicines/application/MedicineAppDataNotifier.dart';
import '../../features/medicines/domain/MedicineReminderDataModels.dart';

const _bootReschedulePrefsKey = 'boot_reschedule_pending_v1';

/// PRD §12 — `sys_boot_reschedule` after BOOT_COMPLETED relaunch.
class AppPrdAnalyticsBootRescheduleHandler {
  AppPrdAnalyticsBootRescheduleHandler._();

  static Future<bool> consumeBootReschedulePending() async {
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getBool(_bootReschedulePrefsKey) ?? false;
    if (pending) {
      await prefs.setBool(_bootReschedulePrefsKey, false);
    }
    return pending;
  }

  static Future<void> runAfterBootstrapIfNeeded(WidgetRef ref) async {
    if (!await consumeBootReschedulePending()) return;
    ref.read(bootReschedulePendingProvider.notifier).state = true;
    await ref.read(medicineAppDataNotifierProvider.future);
    final stopwatch = Stopwatch()..start();
    await ref.read(medicineAppDataNotifierProvider.notifier).refreshDoseNotifications();
    stopwatch.stop();
    final snapshot = ref.read(medicineAppDataNotifierProvider).valueOrNull;
    final count = snapshot?.doseOccurrences
            .where((o) => o.statusKind == MedicineDoseStatusKind.upcoming)
            .length ??
        0;
    await ref.read(appPrdAnalyticsBridgeProvider).sysBootReschedule(
          count,
          stopwatch.elapsedMilliseconds,
        );
    ref.read(bootReschedulePendingProvider.notifier).state = false;
  }
}
