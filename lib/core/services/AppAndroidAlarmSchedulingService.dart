import 'package:flutter/services.dart';

/// Android [AlarmManager.setAlarmClock] bridge (PRD §6.9).
class AppAndroidAlarmSchedulingService {
  static const _channel = MethodChannel('com.nanogear.med_reminder/alarm');

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
    } on PlatformException catch (_) {
      // Emulator or missing permission — notification path still applies.
    }
  }

  Future<void> cancelAllAlarms() async {
    try {
      await _channel.invokeMethod<void>('cancelAllAlarms');
    } on PlatformException catch (_) {}
  }
}
