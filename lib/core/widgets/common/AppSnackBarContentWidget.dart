import 'package:flutter/material.dart';

import '../../constants/AppShadowDesignTokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

/// Semantic kind for [AppSnackBarContentWidget] styling.
enum AppSnackBarVariantKind {
  success,
  error,
  warning,
}

class _AppSnackBarVariantStyle {
  const _AppSnackBarVariantStyle({
    required this.surfaceColor,
    required this.borderColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.iconData,
  });

  final Color surfaceColor;
  final Color borderColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final IconData iconData;
}

/// Custom SnackBar body: tinted surface, icon badge, message (not default Material fill).
class AppSnackBarContentWidget extends StatelessWidget {
  const AppSnackBarContentWidget({
    super.key,
    required this.message,
    required this.variant,
    this.onDismiss,
  });

  final String message;
  final AppSnackBarVariantKind variant;
  final VoidCallback? onDismiss;

  static const double _iconBadgeSize = 36;
  static const double _iconGlyphSize = 22;

  @override
  Widget build(BuildContext context) {
    final variantStyle = _styleForVariant(variant);
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.gapMD,
          vertical: AppDimensions.gapMD,
        ),
        decoration: BoxDecoration(
          color: variantStyle.surfaceColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: variantStyle.borderColor),
          boxShadow: AppShadowDesignTokens.elevatedShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: _iconBadgeSize,
              height: _iconBadgeSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: variantStyle.iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                variantStyle.iconData,
                size: _iconGlyphSize,
                color: variantStyle.iconColor,
              ),
            ),
            const SizedBox(width: AppDimensions.gapMD),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.cardSubtitle.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onDismiss != null) ...[
              const SizedBox(width: AppDimensions.gapSM),
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded),
                color: AppColors.textSecondary,
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: AppDimensions.minTouchTarget,
                  minHeight: AppDimensions.minTouchTarget,
                ),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static _AppSnackBarVariantStyle _styleForVariant(AppSnackBarVariantKind kind) {
    switch (kind) {
      case AppSnackBarVariantKind.success:
        return const _AppSnackBarVariantStyle(
          surfaceColor: AppColors.healthGreenTint,
          borderColor: AppColors.healthGreen,
          iconBackgroundColor: AppColors.healthGreen,
          iconColor: AppColors.cardWhite,
          iconData: Icons.check_circle_rounded,
        );
      case AppSnackBarVariantKind.error:
        return const _AppSnackBarVariantStyle(
          surfaceColor: AppColors.errorRedTint,
          borderColor: AppColors.errorRed,
          iconBackgroundColor: AppColors.errorRed,
          iconColor: AppColors.cardWhite,
          iconData: Icons.error_outline_rounded,
        );
      case AppSnackBarVariantKind.warning:
        return const _AppSnackBarVariantStyle(
          surfaceColor: AppColors.warningOrangeTint,
          borderColor: AppColors.warningOrange,
          iconBackgroundColor: AppColors.warningOrange,
          iconColor: AppColors.cardWhite,
          iconData: Icons.warning_amber_rounded,
        );
    }
  }
}
