import 'package:flutter/cupertino.dart';
import 'package:med_reminder/core/widgets/common/MonthCalendarGridWidget.dart';

/// History tab month calendar (wireframe `.cal-grid` in a card).
class HistoryMonthCalendarWidget extends StatelessWidget {
  const HistoryMonthCalendarWidget({
    super.key,
    required this.monthLabel,
    required this.onDayTap,
    required this.visibleMonth,
    required this.selectedDay,
    required this.todayDay,
    this.adherencePercentByDay = const {},
  });

  final String monthLabel;
  final ValueChanged<int> onDayTap;
  final DateTime visibleMonth;
  final int selectedDay;
  final int todayDay;
  final Map<int, int> adherencePercentByDay;

  @override
  Widget build(BuildContext context) {
    return MonthCalendarGridWidget(
      monthLabel: monthLabel,
      visibleMonth: visibleMonth,
      onDayTap: onDayTap,
      selectedDay: selectedDay,
      todayDay: todayDay,
      adherencePercentByDay: adherencePercentByDay,
    );
  }
}
