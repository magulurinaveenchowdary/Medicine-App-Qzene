import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../common/AdBannerWidget.dart';
import 'FloatingAddButtonWidget.dart';

/// Tab root layout: grey body, in-content banner, optional FAB.
class TabScreenScaffold extends StatelessWidget {
  const TabScreenScaffold({
    super.key,
    required this.header,
    required this.body,
    this.showBannerAd = true,
    this.showFab = false,
    this.onFabPressed,
  });

  final Widget header;
  final Widget body;
  final bool showBannerAd;
  final bool showFab;
  final VoidCallback? onFabPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            Expanded(
              child: ColoredBox(
                color: AppColors.backgroundGrey,
                child: Column(
                  children: [
                    Expanded(child: body),
                    if (showBannerAd)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppDimensions.paddingScreenH,
                          0,
                          AppDimensions.paddingScreenH,
                          AppDimensions.gapSM,
                        ),
                        child: AdBanner(placement: 'tab_footer'),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (showFab && onFabPressed != null)
          Positioned(
            right: AppDimensions.paddingScreenH,
            bottom: showBannerAd ? AppDimensions.fabBottomOffset : AppDimensions.paddingScreenH,
            child: FloatingAddButton(onPressed: onFabPressed!),
          ),
      ],
    );
  }
}
