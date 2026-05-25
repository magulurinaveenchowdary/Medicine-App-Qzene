import 'package:flutter/material.dart';

import '../../constants/AppShadowDesignTokens.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

class MedicineNameSuggestionData {
  const MedicineNameSuggestionData({
    required this.name,
    required this.ingredientLine,
  });

  final String name;
  final String ingredientLine;
}

/// Wireframe autocomplete list on add-medicine name step.
class MedicineNameAutocompleteListWidget extends StatelessWidget {
  const MedicineNameAutocompleteListWidget({
    super.key,
    required this.suggestions,
    this.customQuery,
    this.onSuggestionTap,
    this.onCustomAddTap,
  });

  final List<MedicineNameSuggestionData> suggestions;
  final String? customQuery;
  final ValueChanged<MedicineNameSuggestionData>? onSuggestionTap;
  final VoidCallback? onCustomAddTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: AppShadowDesignTokens.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < suggestions.length; i++)
            _AutocompleteResultRow(
              name: suggestions[i].name,
              ingredientLine: suggestions[i].ingredientLine,
              showDivider: i < suggestions.length - 1 || customQuery != null,
              onTap: onSuggestionTap == null
                  ? null
                  : () => onSuggestionTap!(suggestions[i]),
            ),
          if (customQuery != null)
            _CustomAddRow(
              query: customQuery!,
              onTap: onCustomAddTap,
            ),
        ],
      ),
    );
  }
}

class _AutocompleteResultRow extends StatelessWidget {
  const _AutocompleteResultRow({
    required this.name,
    required this.ingredientLine,
    required this.showDivider,
    this.onTap,
  });

  final String name;
  final String ingredientLine;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingCardInner,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.divider))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
            ),
            Text(
              ingredientLine,
              style: AppTextStyles.cardSubtitle.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomAddRow extends StatelessWidget {
  const _CustomAddRow({required this.query, this.onTap});

  final String query;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingCardInner,
          vertical: 10,
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          '+ Add "$query" as a custom medicine',
          style: AppTextStyles.cardTitle.copyWith(
            fontSize: 13,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}
