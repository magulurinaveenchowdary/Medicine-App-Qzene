import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/core/constants/AppSpacingLayoutTokens.dart';
import 'package:med_reminder/core/theme/AppTypographyDesignTokens.dart';
import 'package:med_reminder/core/widgets/common/AppMedicineRootPageScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/OnboardingAnalyticsPopScopeWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/BannerAdPlaceholderWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/BrandPillIconWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/OnboardingPrimaryButtonWidget.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});
  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OnboardingAnalyticsPopScope(
      atStep: 'welcome',
      child: AppMedicineRootPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacingLayoutTokens.onboardingHorizontal,
          70,
          AppSpacingLayoutTokens.onboardingHorizontal,
          12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BrandPillIcon(),
                  const SizedBox(height: 32),
                  Text(
                    l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: AppTypographyDesignTokens.onboardingTitleLarge.copyWith(
                      color: AppColorsDesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.medicineReminderTagline,
                    textAlign: TextAlign.center,
                    style: AppTypographyDesignTokens.screenSubtitle.copyWith(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColorsDesignTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            PrimaryButton(
              label: l10n.getStarted,
              onPressed: () => context.push('/onboarding/permissions'),
            ),
            const SizedBox(height: 10),
            const BannerAdPlaceholder(),
          ],
        ),
      ),
    ),
    );
  }
}
