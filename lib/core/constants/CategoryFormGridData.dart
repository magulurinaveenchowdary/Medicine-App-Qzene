import 'package:flutter/material.dart';

import 'AppColorsDesignTokens.dart';
import 'CategoryFormHugeIconMappingConstants.dart';

enum CategoryFormTintKind {
  blue,
  teal,
  green,
  purple,
  orange,
  grey,
}

class CategoryFormGridItemData {
  const CategoryFormGridItemData({
    required this.label,
    required this.tintKind,
    required this.hugeIcon,
  });

  final String label;
  final CategoryFormTintKind tintKind;
  final List<List<dynamic>> hugeIcon;

  Color get tintBackground => switch (tintKind) {
        CategoryFormTintKind.blue => AppColorsDesignTokens.colorPrimaryTint,
        CategoryFormTintKind.teal => AppColorsDesignTokens.colorTealTint,
        CategoryFormTintKind.green => AppColorsDesignTokens.colorHealthTint,
        CategoryFormTintKind.purple => AppColorsDesignTokens.colorPurpleTint,
        CategoryFormTintKind.orange => AppColorsDesignTokens.colorWarningTint,
        CategoryFormTintKind.grey => AppColorsDesignTokens.backgroundTertiary,
      };

  Color get tintIconColor => switch (tintKind) {
        CategoryFormTintKind.blue => AppColorsDesignTokens.colorPrimary,
        CategoryFormTintKind.teal => AppColorsDesignTokens.colorTeal,
        CategoryFormTintKind.green => AppColorsDesignTokens.colorHealth,
        CategoryFormTintKind.purple => AppColorsDesignTokens.colorPurple,
        CategoryFormTintKind.orange => AppColorsDesignTokens.colorWarning,
        CategoryFormTintKind.grey => AppColorsDesignTokens.textSecondary,
      };
}

/// 26 category tiles from wireframe `add_medicine_category`.
class CategoryFormGridData {
  CategoryFormGridData._();

  static final List<CategoryFormGridItemData> gridItems = [
    _item('Tablet', CategoryFormTintKind.blue),
    _item('Capsule', CategoryFormTintKind.blue),
    _item('Softgel', CategoryFormTintKind.blue),
    _item('Liquid / Syrup', CategoryFormTintKind.teal),
    _item('Drops', CategoryFormTintKind.teal),
    _item('Injection', CategoryFormTintKind.orange),
    _item('Inhaler', CategoryFormTintKind.purple),
    _item('Cream', CategoryFormTintKind.green),
    _item('Ointment', CategoryFormTintKind.green),
    _item('Gel', CategoryFormTintKind.green),
    _item('Lotion', CategoryFormTintKind.green),
    _item('Spray', CategoryFormTintKind.purple),
    _item('Sublingual', CategoryFormTintKind.blue),
    _item('Patch', CategoryFormTintKind.green),
    _item('Chewable', CategoryFormTintKind.blue),
    _item('Gummy', CategoryFormTintKind.blue),
    _item('Lozenge', CategoryFormTintKind.blue),
    _item('Powder / Sachet', CategoryFormTintKind.teal),
    _item('Suppository', CategoryFormTintKind.grey),
    _item('Foam', CategoryFormTintKind.green),
    _item('Chew bite', CategoryFormTintKind.blue),
    _item('Nasal capsule', CategoryFormTintKind.purple),
    _item('Toothpaste', CategoryFormTintKind.green),
    _item('Shampoo', CategoryFormTintKind.green),
    _item('Herb', CategoryFormTintKind.blue),
    _item('Others', CategoryFormTintKind.grey),
  ];

  static CategoryFormGridItemData _item(String label, CategoryFormTintKind tint) {
    return CategoryFormGridItemData(
      label: label,
      tintKind: tint,
      hugeIcon: CategoryFormHugeIconMappingConstants.iconForLabel(label),
    );
  }
}
