/// Sunday at 00:00 for the week that contains [day] (PRD §6.2.1 week start).
DateTime weekStartSundayFor(DateTime day) {
  final normalized = DateTime(day.year, day.month, day.day);
  final daysFromSunday = normalized.weekday % 7;
  return normalized.subtract(Duration(days: daysFromSunday));
}

/// Builds the 7 visible days for the home strip (week starts Sunday per PRD).
List<DateTime> buildWeekStripDaysContaining(DateTime selectedDay) {
  return buildWeekStripDaysForWeekStart(weekStartSundayFor(selectedDay));
}

List<DateTime> buildWeekStripDaysForWeekStart(DateTime weekSunday) {
  final start = DateTime(weekSunday.year, weekSunday.month, weekSunday.day);
  return List.generate(7, (index) => start.add(Duration(days: index)));
}

bool isSameCalendarDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

int compareCalendarDays(DateTime a, DateTime b) {
  final aNorm = DateTime(a.year, a.month, a.day);
  final bNorm = DateTime(b.year, b.month, b.day);
  return aNorm.compareTo(bNorm);
}

const stripDayNameLabels = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

String stripDayNameFor(DateTime day) => stripDayNameLabels[day.weekday % 7];

/// PRD §6.2.1 visual states for an unselected/selected strip cell.
class DateStripCellStyle {
  const DateStripCellStyle({
    required this.isSelected,
    required this.showTodayDot,
    required this.dayNameIsLightOnFill,
    required this.dateNumberIsLightOnFill,
  });

  final bool isSelected;
  final bool showTodayDot;
  final bool dayNameIsLightOnFill;
  final bool dateNumberIsLightOnFill;
}

DateStripCellStyle resolveDateStripCellStyle({
  required DateTime cellDay,
  required DateTime selectedDay,
  required DateTime todayDay,
}) {
  final selected = isSameCalendarDay(cellDay, selectedDay);
  final isToday = isSameCalendarDay(cellDay, todayDay);
  if (selected) {
    return DateStripCellStyle(
      isSelected: true,
      showTodayDot: false,
      dayNameIsLightOnFill: true,
      dateNumberIsLightOnFill: true,
    );
  }
  return DateStripCellStyle(
    isSelected: false,
    showTodayDot: isToday,
    dayNameIsLightOnFill: false,
    dateNumberIsLightOnFill: false,
  );
}

/// Past strip cells use secondary grey; future use primary. Sundays use red date numbers.
bool dateStripDateNumberUsesSundayRed({
  required DateTime cellDay,
  required bool isSelected,
}) {
  return !isSelected && cellDay.weekday == DateTime.sunday;
}

bool dateStripCellIsPastDay({
  required DateTime cellDay,
  required DateTime todayDay,
}) {
  return compareCalendarDays(cellDay, todayDay) < 0;
}
