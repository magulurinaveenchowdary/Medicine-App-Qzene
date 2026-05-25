import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';
import '../../theme/AppTypographyDesignTokens.dart';

/// Wireframe `.section-header` with optional back-to-today pill.
class SectionHeaderWidget extends StatelessWidget {
  const SectionHeaderWidget({
    super.key,
    required this.label,
    this.backToTodayLabel,
    this.onBackToToday,
    this.trailing,
  });

  final String label;
  final String? backToTodayLabel;
  final VoidCallback? onBackToToday;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypographyDesignTokens.sectionHeaderUppercase.copyWith(
                color: AppColorsDesignTokens.textSecondary,
              ),
            ),
          ),
          if (trailing != null)
            trailing!
          else if (backToTodayLabel != null && onBackToToday != null)
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              minimumSize: Size.zero,
              onPressed: onBackToToday,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColorsDesignTokens.backgroundPrimary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColorsDesignTokens.divider),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  child: Text(
                    backToTodayLabel!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColorsDesignTokens.colorPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
