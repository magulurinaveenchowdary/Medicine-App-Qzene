import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';
import '../../constants/AppShadowDesignTokens.dart';
import '../../constants/AppSpacingLayoutTokens.dart';
import 'OnboardingCompactPrimaryButtonWidget.dart';

/// Single permission row on onboarding_permissions wireframe.
class PermissionSetupCard extends StatelessWidget {
  const PermissionSetupCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    this.isGranted = false,
    this.isRequired = false,
    this.onAllow,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final bool isGranted;
  final bool isRequired;
  final VoidCallback? onAllow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColorsDesignTokens.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppSpacingLayoutTokens.cardRadius),
        boxShadow: AppShadowDesignTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: isRequired ? 12 : 13,
                          color: AppColorsDesignTokens.textPrimary,
                        ),
                        children: [
                          TextSpan(text: title),
                          if (isRequired)
                            const TextSpan(
                              text: ' *required',
                              style: TextStyle(
                                color: AppColorsDesignTokens.colorError,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isGranted ? 11 : 10,
                        color: AppColorsDesignTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onAllow != null && !isGranted) ...[
            const SizedBox(height: 8),
            OnboardingCompactPrimaryButtonWidget(
              label: 'Allow',
              onPressed: onAllow!,
            ),
          ],
        ],
      ),
    );
  }
}
