import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';

/// Smaller Allow button on permission cards (wireframe padding 8px, 13px font).
class OnboardingCompactPrimaryButtonWidget extends StatelessWidget {
  const OnboardingCompactPrimaryButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 8),
        borderRadius: BorderRadius.circular(10),
        color: AppColorsDesignTokens.colorPrimary,
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColorsDesignTokens.backgroundPrimary,
          ),
        ),
      ),
    );
  }
}
