import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';

/// Wireframe back header with optional trailing action (e.g. Edit).
class BackNavigationHeader extends StatelessWidget {
  const BackNavigationHeader({
    super.key,
    required this.title,
    this.trailingLabel,
    this.onBack,
    this.onTrailingTap,
  });

  final String title;
  final String? trailingLabel;
  final VoidCallback? onBack;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 6, 12, 10),
      decoration: const BoxDecoration(
        color: AppColorsDesignTokens.backgroundPrimary,
        border: Border(bottom: BorderSide(color: AppColorsDesignTokens.divider)),
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.all(8),
            minimumSize: Size.zero,
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            child: const Icon(
              CupertinoIcons.back,
              color: AppColorsDesignTokens.colorPrimary,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColorsDesignTokens.textPrimary,
              ),
            ),
          ),
          if (trailingLabel != null && onTrailingTap != null)
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              onPressed: onTrailingTap,
              child: Text(
                trailingLabel!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColorsDesignTokens.colorPrimary,
                ),
              ),
            )
          else
            const SizedBox(width: 44),
        ],
      ),
    );
  }
}
