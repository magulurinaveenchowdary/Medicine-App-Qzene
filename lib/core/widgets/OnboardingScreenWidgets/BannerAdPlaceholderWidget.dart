import 'package:flutter/widgets.dart';

import '../common/AdBannerWidget.dart';

/// Bottom banner on onboarding and similar surfaces.
class BannerAdPlaceholder extends StatelessWidget {
  const BannerAdPlaceholder({
    super.key,
    this.placement = 'onboarding',
  });

  final String placement;

  @override
  Widget build(BuildContext context) {
    return AdBanner(placement: placement);
  }
}
