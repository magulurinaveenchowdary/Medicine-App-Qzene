import 'package:flutter/material.dart';

import 'AdMobBannerSlotWidget.dart';

/// Banner ad for [placement] (unit id resolved in [AppAdMobUnitIdentifiersConstants]).
class AdBanner extends StatelessWidget {
  const AdBanner({
    super.key,
    required this.placement,
    this.onAftercallTap,
  });

  final String placement;
  final VoidCallback? onAftercallTap;

  @override
  Widget build(BuildContext context) {
    return AdMobBannerSlot(
      placement: placement,
      onAftercallTap: onAftercallTap,
    );
  }
}
