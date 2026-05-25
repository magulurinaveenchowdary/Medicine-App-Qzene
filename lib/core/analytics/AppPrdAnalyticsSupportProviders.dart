import 'package:flutter_riverpod/flutter_riverpod.dart';

/// When the add-medicine funnel started (for `time_in_flow_sec` on save).
final addMedicineFunnelStartedAtProvider = StateProvider<DateTime?>(
  (ref) => null,
);

/// Tracks per-alarm-screen actions for consolidated `alarm_mixed_resolution`.
class AlarmSessionActionCountsModel {
  const AlarmSessionActionCountsModel({
    this.takeCount = 0,
    this.snoozeCount = 0,
    this.skipCount = 0,
  });

  final int takeCount;
  final int snoozeCount;
  final int skipCount;

  bool get hasMixedActions {
    final kinds = [
      if (takeCount > 0) 'take',
      if (snoozeCount > 0) 'snooze',
      if (skipCount > 0) 'skip',
    ];
    return kinds.length > 1;
  }

  AlarmSessionActionCountsModel recordTake() => AlarmSessionActionCountsModel(
        takeCount: takeCount + 1,
        snoozeCount: snoozeCount,
        skipCount: skipCount,
      );

  AlarmSessionActionCountsModel recordSnooze() => AlarmSessionActionCountsModel(
        takeCount: takeCount,
        snoozeCount: snoozeCount + 1,
        skipCount: skipCount,
      );

  AlarmSessionActionCountsModel recordSkip() => AlarmSessionActionCountsModel(
        takeCount: takeCount,
        snoozeCount: snoozeCount,
        skipCount: skipCount + 1,
      );
}

final alarmSessionActionCountsProvider =
    StateProvider<AlarmSessionActionCountsModel>(
  (ref) => const AlarmSessionActionCountsModel(),
);

/// Home permission banner shown once per app session.
final homePermissionWarningShownSessionProvider = StateProvider<bool>(
  (ref) => false,
);

/// Pending boot reschedule analytics (set from Android MainActivity).
final bootReschedulePendingProvider = StateProvider<bool>((ref) => false);
