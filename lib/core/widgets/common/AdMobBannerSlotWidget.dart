import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../analytics/AppPrdAnalyticsBridge.dart';
import '../../constants/AppAdMobUnitIdentifiersConstants.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'DashedBorderBoxWidget.dart';

/// Adaptive banner for a named placement (resolves unit id from constants).
class AdMobBannerSlot extends ConsumerStatefulWidget {
  const AdMobBannerSlot({
    super.key,
    required this.placement,
    this.onAftercallTap,
  });

  final String placement;
  final VoidCallback? onAftercallTap;

  @override
  ConsumerState<AdMobBannerSlot> createState() => _AdMobBannerSlotState();
}

class _AdMobBannerSlotState extends ConsumerState<AdMobBannerSlot> {
  BannerAd? _bannerAd;
  bool _loaded = false;
  bool _loadStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startBannerLoadIfNeeded();
  }

  @override
  void didUpdateWidget(AdMobBannerSlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.placement != widget.placement) {
      _bannerAd?.dispose();
      _bannerAd = null;
      _loaded = false;
      _loadStarted = false;
      _startBannerLoadIfNeeded();
    }
  }

  Future<void> _startBannerLoadIfNeeded() async {
    if (_loadStarted || _bannerAd != null) return;
    _loadStarted = true;
    final AdSize? size;
    if (widget.placement == 'after_call_single') {
      size = AdSize.mediumRectangle;
    } else {
      final width = MediaQuery.sizeOf(context).width.truncate();
      size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    }
    if (!mounted) return;
    if (size == null) {
      developer.log('Adaptive banner size null', name: 'AdMob');
      _loadStarted = false;
      return;
    }
    final bridge = ref.read(appPrdAnalyticsBridgeProvider);
    final adUnitId = AppAdMobUnitIdentifiersConstants.resolveAndroidBannerUnitId(
      widget.placement,
    );
    final banner = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() => _loaded = true);
          bridge.adBannerLoaded(widget.placement);
        },
        onAdFailedToLoad: (ad, error) {
          developer.log(
            'Banner failed (${widget.placement}): $error',
            name: 'AdMob',
          );
          bridge.adBannerFailed(
            widget.placement,
            '${error.code}',
          );
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
              _loaded = false;
              _loadStarted = false;
            });
          }
        },
        onAdOpened: (_) {
          if (widget.onAftercallTap != null) {
            bridge.adAftercallBannerClicked();
            widget.onAftercallTap!();
          } else {
            bridge.adBannerClicked(widget.placement);
          }
        },
      ),
    )..load();
    setState(() => _bannerAd = banner);
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdLoaded = _loaded && _bannerAd != null;
    final isMediumRect = widget.placement == 'after_call_single';
    final height = isAdLoaded
        ? _bannerAd!.size.height.toDouble()
        : (isMediumRect
            ? 250.0 + 22.0
            : AppDimensions.adBannerHeight + 22.0); // Extra space for Sponsored label above the dashed box
    return Center(
      child: SizedBox(
        width: isMediumRect ? 300.0 : double.infinity,
        height: height,
        child: isAdLoaded
            ? AdWidget(ad: _bannerAd!)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isMediumRect ? CrossAxisAlignment.center : CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: isMediumRect ? 0 : 4),
                    child: Text(
                      'SPONSORED',
                      style: AppTextStyles.captionSponsored,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: DashedBorderBoxWidget(
                      borderRadius: 12,
                      color: AppColors.textSecondary.withOpacity(0.4),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          isMediumRect
                              ? 'Medium Rectangle Ad\n300 × 250'
                              : 'Banner ad placement - 320x50',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
