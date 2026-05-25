import 'package:flutter/material.dart';

import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

/// Add-flow screen title block (wireframe: 20px title + 12px subtitle).
class AddMedicineFlowStepHeadingWidget extends StatelessWidget {
  const AddMedicineFlowStepHeadingWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.bottomSpacing = AppDimensions.addFlowHeadingBottomGap,
  });

  final String title;
  final String? subtitle;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.screenTitle.copyWith(
            fontSize: AppDimensions.addFlowStepTitleSize,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: AppDimensions.gapSM / 2),
          Text(
            subtitle!,
            style: AppTextStyles.cardSubtitle.copyWith(
              fontSize: AppDimensions.addFlowStepSubtitleSize,
            ),
          ),
        ],
        SizedBox(height: bottomSpacing),
      ],
    );
  }
}
