import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';

/// Full-screen page shell: [CupertinoPageScaffold], [SafeArea], and theme-safe background.
class AppMedicineRootPageScaffold extends StatelessWidget {
  const AppMedicineRootPageScaffold({
    super.key,
    required this.child,
    this.backgroundColor = AppColorsDesignTokens.backgroundPrimary,
    this.navigationBar,
    this.resizeToAvoidBottomInset = true,
    this.applySafeArea = true,
  });

  final Widget child;
  final Color backgroundColor;
  final ObstructingPreferredSizeWidget? navigationBar;
  final bool resizeToAvoidBottomInset;
  final bool applySafeArea;

  @override
  Widget build(BuildContext context) {
    final body = applySafeArea ? SafeArea(child: child) : child;
    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      navigationBar: navigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      child: body,
    );
  }
}
