import 'package:flutter/material.dart';

import '../../constants/AppShadowDesignTokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

/// Wireframe `.cal-grid` month calendar with adherence dots from dose data.
class MonthCalendarGridWidget extends StatelessWidget {
  const MonthCalendarGridWidget({
    super.key,
    required this.monthLabel,
    required this.onDayTap,
    required this.visibleMonth,
    required this.selectedDay,
    required this.todayDay,
    this.embedInCard = true,
    this.onPreviousMonth,
    this.onNextMonth,
    this.adherencePercentByDay = const {},
  });

  final String monthLabel;
  final ValueChanged<int> onDayTap;
  final DateTime visibleMonth;
  final int selectedDay;
  final int todayDay;
  final bool embedInCard;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;
  final Map<int, int> adherencePercentByDay;

  static const _weekHeads = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final daysInMonth = DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final startWeekday = firstOfMonth.weekday % 7;
    final totalCells = ((startWeekday + daysInMonth + 6) ~/ 7) * 7;

    final grid = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _MonthNavButton(label: '◀', onPressed: onPreviousMonth),
            Text(monthLabel, style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
            _MonthNavButton(label: '▶', onPressed: onNextMonth),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(7, (index) {
            final isSunday = index == 0;
            return Expanded(
              child: Text(
                _weekHeads[index],
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionLabel.copyWith(
                  fontSize: 10,
                  color: isSunday ? AppColors.errorRed : AppColors.textSecondary,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: totalCells,
          itemBuilder: (context, index) {
            final dayNum = index - startWeekday + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return _CalDayCell(day: dayNum, isEmpty: true, onTap: () {});
            }
            final date = DateTime(visibleMonth.year, visibleMonth.month, dayNum);
            final isSunday = date.weekday == DateTime.sunday;
            final percent = adherencePercentByDay[dayNum];
            return _CalDayCell(
              day: dayNum,
              isSunday: isSunday,
              isSelected: dayNum == selectedDay,
              isToday: dayNum == todayDay,
              dotKind: _dotKindForPercent(percent),
              onTap: () => onDayTap(dayNum),
            );
          },
        ),
      ],
    );

    if (!embedInCard) return grid;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: AppShadowDesignTokens.cardShadow,
      ),
      child: grid,
    );
  }

  static _CalDotKind? _dotKindForPercent(int? percent) {
    if (percent == null || percent < 0) return null;
    if (percent == 100) return _CalDotKind.green;
    if (percent > 0) return _CalDotKind.amber;
    return _CalDotKind.red;
  }
}

class _MonthNavButton extends StatelessWidget {
  const _MonthNavButton({required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      onPressed: onPressed,
      icon: Text(label, style: AppTextStyles.cardTitle.copyWith(fontSize: 18, color: AppColors.primaryBlue, fontWeight: FontWeight.w400)),
    );
  }
}

enum _CalDotKind { green, amber, red }

class _CalDayCell extends StatelessWidget {
  const _CalDayCell({
    required this.day,
    required this.onTap,
    this.isSunday = false,
    this.isSelected = false,
    this.isToday = false,
    this.isEmpty = false,
    this.dotKind,
  });

  final int day;
  final VoidCallback onTap;
  final bool isSunday;
  final bool isSelected;
  final bool isToday;
  final bool isEmpty;
  final _CalDotKind? dotKind;

  @override
  Widget build(BuildContext context) {
    var textColor = isEmpty
        ? AppColors.textCaption
        : isSunday
            ? AppColors.errorRed
            : AppColors.textPrimary;
    if (isSelected) textColor = AppColors.cardWhite;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEmpty ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBlue : null,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primaryBlue, width: 1.5)
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!isEmpty)
                  Text(
                    '$day',
                    style: AppTextStyles.cardSubtitle.copyWith(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                if (dotKind != null && !isEmpty)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: switch (dotKind!) {
                          _CalDotKind.green => AppColors.healthGreen,
                          _CalDotKind.amber => AppColors.warningOrange,
                          _CalDotKind.red => AppColors.errorRed,
                        },
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
