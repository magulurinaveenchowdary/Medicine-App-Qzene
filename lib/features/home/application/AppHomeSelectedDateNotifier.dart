import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks which calendar day the home strip shows (PRD §6.2 date context).
class AppHomeSelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime normalizeCalendarDay(DateTime day) =>
      DateTime(day.year, day.month, day.day);

  void selectCalendarDay(DateTime day) {
    state = normalizeCalendarDay(day);
  }

  void jumpToToday() {
    final now = DateTime.now();
    state = DateTime(now.year, now.month, now.day);
  }
}

final appHomeSelectedDateNotifierProvider =
    NotifierProvider<AppHomeSelectedDateNotifier, DateTime>(
  AppHomeSelectedDateNotifier.new,
);
