import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';

/// Wireframe `.sheet` bottom surface (18px top radius, drag handle).
class SharedBottomSheetSurfaceWidget extends StatelessWidget {
  const SharedBottomSheetSurfaceWidget({
    super.key,
    required this.children,
    this.maxHeightFraction = 0.75,
  });

  final List<Widget> children;
  final double maxHeightFraction;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFraction;
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColorsDesignTokens.backgroundPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1F000000),
                offset: Offset(0, -4),
                blurRadius: 20,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColorsDesignTokens.textTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
