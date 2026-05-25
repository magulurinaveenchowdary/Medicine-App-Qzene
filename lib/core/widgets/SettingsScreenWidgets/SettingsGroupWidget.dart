import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

/// Wireframe `.settings-list` grouped rows.
class SettingsGroupWidget extends StatelessWidget {
  const SettingsGroupWidget({
    super.key,
    required this.rows,
  });

  final List<WireframeSettingsRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardWhite,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++)
            WireframeSettingsRowWidget(
              data: rows[index],
              showDivider: index < rows.length - 1,
            ),
        ],
      ),
    );
  }
}

class WireframeSettingsRowData {
  const WireframeSettingsRowData({
    required this.label,
    this.valueLabel,
    this.showToggle = false,
    this.toggleOn = true,
    this.onTap,
  });

  final String label;
  final String? valueLabel;
  final bool showToggle;
  final bool toggleOn;
  final VoidCallback? onTap;
}

class WireframeSettingsRowWidget extends StatelessWidget {
  const WireframeSettingsRowWidget({
    super.key,
    required this.data,
    this.showDivider = true,
  });

  final WireframeSettingsRowData data;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final row = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingCardInner,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(data.label, style: AppTextStyles.cardSubtitle.copyWith(
              fontSize: 14,
              color: AppColors.textPrimary,
            )),
          ),
          if (data.showToggle)
            _WireframeToggleWidget(isOn: data.toggleOn)
          else if (data.valueLabel != null)
            Text(
              '${data.valueLabel} ›',
              style: AppTextStyles.cardSubtitle.copyWith(fontSize: 13),
            ),
        ],
      ),
    );

    if (data.onTap == null) {
      return row;
    }

    return InkWell(
      onTap: data.onTap,
      child: row,
    );
  }
}

class _WireframeToggleWidget extends StatelessWidget {
  const _WireframeToggleWidget({required this.isOn});

  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 36,
      height: 22,
      decoration: BoxDecoration(
        color: isOn ? AppColors.healthGreen : AppColors.textCaption,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Align(
        alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 18,
          height: 18,
          margin: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: AppColors.cardWhite,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
