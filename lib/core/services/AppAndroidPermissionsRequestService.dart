import 'dart:io';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Android runtime permissions for onboarding (PRD §6.1).
class AppAndroidPermissionsRequestService {
  static const _alarmChannel = MethodChannel('com.nanogear.med_reminder/alarm');

  Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Whether SCHEDULE_EXACT_ALARM is granted (Android 12+ / API 31+).
  /// Returns true on older Android where the permission is implicit.
  Future<bool> isExactAlarmPermissionGranted() async {
    if (!Platform.isAndroid) return true;
    return (await Permission.scheduleExactAlarm.status).isGranted;
  }

  /// Requests SCHEDULE_EXACT_ALARM. On Android 12+ this opens the system
  /// Alarms & reminders settings screen and awaits the user's action before
  /// returning the updated status. Returns true when granted.
  Future<bool> requestScheduleExactAlarm() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.scheduleExactAlarm.request();
    return status.isGranted;
  }

  /// Opens the system settings screen for SCHEDULE_EXACT_ALARM when needed.
  /// Returns true when the settings screen was opened, false otherwise.
  Future<bool> openScheduleExactAlarmSettings() async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _alarmChannel.invokeMapMethod<String, dynamic>(
        'requestScheduleExactAlarmPermission',
      );
      if (result?['alreadyGranted'] == true) return false;
      return result?['openedSettings'] == true;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> isBatteryOptimizationExemptionGranted() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.ignoreBatteryOptimizations.status;
    return status.isGranted;
  }

  Future<bool> requestBatteryOptimizationExemption() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.ignoreBatteryOptimizations.request();
    return status.isGranted;
  }

  Future<bool> isOverlayPermissionGranted() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.systemAlertWindow.status;
    return status.isGranted;
  }

  Future<bool> requestOverlayPermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.systemAlertWindow.request();
    return status.isGranted;
  }

  /// Whether USE_FULL_SCREEN_INTENT is granted (Android 14+ / API 34+).
  /// Returns true on older Android where the permission is auto-granted.
  Future<bool> isFullScreenIntentGranted() async {
    if (!Platform.isAndroid) return true;
    try {
      return await _alarmChannel.invokeMethod<bool>('canUseFullScreenIntent') ?? true;
    } on PlatformException {
      return true;
    }
  }

  /// Opens the system USE_FULL_SCREEN_INTENT settings page for this app (Android 14+).
  Future<void> openFullScreenIntentSettings() async {
    if (!Platform.isAndroid) return;
    try {
      await _alarmChannel.invokeMethod<void>('openFullScreenIntentSettings');
    } on PlatformException {}
  }

  /// Opens the system battery-optimization screen for this app (not App info).
  Future<bool> openBatteryOptimizationSettings() async {
    if (!Platform.isAndroid) return false;
    try {
      final opened = await _alarmChannel.invokeMethod<bool>(
        'openBatteryOptimizationSettings',
      );
      return opened ?? false;
    } on PlatformException {
      return false;
    }
  }
}
