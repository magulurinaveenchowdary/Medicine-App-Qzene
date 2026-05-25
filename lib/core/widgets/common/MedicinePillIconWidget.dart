import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';

/// Pill capsule icon used on med cards (wireframe SVG).
class MedicinePillIconWidget extends StatelessWidget {
  const MedicinePillIconWidget({
    super.key,
    this.size = 20,
    this.primaryColor = AppColorsDesignTokens.colorPrimary,
  });

  final double size;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.52,
      child: Container(
        width: size * 0.9,
        height: size * 0.28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.06),
          color: primaryColor,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: size * 0.45,
            height: size * 0.28,
            decoration: BoxDecoration(
              color: const Color(0xFF5BA3F7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size * 0.06),
                bottomLeft: Radius.circular(size * 0.06),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
