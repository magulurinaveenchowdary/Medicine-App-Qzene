import 'package:flutter/material.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';

class ScheduleDetailsCountChipWidget extends StatelessWidget {
  const ScheduleDetailsCountChipWidget({
    super.key,
    required this.value,
    required this.isSelected,
    required this.onTap,
    this.label,
  });

  final int value;
  final bool isSelected;
  final VoidCallback onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primaryBlue : AppColors.backgroundTertiary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: AppDimensions.addFlowScheduleChipSize,
          height: AppDimensions.addFlowScheduleChipSize,
          child: Center(
            child: Text(
              label ?? '$value',
              style: AppTextStyles.cardTitle.copyWith(
                fontSize: label != null ? 11 : 15,
                color: isSelected ? AppColors.cardWhite : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
