import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

/// Full-width rounded primary action (blue default, green for Take).
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.backgroundColor = AppColors.primaryBlue,
    this.textColor = AppColors.cardWhite,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final Color backgroundColor;
  final Color textColor;

  factory PrimaryActionButton.take({required String label, required VoidCallback onPressed}) {
    return PrimaryActionButton(
      label: label,
      onPressed: onPressed,
      backgroundColor: AppColors.healthGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fillColor =
        enabled ? backgroundColor : AppColors.primaryBlueDisabled;
    final labelColor =
        enabled ? textColor : AppColors.primaryBlueDisabledText;
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: fillColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.buttonLabel.copyWith(color: labelColor),
            ),
          ),
        ),
      ),
    );
  }
}
