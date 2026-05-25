import '../../features/medicines/domain/MedicineReminderDataModels.dart';
import '../../features/medicines/domain/MedicineSchedulePayloadModel.dart';

/// Generates [DateTime] fire times for all schedule kinds (PRD §6.6–§6.7).
class MedicineScheduleOccurrenceGenerator {
  static List<DateTime> generateBetween({
    required MedicineStoredRecordModel medicine,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    if (medicine.isOnDemand || medicine.isPaused) return const [];
    switch (medicine.scheduleKind) {
      case MedicineScheduleKind.oneTime:
        return _oneTime(medicine, rangeStart, rangeEnd);
      case MedicineScheduleKind.everyXHours:
        return _everyXHours(medicine, rangeStart, rangeEnd);
      default:
        return _byCalendarDays(medicine, rangeStart, rangeEnd);
    }
  }

  static List<DateTime> _oneTime(
    MedicineStoredRecordModel medicine,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final iso = medicine.schedulePayload.oneTimeAtIso;
    if (iso == null) return const [];
    final at = DateTime.tryParse(iso);
    if (at == null) return const [];
    if (at.isBefore(rangeStart) || at.isAfter(rangeEnd)) return const [];
    return [at];
  }

  static List<DateTime> _everyXHours(
    MedicineStoredRecordModel medicine,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    if (medicine.doseMinutesOfDay.isNotEmpty) {
      return _byCalendarDays(medicine, rangeStart, rangeEnd);
    }
    final hours = medicine.schedulePayload.everyXHours.clamp(1, 24);
    final anchorIso = medicine.schedulePayload.scheduleAnchorDateIso ??
        medicine.createdAtIso ??
        rangeStart.toIso8601String();
    var cursor = DateTime.tryParse(anchorIso) ?? rangeStart;
    if (cursor.isBefore(rangeStart)) {
      final diffHours = rangeStart.difference(cursor).inHours;
      final steps = (diffHours / hours).ceil();
      cursor = cursor.add(Duration(hours: steps * hours));
    }
    final results = <DateTime>[];
    while (!cursor.isAfter(rangeEnd) && results.length < 500) {
      if (!cursor.isBefore(rangeStart)) results.add(cursor);
      cursor = cursor.add(Duration(hours: hours));
    }
    return results;
  }

  static List<DateTime> _byCalendarDays(
    MedicineStoredRecordModel medicine,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final results = <DateTime>[];
    var day = DateTime(rangeStart.year, rangeStart.month, rangeStart.day);
    final endDay = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day);
    while (!day.isAfter(endDay)) {
      if (_isActiveOnDay(medicine, day)) {
        for (final minutes in medicine.doseMinutesOfDay) {
          final fireAt = DateTime(
            day.year,
            day.month,
            day.day,
            minutes ~/ 60,
            minutes % 60,
          );
          if (!fireAt.isBefore(rangeStart) && !fireAt.isAfter(rangeEnd)) {
            results.add(fireAt);
          }
        }
      }
      day = day.add(const Duration(days: 1));
    }
    return results;
  }

  static bool _isActiveOnDay(MedicineStoredRecordModel medicine, DateTime day) {
    if (!_withinDuration(medicine, day)) return false;
    final payload = medicine.schedulePayload;
    switch (medicine.scheduleKind) {
      case MedicineScheduleKind.daily:
      case MedicineScheduleKind.timesPerDay:
        return true;
      case MedicineScheduleKind.specificDaysOfWeek:
        final weekday = day.weekday % 7 + 1;
        return payload.weekdays.contains(weekday);
      case MedicineScheduleKind.weekly:
        final weekday = day.weekday % 7 + 1;
        if (!payload.weekdays.contains(weekday)) return false;
        final anchor = _dayOnly(
          DateTime.tryParse(payload.scheduleAnchorDateIso ?? '') ??
              DateTime.tryParse(medicine.createdAtIso ?? '') ??
              day,
        );
        final weeksBetween = day.difference(anchor).inDays ~/ 7;
        if (weeksBetween < 0) return false;
        final everyXWeeks = payload.everyXWeeks.clamp(1, 52);
        return weeksBetween % everyXWeeks == 0;
      case MedicineScheduleKind.everyXDays:
        final anchor = _dayOnly(
          DateTime.tryParse(payload.scheduleAnchorDateIso ?? '') ??
              DateTime.tryParse(medicine.createdAtIso ?? '') ??
              day,
        );
        final diff = day.difference(anchor).inDays;
        if (diff < 0) return false;
        return diff % payload.everyXDays == 0;
      case MedicineScheduleKind.monthly:
        return _matchesMonthlyDay(day, payload);
      case MedicineScheduleKind.cyclic:
        final anchor = _dayOnly(
          DateTime.tryParse(medicine.createdAtIso ?? '') ?? day,
        );
        final cycleLength = payload.cyclicOnDays + payload.cyclicOffDays;
        if (cycleLength <= 0) return false;
        final dayIndex = day.difference(anchor).inDays;
        if (dayIndex < 0) return false;
        final position = dayIndex % cycleLength;
        return position < payload.cyclicOnDays;
      default:
        return false;
    }
  }

  static bool _withinDuration(MedicineStoredRecordModel medicine, DateTime day) {
    final created = medicine.createdAtIso != null
        ? DateTime.tryParse(medicine.createdAtIso!)
        : null;
    final createdDay =
        created != null ? _dayOnly(created) : null;
    if (createdDay != null && day.isBefore(createdDay)) return false;
    switch (medicine.durationKind) {
      case MedicineDurationKind.ongoing:
        return true;
      case MedicineDurationKind.untilDate:
        final end = medicine.endDateIso != null
            ? DateTime.tryParse(medicine.endDateIso!)
            : null;
        if (end == null) return true;
        return !day.isAfter(_dayOnly(end));
      case MedicineDurationKind.forDays:
        if (createdDay == null || medicine.durationDayCount == null) {
          return true;
        }
        final lastDay =
            createdDay.add(Duration(days: medicine.durationDayCount! - 1));
        return !day.isAfter(lastDay);
    }
  }

  static bool _matchesMonthlyDay(
    DateTime day,
    MedicineSchedulePayloadModel payload,
  ) {
    if (payload.monthlyUseLastDayOfMonth ||
        payload.monthlyDayOfMonth ==
            MedicineSchedulePayloadModel.lastDayOfMonthMarker) {
      final last = DateTime(day.year, day.month + 1, 0).day;
      return day.day == last;
    }
    final target = payload.monthlyDayOfMonth;
    if (target == 29 && day.month == 2) {
      final isLeap = DateTime(day.year, 2, 29).month == 2;
      if (isLeap) return day.day == 29;
      return payload.feb29UseFeb28InNonLeap ? day.day == 28 : false;
    }
    final last = DateTime(day.year, day.month + 1, 0).day;
    if (target > last) return day.day == last;
    return day.day == target;
  }

  static DateTime _dayOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  static int adherencePercentForDay({
    required List<MedicineDoseOccurrenceRecordModel> occurrences,
    required DateTime day,
  }) {
    final dayStart = _dayOnly(day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final dayRows = occurrences.where((o) {
      final scheduled = DateTime.parse(o.scheduledAtIso);
      return !scheduled.isBefore(dayStart) && scheduled.isBefore(dayEnd);
    }).toList();
    if (dayRows.isEmpty) return -1;
    final taken = dayRows
        .where((o) => o.statusKind == MedicineDoseStatusKind.taken)
        .length;
    return ((taken / dayRows.length) * 100).round();
  }
}
