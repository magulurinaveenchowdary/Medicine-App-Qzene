import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';
import '../../constants/AppShadowDesignTokens.dart';
import '../../constants/AppSpacingLayoutTokens.dart';

/// Blue circular FAB with shadow (wireframe).
class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: AppSpacingLayoutTokens.fabSize,
        height: AppSpacingLayoutTokens.fabSize,
        decoration: const BoxDecoration(
          color: AppColorsDesignTokens.colorPrimary,
          shape: BoxShape.circle,
          boxShadow: AppShadowDesignTokens.fabShadow,
        ),
        alignment: Alignment.center,
        child: const Icon(
          CupertinoIcons.add,
          color: AppColorsDesignTokens.backgroundPrimary,
          size: 28,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
