import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_text_styles.dart';

/// Wireframe `flow-header`: ‹ back, title, step "N / 7".
class AddFlowHeader extends StatelessWidget {
  const AddFlowHeader({
    super.key,
    required this.title,
    this.stepLabel,
    this.trailingActionLabel,
    this.trailingSubtitleLabel,
    this.onTrailingAction,
    this.onBack,
  });

  final String title;
  final String? stepLabel;
  final String? trailingActionLabel;
  final String? trailingSubtitleLabel;
  final VoidCallback? onTrailingAction;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardWhite,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingScreenH,
          vertical: 12,
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(44, 44),
                padding: EdgeInsets.zero,
              ),
              onPressed:
                  onBack ??
                  () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
              child: Text(
                '‹',
                style: AppFonts.inter(
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 20),
              ),
            ),
            SizedBox(
              width: trailingSubtitleLabel != null ? 72 : 44,
              child: trailingActionLabel != null
                  ? TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(44, 44),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: onTrailingAction,
                      child: Text(
                        trailingActionLabel!,
                        style: AppFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    )
                  : trailingSubtitleLabel != null
                  ? Text(
                      trailingSubtitleLabel!,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.flowStepProgress.copyWith(
                        fontSize: 11,
                      ),
                    )
                  : stepLabel != null
                  ? Text(
                      stepLabel!,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.flowStepProgress,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
