import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/AppBuildVersionConstants.dart';
import '../../features/medicines/application/MedicineAppDataNotifier.dart';
import 'AppPrdAnalyticsBridge.dart';

/// Logs PRD system events on app update, timezone change, and DST offset change.
class AppPrdAnalyticsSystemLifecycleHandler {
  static const _prefsVersionKey = 'analytics_last_app_version_v1';
  static const _prefsTimezoneKey = 'analytics_last_timezone_name_v1';
  static const _prefsDstOffsetKey = 'analytics_last_dst_offset_min_v1';

  static Future<void> runAfterBootstrapIfNeeded(WidgetRef ref) async {
    final bridge = ref.read(appPrdAnalyticsBridgeProvider);
    final prefs = await SharedPreferences.getInstance();
    await ref.read(medicineAppDataNotifierProvider.future);
    final medCount = ref
        .read(medicineAppDataNotifierProvider.notifier)
        .medicinesForActiveProfile()
        .length;

    final lastVersion = prefs.getString(_prefsVersionKey);
    if (lastVersion != null &&
        lastVersion != AppBuildVersionConstants.currentVersion) {
      await bridge.sysUpdateReschedule(medCount);
      await bridge.medicinesRescheduled(medCount);
    }
    await prefs.setString(
      _prefsVersionKey,
      AppBuildVersionConstants.currentVersion,
    );

    final currentTz = DateTime.now().timeZoneName;
    final lastTz = prefs.getString(_prefsTimezoneKey);
    if (lastTz != null && lastTz != currentTz) {
      await bridge.sysTimezoneChanged(lastTz, currentTz);
      await bridge.sysTimezoneUserChoice('keep_local');
    }
    await prefs.setString(_prefsTimezoneKey, currentTz);

    final currentOffsetMin = DateTime.now().timeZoneOffset.inMinutes;
    final lastOffsetMin = prefs.getInt(_prefsDstOffsetKey);
    if (lastOffsetMin != null && lastOffsetMin != currentOffsetMin) {
      final direction =
          currentOffsetMin > lastOffsetMin ? 'spring_forward' : 'fall_back';
      await bridge.sysDstTransition(
        direction: direction,
        affectedMedsCount: medCount,
      );
    }
    await prefs.setInt(_prefsDstOffsetKey, currentOffsetMin);
  }
}
