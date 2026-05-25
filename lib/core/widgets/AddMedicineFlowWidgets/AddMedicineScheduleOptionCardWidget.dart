import 'package:flutter/material.dart';

import '../../constants/AppShadowDesignTokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

/// Selectable schedule / duration pattern row.
class AddMedicineScheduleOptionCardWidget extends StatelessWidget {
  const AddMedicineScheduleOptionCardWidget({
    super.key,
    this.emoji,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String? emoji;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.gapMD),
      child: Material(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        elevation: isSelected ? 0 : 0,
        shadowColor: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              border: isSelected
                  ? Border.all(color: AppColors.primaryBlue, width: 2)
                  : null,
              boxShadow: isSelected ? null : AppShadowDesignTokens.cardShadow,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingCardInner,
                vertical: isSelected ? AppDimensions.gapMD : 10,
              ),
              child: Row(
                children: [
                  if (emoji != null && emoji!.isNotEmpty) ...[
                    Text(emoji!, style: TextStyle(fontSize: isSelected ? 20 : 18)),
                    SizedBox(width: AppDimensions.gapSM),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.cardTitle.copyWith(
                            fontSize: isSelected ? 14 : 13,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: AppTextStyles.cardSubtitle.copyWith(
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Text(
                      '✓',
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 16,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
