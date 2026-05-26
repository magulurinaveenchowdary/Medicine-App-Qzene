import 'dart:developer' as developer;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'AppAndroidAlarmSchedulingService.dart';

/// Local dose reminders + AlarmManager (PRD §6.9).
class AppLocalNotificationsSchedulingService {
  AppLocalNotificationsSchedulingService({
    AppAndroidAlarmSchedulingService? androidAlarms,
  }) : _androidAlarms = androidAlarms ?? AppAndroidAlarmSchedulingService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final AppAndroidAlarmSchedulingService _androidAlarms;
  bool _didInitialize = false;

  static int _normalizeAlarmId(int alarmId) =>
      alarmId == 0 ? 1 : alarmId.abs();

  static void Function(String occurrenceId, String actionId)?
      onNotificationAction;

  static void Function(String medicineId, int secondsAfterShown)?
      onNotificationDismissed;

  /// PRD §12.3, Screen 8 — fired once per notification posted.
  /// Params: medicine_id, is_high_priority.
  static void Function(String medicineId, bool isHighPriority)? onNotifShown;

  static final Map<String, DateTime> _postedAtByMedicineId = {};

  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
    'medicine_reminder_default_v1',
    'Medicine reminders',
    description: 'Scheduled dose reminders',
    importance: Importance.max,
  );

  Future<void> initializeIfNeeded() async {
    if (_didInitialize) return;
    tz_data.initializeTimeZones();
    // Flutter local notifications disabled; using Android native alarms only
    _didInitialize = true;
    developer.log('Android alarms initialized (Flutter notifications disabled)',
        name: 'Notifications');
  }

  void _emitDismissedForReplacedNotifications() {
    final now = DateTime.now();
    for (final entry in _postedAtByMedicineId.entries) {
      final seconds = now.difference(entry.value).inSeconds;
      onNotificationDismissed?.call(entry.key, seconds);
    }
    _postedAtByMedicineId.clear();
  }

  Future<void> rescheduleUpcomingDoseReminders(
    List<({
      String occurrenceId,
      int notificationId,
      DateTime scheduledAt,
      String title,
      String body,
      bool isCritical,
      String medicineId,
    })> reminders,
  ) async {
    await initializeIfNeeded();
    _emitDismissedForReplacedNotifications();
    // Flutter notifications disabled; only use Android AlarmManager
    await _androidAlarms.cancelAllAlarms();
    final now = DateTime.now();
    var scheduledCount = 0;
    for (final reminder in reminders) {
      if (reminder.scheduledAt.isBefore(now)) continue;
      if (scheduledCount >= 64) break;

      // Schedule Android AlarmManager clock (native full-screen alarm)
      await _androidAlarms.scheduleAlarmClock(
        alarmId: _normalizeAlarmId(reminder.notificationId),
        triggerAtMillis: reminder.scheduledAt.millisecondsSinceEpoch,
        occurrenceId: reminder.occurrenceId,
        title: reminder.title,
        body: reminder.body,
      );
      _postedAtByMedicineId[reminder.medicineId] = DateTime.now();
      // Fire analytics event for alarm scheduled
      onNotifShown?.call(reminder.medicineId, reminder.isCritical);
      scheduledCount++;
    }
    developer.log(
      'Scheduled $scheduledCount alarms (Flutter notifications disabled)',
      name: 'Notifications',
    );
  }
}
