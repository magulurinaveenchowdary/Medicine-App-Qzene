import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';
import '../../theme/AppTypographyDesignTokens.dart';
import 'package:med_reminder/core/widgets/common/AppMedicineRootPageScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/BannerAdPlaceholderWidget.dart';

/// Shared onboarding column: white bg, 22px horizontal padding, bottom ad strip.
class OnboardingPageLayout extends StatelessWidget {
  const OnboardingPageLayout({
    super.key,
    this.stepLabel,
    required this.children,
    this.footerActions = const [],
    this.showBannerAd = true,
  });

  final String? stepLabel;
  final List<Widget> children;
  final List<Widget> footerActions;
  final bool showBannerAd;

  @override
  Widget build(BuildContext context) {
    return AppMedicineRootPageScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (stepLabel != null) ...[
                      Text(
                        stepLabel!,
                        style: AppTypographyDesignTokens.flowStepProgress.copyWith(
                          color: AppColorsDesignTokens.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    ...children,
                  ],
                ),
              ),
            ),
            ...footerActions,
            if (showBannerAd) ...[
              const SizedBox(height: 8),
              const BannerAdPlaceholder(),
            ],
          ],
        ),
      ),
    );
  }
}
