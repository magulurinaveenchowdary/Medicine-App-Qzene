import '../../features/medicines/domain/MedicineReminderDataModels.dart';

/// Maps domain values to PRD §12 analytics strings (no PII).
class AppAnalyticsMappingHelpers {
  AppAnalyticsMappingHelpers._();

  static String hashProfileIdForAnalytics(String profileId) {
    return profileId.hashCode.toUnsigned(32).toRadixString(16);
  }

  static String scheduleTypeValue(MedicineScheduleKind kind) {
    switch (kind) {
      case MedicineScheduleKind.oneTime:
        return 'one_time';
      case MedicineScheduleKind.daily:
        return 'daily';
      case MedicineScheduleKind.timesPerDay:
        return 'x_per_day';
      case MedicineScheduleKind.everyXHours:
        return 'every_x_hours';
      case MedicineScheduleKind.specificDaysOfWeek:
        return 'specific_days';
      case MedicineScheduleKind.everyXDays:
        return 'every_x_days';
      case MedicineScheduleKind.weekly:
        return 'weekly';
      case MedicineScheduleKind.monthly:
        return 'monthly';
      case MedicineScheduleKind.cyclic:
        return 'cyclic';
      case MedicineScheduleKind.onDemand:
        return 'on_demand';
    }
  }

  static String durationTypeValue(MedicineDurationKind kind) {
    switch (kind) {
      case MedicineDurationKind.ongoing:
        return 'ongoing';
      case MedicineDurationKind.untilDate:
        return 'until_date';
      case MedicineDurationKind.forDays:
        return 'for_x_days';
    }
  }

  static String doseStatusValue(MedicineDoseStatusKind status) {
    switch (status) {
      case MedicineDoseStatusKind.upcoming:
        return 'upcoming';
      case MedicineDoseStatusKind.taken:
        return 'taken';
      case MedicineDoseStatusKind.skipped:
        return 'skipped';
      case MedicineDoseStatusKind.missed:
        return 'missed';
      case MedicineDoseStatusKind.snoozed:
        return 'snoozed';
    }
  }

  static String categorySlug(String? categoryFormLabel) {
    if (categoryFormLabel == null || categoryFormLabel.isEmpty) {
      return 'others';
    }
    return categoryFormLabel
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
