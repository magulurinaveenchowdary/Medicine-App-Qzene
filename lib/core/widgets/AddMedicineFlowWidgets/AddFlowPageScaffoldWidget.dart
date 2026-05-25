import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../analytics/AddFlowAnalyticsExitStepHelper.dart';
import '../../analytics/AppPrdAnalyticsBridge.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../common/AdBannerWidget.dart';
import '../AddMedicineFlowWidgets/AddFlowBodyLayoutWidget.dart';
import '../common/AddFlowHeaderWidget.dart';

/// Standard add-medicine page: white header bar + grey scroll body.
class AddFlowPageScaffold extends ConsumerWidget {
  const AddFlowPageScaffold({
    super.key,
    required this.headerTitle,
    required this.stepLabel,
    required this.children,
    this.bottomButton,
    this.showBannerAd = true,
    this.onBack,
    this.logCancelOnBack = true,
  });

  final String headerTitle;
  final String stepLabel;
  final List<Widget> children;
  final Widget? bottomButton;
  final bool showBannerAd;
  final VoidCallback? onBack;
  final bool logCancelOnBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasBottomBar = bottomButton != null || showBannerAd;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.cardWhite,
      // Keyboard inset applied manually on the footer so Continue stays visible.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AddFlowHeader(
              title: headerTitle,
              stepLabel: stepLabel,
              onBack: onBack ??
                  () {
                    if (logCancelOnBack && context.canPop()) {
                      ref.read(appPrdAnalyticsBridgeProvider).addMedCancelled(
                            AddFlowAnalyticsExitStepHelper.fromStepLabel(stepLabel),
                          );
                    }
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
            ),
            AddFlowBodyLayout(
              showBannerAd: false,
              children: children,
            ),
            if (hasBottomBar)
              AnimatedPadding(
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: keyboardInset),
                child: _AddFlowBottomBar(
                  bottomButton: bottomButton,
                  showBannerAd: showBannerAd,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddFlowBottomBar extends StatelessWidget {
  const _AddFlowBottomBar({
    required this.bottomButton,
    required this.showBannerAd,
  });

  final Widget? bottomButton;
  final bool showBannerAd;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundGrey,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.paddingScreenH,
            AppDimensions.gapMD,
            AppDimensions.paddingScreenH,
            AppDimensions.paddingCardInner,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ?bottomButton,
              if (showBannerAd) ...[
                if (bottomButton != null) const SizedBox(height: AppDimensions.gapSM),
                const AdBanner(placement: 'add_flow'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
