import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../common/PrimaryActionButtonWidget.dart' as wireframe;

/// Back-compat — prefer [PrimaryActionButton].
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
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

  @override
  Widget build(BuildContext context) {
    return wireframe.PrimaryActionButton(
      label: label,
      onPressed: onPressed,
      enabled: enabled,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}
