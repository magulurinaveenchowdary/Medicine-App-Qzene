import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Android [AlarmManager.setAlarmClock] bridge (PRD §6.9).
class AppAndroidAlarmSchedulingService {
  static const _channel = MethodChannel('com.nanogear.med_reminder/alarm');
  static const _scheduledAlarmIdsKey = 'scheduled_alarm_ids_v1';

  Future<Set<int>> _loadScheduledAlarmIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_scheduledAlarmIdsKey);
    if (ids == null) return {};
    return ids.map(int.tryParse).whereType<int>().toSet();
  }

  Future<void> _saveScheduledAlarmIds(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _scheduledAlarmIdsKey,
      ids.map((id) => id.toString()).toList(),
    );
  }

  Future<void> scheduleAlarmClock({
    required int alarmId,
    required int triggerAtMillis,
    required String occurrenceId,
    required String title,
    required String body,
  }) async {
    try {
      await _channel.invokeMethod<void>('scheduleAlarmClock', {
        'alarmId': alarmId,
        'triggerAtMillis': triggerAtMillis,
        'occurrenceId': occurrenceId,
        'title': title,
        'body': body,
      });
      final ids = await _loadScheduledAlarmIds();
      ids.add(alarmId);
      await _saveScheduledAlarmIds(ids);
    } on PlatformException catch (_) {
      // Emulator or missing permission — notification path still applies.
    }
  }

  Future<void> cancelAllAlarms() async {
    try {
      final scheduledIds = await _loadScheduledAlarmIds();
      if (scheduledIds.isNotEmpty) {
        await _channel.invokeMethod<void>('cancelAlarms', {
          'alarmIds': scheduledIds.toList(),
        });
        await _saveScheduledAlarmIds(<int>{});
        return;
      }
      await _channel.invokeMethod<void>('cancelAllAlarms');
    } on PlatformException catch (_) {}
  }
}
