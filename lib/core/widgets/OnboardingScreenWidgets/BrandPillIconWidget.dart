import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';

/// Two-tone pill icon on welcome screen (wireframe SVG approximation).
class BrandPillIcon extends StatelessWidget {
  const BrandPillIcon({
    super.key,
    this.size = 96,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColorsDesignTokens.colorPrimary,
        borderRadius: BorderRadius.circular(size * 0.23),
      ),
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: -0.52,
        child: Container(
          width: size * 0.55,
          height: size * 0.18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.04),
            color: AppColorsDesignTokens.backgroundPrimary,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: size * 0.28,
              height: size * 0.18,
              decoration: BoxDecoration(
                color: const Color(0xFF5BA3F7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.04),
                  bottomLeft: Radius.circular(size * 0.04),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
