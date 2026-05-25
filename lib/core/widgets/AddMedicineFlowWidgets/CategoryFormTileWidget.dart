import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../constants/AppShadowDesignTokens.dart';
import '../../constants/CategoryFormGridData.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

/// Wireframe `.cat-tile` — white card, tinted icon square, label.
class CategoryFormTileWidget extends StatelessWidget {
  const CategoryFormTileWidget({
    super.key,
    required this.itemData,
    required this.isSelected,
    required this.onTap,
    required this.isHorizontal,
  });

  final CategoryFormGridItemData itemData;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Container(
      width: AppDimensions.categoryFormTileIconSize,
      height: AppDimensions.categoryFormTileIconSize,
      decoration: BoxDecoration(
        color: itemData.tintBackground,
        borderRadius: BorderRadius.circular(AppDimensions.gapSM),
      ),
      alignment: Alignment.center,
      child: HugeIcon(
        icon: itemData.hugeIcon,
        color: itemData.tintIconColor,
        size: AppDimensions.categoryFormTileIconGlyphSize,
      ),
    );

    return Material(
      color: AppColors.cardWhite,
      borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
      elevation: 0,
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
            border: Border.all(
              color: isSelected ? itemData.tintIconColor : Colors.transparent,
              width: 2,
            ),
            boxShadow: AppShadowDesignTokens.cardShadow,
          ),
          padding: isHorizontal
              ? const EdgeInsets.symmetric(
                  horizontal: AppDimensions.gapMD,
                  vertical: AppDimensions.gapSM,
                )
              : const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: AppDimensions.gapSM,
                ),
          child: isHorizontal
              ? Row(
                  children: [
                    iconWidget,
                    const SizedBox(width: AppDimensions.gapMD),
                    Expanded(
                      child: Text(
                        itemData.label,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.cardSubtitle.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconWidget,
                    const SizedBox(height: 6.0),
                    Text(
                      itemData.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardSubtitle.copyWith(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
