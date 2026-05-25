import 'package:flutter/material.dart';

import '../../constants/AppShadowDesignTokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

/// White rounded card wrapper matching wireframe elevation.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.border,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppDimensions.paddingCardInner),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: border,
        boxShadow: AppShadowDesignTokens.cardShadow,
      ),
      child: child,
    );
    if (onTap == null) {
      return card;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: card,
      ),
    );
  }
}
