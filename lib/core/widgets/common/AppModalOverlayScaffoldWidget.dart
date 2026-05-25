import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

/// Modal route shell: dimmed barrier, tap-to-dismiss, and a [Material] child for overlays.
class AppModalOverlayScaffold extends StatelessWidget {
  const AppModalOverlayScaffold({
    super.key,
    required this.child,
    this.onBarrierTap,
    this.barrierColor,
    this.alignment = Alignment.bottomCenter,
  });

  final Widget child;
  final VoidCallback? onBarrierTap;
  final Color? barrierColor;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onBarrierTap ?? () => context.pop(),
            child: ColoredBox(
              color: barrierColor ?? AppColors.modalScrim,
            ),
          ),
          Align(
            alignment: alignment,
            child: Material(
              color: Colors.transparent,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet surface used by picker and action sheets.
class AppModalBottomSheetSurface extends StatelessWidget {
  const AppModalBottomSheetSurface({
    super.key,
    required this.children,
    this.backgroundColor = AppColors.cardWhite,
  });

  final List<Widget> children;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusCard),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.paddingScreenH,
            10,
            AppDimensions.paddingScreenH,
            12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundTertiary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
