import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsSupportProviders.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/AppModalOverlayScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/SectionLabelWidget.dart';

class AlarmSnoozeSheet extends StatefulWidget {
  const AlarmSnoozeSheet({
    super.key,
    this.medicineId,
    this.isConsolidated = false,
    this.medCount = 1,
  });

  final String? medicineId;
  final bool isConsolidated;
  final int medCount;

  static const _minuteOptions = ['1 min', '3 min', '5 min', '10 min', '30 min', '45 min'];
  static const _minuteValues = [1, 3, 5, 10, 30, 45];
  static const _hourOptions = ['1 hr', '2 hr', '3 hr'];
  static const _hourValues = [60, 120, 180];

  @override
  State<AlarmSnoozeSheet> createState() => _AlarmSnoozeSheetState();
}

class _AlarmSnoozeSheetState extends State<AlarmSnoozeSheet> {
  int? _selectedMinuteIndex = 3;

  Future<void> _onDurationSelected(int durationMin) async {
    final container = ProviderScope.containerOf(context);
    final bridge = container.read(appPrdAnalyticsBridgeProvider);
    if (widget.isConsolidated) {
      await bridge.alarmSnoozeAllTapped(widget.medCount, durationMin);
      final counts = container.read(alarmSessionActionCountsProvider);
      container.read(alarmSessionActionCountsProvider.notifier).state =
          counts.recordSnooze();
    } else if (widget.medicineId != null && widget.medicineId!.isNotEmpty) {
      await bridge.alarmSnoozeTapped(widget.medicineId!, durationMin);
    }
    if (context.mounted) context.pop(durationMin);
  }

  @override
  Widget build(BuildContext context) {
    return AppModalOverlayScaffold(
      child: AppModalBottomSheetSurface(
        children: [
          Text(
            'Snooze for how long?',
            textAlign: TextAlign.center,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 17),
          ),
          const SizedBox(height: AppDimensions.gapMD),
          const SectionLabel(text: 'MINUTES'),
          _SnoozeOptionGrid(
            options: AlarmSnoozeSheet._minuteOptions,
            selectedIndex: _selectedMinuteIndex,
            onSelected: (index) => _onDurationSelected(AlarmSnoozeSheet._minuteValues[index]),
          ),
          const SizedBox(height: AppDimensions.gapMD),
          const SectionLabel(text: 'HOURS'),
          _SnoozeOptionGrid(
            options: AlarmSnoozeSheet._hourOptions,
            onSelected: (index) => _onDurationSelected(AlarmSnoozeSheet._hourValues[index]),
          ),
          const SizedBox(height: AppDimensions.gapLG),
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 16,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SnoozeOptionGrid extends StatelessWidget {
  const _SnoozeOptionGrid({
    required this.options,
    required this.onSelected,
    this.selectedIndex,
  });

  final List<String> options;
  final ValueChanged<int> onSelected;
  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppDimensions.gapSM,
        crossAxisSpacing: AppDimensions.gapSM,
        childAspectRatio: 1.65,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final isSelected = index == selectedIndex;
        return Material(
          color: isSelected ? AppColors.primaryBlueTint : AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
          child: InkWell(
            onTap: () => onSelected(index),
            borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
            child: Center(
              child: Text(
                options[index],
                style: AppTextStyles.cardSubtitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
