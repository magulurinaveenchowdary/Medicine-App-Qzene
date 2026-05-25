import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';
import '../../constants/AppSpacingLayoutTokens.dart';

/// Single selectable row (schedule type, language, etc.).
class SelectableOptionRow extends StatelessWidget {
  const SelectableOptionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColorsDesignTokens.backgroundPrimary,
            borderRadius: BorderRadius.circular(AppSpacingLayoutTokens.cardRadius),
            border: Border.all(
              color: selected
                  ? AppColorsDesignTokens.colorPrimary
                  : AppColorsDesignTokens.divider,
              width: selected ? 2 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                offset: Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: selected
                            ? AppColorsDesignTokens.colorPrimary
                            : AppColorsDesignTokens.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColorsDesignTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: AppColorsDesignTokens.colorPrimary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
