import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/AppModalOverlayScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/PrimaryActionButtonWidget.dart';

class AfterCallDisableSheet extends StatelessWidget {
  const AfterCallDisableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppModalOverlayScaffold(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Material(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Switch off After-Call?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 10),
                Text(
                  'After-Call keeps you informed after every phone call when your next medicine is due. Are you sure you want to switch it off?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.cardSubtitle.copyWith(
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppDimensions.gapLG),
                PrimaryActionButton(
                  label: 'Cancel',
                  onPressed: () => context.pop(false),
                ),
                TextButton(
                  onPressed: () => context.pop(true),
                  child: Text(
                    'Yes, switch off',
                    style: AppTextStyles.cardTitle.copyWith(
                      fontSize: 15,
                      color: AppColors.errorRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
