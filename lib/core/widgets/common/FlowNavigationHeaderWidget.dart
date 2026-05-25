import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../constants/AppColorsDesignTokens.dart';
import '../../constants/AppSpacingLayoutTokens.dart';

/// Cupertino-style header used across funnel and sub-pages (wireframe `flow-header`).
class FlowNavigationHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const FlowNavigationHeader({
    super.key,
    required this.pageTitle,
    this.leadingLabel,
    this.trailingLabel,
    this.onTrailingTap,
  });

  final String pageTitle;
  final String? leadingLabel;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacingLayoutTokens.screenHorizontal,
      ),
      decoration: const BoxDecoration(
        color: AppColorsDesignTokens.backgroundPrimary,
        border: Border(bottom: BorderSide(color: AppColorsDesignTokens.divider)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacingLayoutTokens.minTouchTarget,
            height: AppSpacingLayoutTokens.minTouchTarget,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/main/today');
                }
              },
              child: Text(
                leadingLabel ?? '‹',
                style: const TextStyle(
                  fontSize: 22,
                  color: AppColorsDesignTokens.colorPrimary,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              pageTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColorsDesignTokens.textPrimary,
              ),
            ),
          ),
          SizedBox(
            width: AppSpacingLayoutTokens.minTouchTarget,
            height: AppSpacingLayoutTokens.minTouchTarget,
            child: trailingLabel != null
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: onTrailingTap,
                    child: Text(
                      trailingLabel!,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColorsDesignTokens.colorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
