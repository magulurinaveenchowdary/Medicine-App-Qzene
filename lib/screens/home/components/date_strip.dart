import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/core/constants/AppSpacingLayoutTokens.dart';
import 'package:med_reminder/core/date/week_date_strip_helper.dart';
import 'package:med_reminder/features/home/application/AppHomeVisibleWeekNotifier.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';

class DateStrip extends ConsumerStatefulWidget {
  const DateStrip({
    super.key,
    required this.selectedDay,
    required this.todayDay,
    required this.onDaySelected,
  });

  final DateTime selectedDay;
  final DateTime todayDay;
  final ValueChanged<DateTime> onDaySelected;

  @override
  ConsumerState<DateStrip> createState() => _DateStripState();
}

class _DateStripState extends ConsumerState<DateStrip> {
  int _slideDirection = 0;

  void _shiftWeek(int direction) {
    if (direction == 0) return;
    final visibleWeekSunday = ref.read(appHomeVisibleWeekNotifierProvider);
    final beforeDays = buildWeekStripDaysForWeekStart(visibleWeekSunday);
    final fromWeekStart = DateFormat('yyyy-MM-dd').format(beforeDays.first);
    ref.read(appHomeVisibleWeekNotifierProvider.notifier).shiftVisibleWeek(direction);
    final afterSunday = ref.read(appHomeVisibleWeekNotifierProvider);
    final afterDays = buildWeekStripDaysForWeekStart(afterSunday);
    final toWeekStart = DateFormat('yyyy-MM-dd').format(afterDays.first);
    ref.read(appPrdAnalyticsBridgeProvider).homeDatestripSwiped(
          direction: direction > 0 ? 'forward' : 'backward',
          fromWeekStart: fromWeekStart,
          toWeekStart: toWeekStart,
        );
    setState(() => _slideDirection = direction);
  }

  Color? _getDotColor(
    DateTime day,
    List<MedicineDoseOccurrenceRecordModel> occurrences,
  ) {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final dayRows = occurrences.where((o) {
      final scheduled = DateTime.tryParse(o.scheduledAtIso);
      if (scheduled == null) return false;
      return !scheduled.isBefore(dayStart) && scheduled.isBefore(dayEnd);
    }).toList();

    if (dayRows.isEmpty) return null;

    final total = dayRows.length;
    final taken = dayRows.where((o) => o.statusKind == MedicineDoseStatusKind.taken).length;

    if (taken == total) {
      return AppColorsDesignTokens.colorHealth;
    } else if (taken > 0) {
      return AppColorsDesignTokens.colorWarning;
    } else {
      return AppColorsDesignTokens.colorError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleWeekSunday = ref.watch(appHomeVisibleWeekNotifierProvider);
    final days = buildWeekStripDaysForWeekStart(visibleWeekSunday);

    final profileId = ref.watch(activeUserProfileIdProvider);
    final dataSnapshot = ref.watch(medicineAppDataNotifierProvider).valueOrNull;
    final occurrences = dataSnapshot?.doseOccurrences
        .where((o) => o.profileId == profileId)
        .toList() ?? const [];

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacingLayoutTokens.dateStripVerticalPadding,
        horizontal: AppSpacingLayoutTokens.dateStripHorizontalPadding,
      ),
      decoration: const BoxDecoration(
        color: AppColorsDesignTokens.backgroundPrimary,
        border: Border(bottom: BorderSide(color: AppColorsDesignTokens.divider)),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          if (velocity < -120) {
            _shiftWeek(1);
          } else if (velocity > 120) {
            _shiftWeek(-1);
          }
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final begin = Offset(_slideDirection >= 0 ? 1 : -1, 0);
            return ClipRect(
              child: SlideTransition(
                position: Tween<Offset>(begin: begin, end: Offset.zero).animate(animation),
                child: child,
              ),
            );
          },
          child: Row(
            key: ValueKey(visibleWeekSunday),
            children: [
              for (final day in days)
                Expanded(
                  child: _DateStripCell(
                    day: day,
                    selectedDay: widget.selectedDay,
                    todayDay: widget.todayDay,
                    onTap: () => widget.onDaySelected(day),
                    dotColor: _getDotColor(day, occurrences),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateStripCell extends StatelessWidget {
  const _DateStripCell({
    required this.day,
    required this.selectedDay,
    required this.todayDay,
    required this.onTap,
    this.dotColor,
  });

  final DateTime day;
  final DateTime selectedDay;
  final DateTime todayDay;
  final VoidCallback onTap;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final style = resolveDateStripCellStyle(
      cellDay: day,
      selectedDay: selectedDay,
      todayDay: todayDay,
    );
    final isPast = dateStripCellIsPastDay(cellDay: day, todayDay: todayDay);
    final sundayRed = dateStripDateNumberUsesSundayRed(
      cellDay: day,
      isSelected: style.isSelected,
    );

    final dayNameColor = style.dayNameIsLightOnFill
        ? AppColorsDesignTokens.backgroundPrimary
        : sundayRed
            ? AppColorsDesignTokens.colorError
            : AppColorsDesignTokens.textSecondary;

    final dateNumberColor = style.dateNumberIsLightOnFill
        ? AppColorsDesignTokens.backgroundPrimary
        : sundayRed
            ? AppColorsDesignTokens.colorError
            : isPast
                ? AppColorsDesignTokens.textSecondary
                : AppColorsDesignTokens.textPrimary;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 6),
      onPressed: onTap,
      child: SizedBox(
        height: AppSpacingLayoutTokens.dateStripCellHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: style.isSelected ? AppColorsDesignTokens.colorPrimary : null,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Column(
                  children: [
                    Text(
                      stripDayNameFor(day),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: dayNameColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: dateNumberColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (style.showTodayDot || dotColor != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (style.showTodayDot)
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: const BoxDecoration(
                          color: AppColorsDesignTokens.colorPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (dotColor != null)
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
