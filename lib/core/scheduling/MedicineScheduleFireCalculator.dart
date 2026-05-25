import 'package:intl/intl.dart';

import '../constants/MedicineScheduleDefaultTimesConstants.dart';
import '../../features/medicines/domain/MedicineReminderDataModels.dart';
import 'MedicineScheduleOccurrenceGenerator.dart';

/// Computes upcoming dose fire times from stored medicine + schedule (PRD §6.7).
class MedicineScheduleFireCalculator {
  static List<DateTime> nextFireDateTimes({
    required MedicineStoredRecordModel medicine,
    required DateTime from,
    int count = 5,
    int horizonDays = 120,
  }) {
    if (medicine.isOnDemand) return const [];
    final end = from.add(Duration(days: horizonDays));
    final all = MedicineScheduleOccurrenceGenerator.generateBetween(
      medicine: medicine,
      rangeStart: from,
      rangeEnd: end,
    );
    all.sort();
    return all.take(count).toList();
  }

  static List<DateTime> occurrencesForCalendarDay({
    required MedicineStoredRecordModel medicine,
    required DateTime calendarDay,
  }) {
    final day = DateTime(calendarDay.year, calendarDay.month, calendarDay.day);
    final dayEnd = day.add(const Duration(days: 1)).subtract(
          const Duration(milliseconds: 1),
        );
    return MedicineScheduleOccurrenceGenerator.generateBetween(
      medicine: medicine,
      rangeStart: day,
      rangeEnd: dayEnd,
    );
  }

  static List<int> defaultMinutesForTimesPerDay(int timesPerDay) {
    switch (timesPerDay) {
      case 1:
        return const [8 * 60];
      case 2:
        return const [8 * 60, 20 * 60];
      case 3:
        return const [8 * 60, 14 * 60, 20 * 60];
      case 4:
        return const [8 * 60, 12 * 60, 16 * 60, 20 * 60];
      case 5:
        return const [8 * 60, 11 * 60, 14 * 60, 17 * 60, 20 * 60];
      case 6:
        return const [8 * 60, 11 * 60, 14 * 60, 17 * 60, 20 * 60, 23 * 60];
      default:
        return const [MedicineScheduleDefaultTimesConstants.defaultMorningMinutes];
    }
  }

  /// Wall-clock dose times for one 24h cycle (PRD §6.7 every-X-hours examples).
  static List<int> everyXHoursSlotMinutes({
    required int intervalHours,
    required int dayStartMinutes,
  }) {
    final intervalMinutes = intervalHours.clamp(
      MedicineScheduleDefaultTimesConstants.everyXHoursMin,
      MedicineScheduleDefaultTimesConstants.everyXHoursMax,
    ) *
        60;
    final slots = <int>[];
    var cursor = dayStartMinutes % (24 * 60);
    final seen = <int>{};
    while (seen.add(cursor)) {
      slots.add(cursor);
      cursor = (cursor + intervalMinutes) % (24 * 60);
    }
    slots.sort();
    return slots;
  }

  static DateTime anchorOnDateWithMinutes({
    required DateTime date,
    required int minutesOfDay,
  }) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      minutesOfDay ~/ 60,
      minutesOfDay % 60,
    );
  }

  static DateTime defaultOneTimeDateTime(DateTime from) =>
      from.add(const Duration(minutes: 5));

  static String formatMinutesOfDay(int minutes, {bool use24Hour = false}) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    if (use24Hour) {
      return DateFormat('HH:mm').format(
        DateTime(2000, 1, 1, hour, minute),
      );
    }
    return DateFormat('h:mm a').format(
      DateTime(2000, 1, 1, hour, minute),
    );
  }

  static String buildDoseDescription({
    required double amount,
    required String unit,
    String? notes,
  }) {
    final amountLabel = amount == amount.roundToDouble()
        ? amount.toInt().toString()
        : amount.toString();
    final dosePart = '$amountLabel $unit';
    if (notes == null || notes.trim().isEmpty) return dosePart;
    return '$dosePart · ${notes.trim()}';
  }

  static String buildScheduleSummary(MedicineStoredRecordModel medicine) {
    if (medicine.isOnDemand) return 'As needed';
    final times = medicine.doseMinutesOfDay
        .map((m) => formatMinutesOfDay(m))
        .join(', ');
    switch (medicine.scheduleKind) {
      case MedicineScheduleKind.daily:
        return 'Daily · $times';
      case MedicineScheduleKind.timesPerDay:
        return '${medicine.doseMinutesOfDay.length}x daily · $times';
      case MedicineScheduleKind.everyXHours:
        return 'Every ${medicine.schedulePayload.everyXHours}h';
      case MedicineScheduleKind.specificDaysOfWeek:
        return 'Specific days · $times';
      case MedicineScheduleKind.everyXDays:
        return 'Every ${medicine.schedulePayload.everyXDays} days · $times';
      case MedicineScheduleKind.weekly:
        return 'Weekly · $times';
      case MedicineScheduleKind.monthly:
        if (medicine.schedulePayload.monthlyUseLastDayOfMonth) {
          return 'Monthly (last day) · $times';
        }
        return 'Monthly (day ${medicine.schedulePayload.monthlyDayOfMonth}) · $times';
      case MedicineScheduleKind.cyclic:
        return 'Cyclic ${medicine.schedulePayload.cyclicOnDays}/${medicine.schedulePayload.cyclicOffDays} · $times';
      case MedicineScheduleKind.oneTime:
        final at = DateTime.tryParse(medicine.schedulePayload.oneTimeAtIso ?? '');
        if (at != null) {
          return 'One-time · ${DateFormat.yMMMd().format(at)} · ${formatMinutesOfDay(at.hour * 60 + at.minute)}';
        }
        return 'One-time';
      case MedicineScheduleKind.onDemand:
        return 'As needed';
    }
  }
}
