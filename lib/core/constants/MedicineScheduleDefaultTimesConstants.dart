/// PRD §6.7 pre-filled default times and schedule option ranges.
class MedicineScheduleDefaultTimesConstants {
  MedicineScheduleDefaultTimesConstants._();

  static const int defaultMorningMinutes = 8 * 60;
  static const int defaultMonthlyMinutes = 9 * 60;
  static const int defaultEveryXHoursInterval = 6;

  static const int timesPerDayMin = 2;
  static const int timesPerDayMax = 6;
  static const int defaultTimesPerDay = 3;

  static const int everyXHoursMin = 1;
  static const int everyXHoursMax = 12;

  static const int everyXDaysMin = 2;
  static const int everyXDaysMax = 30;
  static const int defaultEveryXDays = 2;

  static const int everyXWeeksMin = 1;
  static const int everyXWeeksMax = 8;
  static const int defaultEveryXWeeks = 1;

  static const int cyclicOnDaysDefault = 21;
  static const int cyclicOffDaysDefault = 7;

  static const List<int> everyXHoursIntervalOptions = [
    1,
    2,
    3,
    4,
    6,
    8,
    12,
  ];

  static const List<String> weekdayShortLabels = [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  /// PRD weekday encoding: 1 = Sunday … 7 = Saturday.
  static int weekdayCodeFromDateTime(DateTime date) => date.weekday % 7 + 1;
}
