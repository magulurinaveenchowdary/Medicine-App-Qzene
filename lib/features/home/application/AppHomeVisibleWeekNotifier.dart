import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reminder/core/date/week_date_strip_helper.dart';

/// Sunday-start week currently shown in the home date strip (PRD §6.2.1).
class AppHomeVisibleWeekNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => weekStartSundayFor(DateTime.now());

  void showWeekContaining(DateTime day) {
    state = weekStartSundayFor(day);
  }

  void shiftVisibleWeek(int direction) {
    if (direction == 0) return;
    state = state.add(Duration(days: 7 * direction));
  }
}

final appHomeVisibleWeekNotifierProvider =
    NotifierProvider<AppHomeVisibleWeekNotifier, DateTime>(
  AppHomeVisibleWeekNotifier.new,
);
