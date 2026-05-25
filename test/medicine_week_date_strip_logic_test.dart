import 'package:flutter_test/flutter_test.dart';

import 'package:med_reminder/core/date/week_date_strip_helper.dart';

void main() {
  test('buildWeekStripDaysContaining starts week on Sunday', () {
    final selected = DateTime(2026, 3, 18); // Wednesday
    final week = buildWeekStripDaysContaining(selected);
    expect(week.length, 7);
    expect(week.first.weekday, DateTime.sunday);
    expect(isSameCalendarDay(week[3], selected), isTrue);
  });

  test('weekStartSundayFor aligns to Sunday', () {
    final wednesday = DateTime(2026, 3, 18);
    final sunday = weekStartSundayFor(wednesday);
    expect(sunday.weekday, DateTime.sunday);
    expect(sunday.day, 15);
  });

  test('resolveDateStripCellStyle marks selected and today dot', () {
    final today = DateTime(2026, 3, 18);
    final selected = DateTime(2026, 3, 17);
    final todayStyle = resolveDateStripCellStyle(
      cellDay: today,
      selectedDay: selected,
      todayDay: today,
    );
    expect(todayStyle.showTodayDot, isTrue);
    expect(todayStyle.isSelected, isFalse);

    final selectedStyle = resolveDateStripCellStyle(
      cellDay: selected,
      selectedDay: selected,
      todayDay: today,
    );
    expect(selectedStyle.isSelected, isTrue);
    expect(selectedStyle.dayNameIsLightOnFill, isTrue);
  });

  test('dateStripCellIsPastDay and sunday red flag', () {
    final today = DateTime(2026, 3, 18);
    final pastMonday = DateTime(2026, 3, 17);
    final pastSunday = DateTime(2026, 3, 15);
    expect(
      dateStripCellIsPastDay(cellDay: pastMonday, todayDay: today),
      isTrue,
    );
    expect(
      dateStripDateNumberUsesSundayRed(cellDay: pastSunday, isSelected: false),
      isTrue,
    );
    expect(
      dateStripDateNumberUsesSundayRed(cellDay: pastSunday, isSelected: true),
      isFalse,
    );
  });

  test('stripDayNameFor matches weekday', () {
    expect(stripDayNameFor(DateTime(2026, 3, 15)), 'SUN');
    expect(stripDayNameFor(DateTime(2026, 3, 18)), 'WED');
  });
}
