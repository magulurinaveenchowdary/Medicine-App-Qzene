/// Result of launching Android **Alarms & reminders** settings (API 31+).
class ExactAlarmSettingsLaunchResult {
  const ExactAlarmSettingsLaunchResult({
    required this.openedSettings,
    required this.alreadyGranted,
    required this.requiresUserGrant,
  });

  /// System settings screen was shown so the user can toggle permission.
  final bool openedSettings;

  /// [AlarmManager.canScheduleExactAlarms] is already true.
  final bool alreadyGranted;

  /// False on API &lt; 31 where no special access exists.
  final bool requiresUserGrant;

  factory ExactAlarmSettingsLaunchResult.fromPlatformMap(
    Map<dynamic, dynamic>? map,
  ) {
    if (map == null) {
      return const ExactAlarmSettingsLaunchResult(
        openedSettings: false,
        alreadyGranted: false,
        requiresUserGrant: false,
      );
    }
    return ExactAlarmSettingsLaunchResult(
      openedSettings: map['openedSettings'] == true,
      alreadyGranted: map['alreadyGranted'] == true,
      requiresUserGrant: map['requiresUserGrant'] == true,
    );
  }
}
