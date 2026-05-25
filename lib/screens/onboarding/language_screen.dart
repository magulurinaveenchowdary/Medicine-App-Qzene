import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/core/constants/AppAnalyticsEventNamesConstants.dart';
import 'package:med_reminder/core/constants/AppAnalyticsParameterNamesConstants.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/services/AppFirebaseAnalyticsLoggingService.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/OnboardingAnalyticsPopScopeWidget.dart';
import 'package:med_reminder/core/theme/AppTypographyDesignTokens.dart';
import 'package:med_reminder/core/widgets/common/FormSectionCardWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/OnboardingPageLayoutWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/OnboardingPrimaryButtonWidget.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});
  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final analytics = ref.read(appFirebaseAnalyticsLoggingServiceProvider);
      await analytics.logPrdEvent(
        AppAnalyticsEventNamesConstants.onbRegionDetected,
        {
          AppAnalyticsParameterNamesConstants.region: 'OTHER',
          AppAnalyticsParameterNamesConstants.source: 'locale',
        },
      );
      await analytics.syncUserRegionUserProperty('OTHER');
      await ref.read(appPrdAnalyticsBridgeProvider).onbLanguageSelected(
            language: 'en',
            wasDefault: true,
          );
      await analytics.syncUiLanguageUserProperty('en');
    });
  }

  Future<void> _selectLanguage(String language) async {
    final bridge = ref.read(appPrdAnalyticsBridgeProvider);
    await bridge.onbLanguageSelected(language: language, wasDefault: false);
    await ref.read(appFirebaseAnalyticsLoggingServiceProvider).syncUiLanguageUserProperty(language);
    if (language == 'es') {
      await bridge.onbRegionChanged('OTHER', 'US');
    } else if (language == 'zh') {
      await bridge.onbRegionChanged('OTHER', 'CN');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OnboardingAnalyticsPopScope(
      atStep: 'region',
      child: OnboardingPageLayout(
        stepLabel: l10n.stepProgress(3, 4),
        footerActions: [
          PrimaryButton(
            label: l10n.continueLabel,
            onPressed: () => context.push('/onboarding/profile'),
          ),
          const SizedBox(height: 8),
        ],
        children: [
          Text(
            'Pick your language',
            style: AppTypographyDesignTokens.onboardingTitleMedium.copyWith(
              color: AppColorsDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can change this anytime in Settings.',
            style: AppTypographyDesignTokens.screenSubtitle.copyWith(
              fontSize: 14,
              color: AppColorsDesignTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          const FormSectionCard(
            padding: EdgeInsets.all(16),
            selectedBorder: true,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'English',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: AppColorsDesignTokens.textPrimary,
                        ),
                      ),
                      Text(
                        'Default · auto-detected',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColorsDesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '✓',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColorsDesignTokens.colorPrimary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _selectLanguage('es'),
            child: const FormSectionCard(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Español',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: AppColorsDesignTokens.textPrimary,
                    ),
                  ),
                  Text(
                    'Spanish',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColorsDesignTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _selectLanguage('zh'),
            child: const FormSectionCard(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '中文',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: AppColorsDesignTokens.textPrimary,
                    ),
                  ),
                  Text(
                    'Simplified Chinese',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColorsDesignTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
