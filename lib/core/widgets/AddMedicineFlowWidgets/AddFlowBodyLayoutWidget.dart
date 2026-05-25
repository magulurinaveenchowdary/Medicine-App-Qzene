import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../common/AdBannerWidget.dart';

/// Add-medicine funnel body: grey background, scroll content, optional CTA + banner.
class AddFlowBodyLayout extends StatelessWidget {
  const AddFlowBodyLayout({
    super.key,
    required this.children,
    this.showBannerAd = true,
    this.bottomButton,
  });

  final List<Widget> children;
  final bool showBannerAd;
  final Widget? bottomButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ColoredBox(
        color: AppColors.backgroundGrey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.paddingScreenH,
            AppDimensions.addFlowBodyTopPadding,
            AppDimensions.paddingScreenH,
            AppDimensions.paddingCardInner,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
              if (bottomButton != null) ...[
                SizedBox(height: AppDimensions.gapMD),
                bottomButton!,
              ],
              if (showBannerAd) ...[
                SizedBox(height: AppDimensions.gapSM),
                const AdBanner(placement: 'add_flow'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
