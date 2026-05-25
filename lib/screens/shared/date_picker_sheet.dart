import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/core/widgets/common/AppModalOverlayScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/SharedScreenWidgets/SharedBottomSheetSurfaceWidget.dart';
import 'package:med_reminder/core/widgets/common/MonthCalendarGridWidget.dart';
import 'package:med_reminder/core/constants/AppAnalyticsEventNamesConstants.dart';
import 'package:med_reminder/core/constants/AppAnalyticsParameterNamesConstants.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/services/AppFirebaseAnalyticsLoggingService.dart';
import 'package:med_reminder/features/home/application/AppHomeSelectedDateNotifier.dart';
import 'package:med_reminder/features/home/application/AppHomeVisibleWeekNotifier.dart';

class DatePickerSheet extends ConsumerStatefulWidget {
  const DatePickerSheet({super.key});
  @override
  ConsumerState<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends ConsumerState<DatePickerSheet> {
  var displayMonth = DateTime(2026, 3);
  var pickedDay = 18;
  late final DateTime _openedAt;
  var _didSelect = false;

  @override
  void initState() {
    super.initState();
    _openedAt = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selected = ref.read(appHomeSelectedDateNotifierProvider);
      setState(() {
        displayMonth = DateTime(selected.year, selected.month);
        pickedDay = selected.day;
      });
    });
  }

  void _applySelection() {
    _didSelect = true;
    final selected = DateTime(displayMonth.year, displayMonth.month, pickedDay);
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final daysFromToday = selected.difference(todayNorm).inDays;
    ref.read(appFirebaseAnalyticsLoggingServiceProvider).logPrdEvent(
      AppAnalyticsEventNamesConstants.homeCalendarDateSelected,
      {
        AppAnalyticsParameterNamesConstants.selectedDate:
            selected.toIso8601String().substring(0, 10),
        AppAnalyticsParameterNamesConstants.daysFromToday: daysFromToday,
        AppAnalyticsParameterNamesConstants.monthViewed:
            '${displayMonth.year}-${displayMonth.month.toString().padLeft(2, '0')}',
      },
    );
    ref.read(appFirebaseAnalyticsLoggingServiceProvider).logPrdEvent(
      AppAnalyticsEventNamesConstants.homeDateSelected,
      {
        AppAnalyticsParameterNamesConstants.selectedDate:
            selected.toIso8601String().substring(0, 10),
        AppAnalyticsParameterNamesConstants.daysFromToday: daysFromToday,
        AppAnalyticsParameterNamesConstants.source: 'calendar_picker',
      },
    );
    ref.read(appHomeSelectedDateNotifierProvider.notifier).selectCalendarDay(selected);
    ref.read(appHomeVisibleWeekNotifierProvider.notifier).showWeekContaining(selected);
    context.pop();
  }

  String get _monthLabel {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[displayMonth.month - 1]} ${displayMonth.year}';
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayDay = today.month == displayMonth.month && today.year == displayMonth.year
        ? today.day
        : -1;

    final viewedDate = ref.read(appHomeSelectedDateNotifierProvider);
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop && !_didSelect) {
          final dwell = DateTime.now().difference(_openedAt).inSeconds;
          ref.read(appPrdAnalyticsBridgeProvider).homeCalendarDismissed(
                dwelltimeSec: dwell,
                currentViewedDate: viewedDate.toIso8601String().substring(0, 10),
              );
        }
      },
      child: AppModalOverlayScaffold(
      barrierColor: CupertinoColors.black.withValues(alpha: 0.4),
      child: SharedBottomSheetSurfaceWidget(
        children: [
          MonthCalendarGridWidget(
            embedInCard: false,
            monthLabel: _monthLabel,
            visibleMonth: displayMonth,
            selectedDay: pickedDay,
            todayDay: todayDay,
            onDayTap: (day) {
              setState(() => pickedDay = day);
              _applySelection();
            },
            onPreviousMonth: () {
              setState(() {
                displayMonth = DateTime(displayMonth.year, displayMonth.month - 1);
              });
            },
            onNextMonth: () {
              setState(() {
                displayMonth = DateTime(displayMonth.year, displayMonth.month + 1);
              });
            },
          ),
          const SizedBox(height: 16),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColorsDesignTokens.colorPrimary,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
