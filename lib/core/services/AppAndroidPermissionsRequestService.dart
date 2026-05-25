import 'dart:io';

import 'package:flutter/services.dart';
import 'package:med_reminder/core/models/ExactAlarmSettingsLaunchResult.dart';
import 'package:permission_handler/permission_handler.dart';

/// Android runtime permissions for onboarding (PRD §6.1).
class AppAndroidPermissionsRequestService {
  static const _alarmChannel = MethodChannel('com.nanogear.med_reminder/alarm');

  Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Whether [AlarmManager.canScheduleExactAlarms] is true (API 31+).
  Future<bool> isExactAlarmPermissionGranted() async {
    if (!Platform.isAndroid) return true;
    try {
      final granted = await _alarmChannel.invokeMethod<bool>('canScheduleExactAlarms');
      return granted ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Opens **Alarms & reminders** only when the user still needs to grant access.
  ///
  /// Does not grant permission in code. If already granted, returns without opening
  /// settings (avoids the grey non-interactive ON toggle on the request screen).
  /// Opens **Alarms & reminders** for the user to grant access.
  ///
  /// When [forceOpen] is true (onboarding Allow tap), always launches the exact-alarm
  /// settings screen on API 31+ even if [canScheduleExactAlarms] already reports true.
  /// That check can false-positive after unrelated settings (e.g. battery) were opened.
  Future<ExactAlarmSettingsLaunchResult> openExactAlarmSettingsForUserGrant({
    bool forceOpen = false,
  }) async {
    if (!Platform.isAndroid) {
      return const ExactAlarmSettingsLaunchResult(
        openedSettings: false,
        alreadyGranted: true,
        requiresUserGrant: false,
      );
    }
    try {
      final map = await _alarmChannel.invokeMethod<Map<dynamic, dynamic>>(
        'requestScheduleExactAlarmPermission',
        {'forceOpen': forceOpen},
      );
      return ExactAlarmSettingsLaunchResult.fromPlatformMap(map);
    } on PlatformException {
      return const ExactAlarmSettingsLaunchResult(
        openedSettings: false,
        alreadyGranted: false,
        requiresUserGrant: true,
      );
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
