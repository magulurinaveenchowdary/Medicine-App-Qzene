import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/AppShadowDesignTokens.dart';
import '../../../features/medicines/domain/MedicineReminderDataModels.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';
import '../common/StatusBadgeWidget.dart';
import '../common/MedicinePillIconWidget.dart';

/// Pill icon + name + dosage + time + status badge (+ optional ⋮ menu).
class MedicineTile extends StatelessWidget {
  const MedicineTile({
    super.key,
    required this.rowModel,
    this.showAccentBorder = false,
    this.useEyeDropIcon = false,
    this.showKebabMenu = false,
    this.showScheduledTime = true,
    this.onKebabTap,
    this.showPopoverMenu = false,
    this.highlightMissedBorder = false,
    this.footerLink,
    this.onFooterTap,
    this.onPerMedTake,
    this.onPerMedSnooze,
    this.onPerMedSkip,
  });

  final MedicineDoseDisplayRowModel rowModel;
  final bool showAccentBorder;
  final bool useEyeDropIcon;
  final bool showKebabMenu;
  final bool showScheduledTime;
  final VoidCallback? onKebabTap;
  final bool showPopoverMenu;
  final bool highlightMissedBorder;
  final Widget? footerLink;
  final VoidCallback? onFooterTap;
  final VoidCallback? onPerMedTake;
  final VoidCallback? onPerMedSnooze;
  final VoidCallback? onPerMedSkip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.gapMD),
          padding: EdgeInsets.fromLTRB(
            showAccentBorder ? 9 : AppDimensions.paddingCardInner,
            AppDimensions.paddingCardInner,
            AppDimensions.paddingCardInner,
            AppDimensions.paddingCardInner,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: showAccentBorder
                ? const Border(
                    left: BorderSide(color: AppColors.primaryBlue, width: 3),
                  )
                : highlightMissedBorder
                    ? Border.all(color: AppColors.errorRed, width: 1.5)
                    : null,
            boxShadow: AppShadowDesignTokens.cardShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _MedicineIcon(
                    useEyeDropIcon: useEyeDropIcon,
                    isCriticalTint: rowModel.isCriticalTint,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rowModel.medicineDisplayName,
                          style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                        ),
                        Text(
                          rowModel.doseDescription,
                          style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
                        ),
                        if (footerLink != null) ...[
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: onFooterTap,
                            child: footerLink!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (showScheduledTime && rowModel.scheduledTimeLabel.isNotEmpty) ...[
                        Text(
                          rowModel.scheduledTimeLabel,
                          style: AppTextStyles.cardSubtitle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      _badgeForStatus(rowModel.statusKind),
                    ],
                  ),
                  if (showKebabMenu) ...[
                    const SizedBox(width: 2),
                    GestureDetector(
                      onTap: onKebabTap,
                      child: const _KebabMenuIcon(),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (showPopoverMenu)
          Positioned(
            top: 36,
            right: 8,
            child: _PerMedicinePopoverMenu(
              onTake: onPerMedTake ?? () {},
              onSnooze: onPerMedSnooze ?? () {},
              onSkip: onPerMedSkip ?? () {},
            ),
          ),
      ],
    );
  }

  StatusBadge _badgeForStatus(MedicineDoseStatusKind kind) {
    switch (kind) {
      case MedicineDoseStatusKind.taken:
        return const StatusBadge(
          label: 'Taken',
          kind: MedicineStatusBadgeKind.taken,
          showCheckmark: true,
        );
      case MedicineDoseStatusKind.upcoming:
        return const StatusBadge(
          label: 'Upcoming',
          kind: MedicineStatusBadgeKind.upcoming,
        );
      case MedicineDoseStatusKind.skipped:
        return const StatusBadge(
          label: 'Skipped',
          kind: MedicineStatusBadgeKind.skipped,
        );
      case MedicineDoseStatusKind.missed:
        return const StatusBadge(
          label: 'Missed',
          kind: MedicineStatusBadgeKind.missed,
        );
      case MedicineDoseStatusKind.snoozed:
        return const StatusBadge(
          label: 'Snoozed',
          kind: MedicineStatusBadgeKind.upcoming,
        );
    }
  }
}

class _MedicineIcon extends StatelessWidget {
  const _MedicineIcon({
    required this.useEyeDropIcon,
    required this.isCriticalTint,
  });

  final bool useEyeDropIcon;
  final bool isCriticalTint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.medIconSize,
      height: AppDimensions.medIconSize,
      decoration: BoxDecoration(
        color: useEyeDropIcon || isCriticalTint
            ? AppColors.healthGreenTint
            : AppColors.primaryBlueTint,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: useEyeDropIcon
          ? const Icon(
              CupertinoIcons.drop_fill,
              size: 20,
              color: AppColors.healthGreen,
            )
          : const MedicinePillIconWidget(
              size: 20,
              primaryColor: AppColors.primaryBlue,
            ),
    );
  }
}

class _KebabMenuIcon extends StatelessWidget {
  const _KebabMenuIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: Text(
          '⋮',
          style: AppTextStyles.cardTitle.copyWith(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _PerMedicinePopoverMenu extends StatelessWidget {
  const _PerMedicinePopoverMenu({
    required this.onTake,
    required this.onSnooze,
    required this.onSkip,
  });

  final VoidCallback onTake;
  final VoidCallback onSnooze;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      color: AppColors.cardWhite,
      child: SizedBox(
        width: 160,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PopoverRow(
              icon: Icons.check,
              iconColor: AppColors.healthGreen,
              label: 'Take Now',
              labelColor: AppColors.textPrimary,
              onTap: onTake,
            ),
            const Divider(height: 1),
            _PopoverRow(
              icon: Icons.access_time,
              iconColor: AppColors.warningOrange,
              label: 'Snooze',
              labelColor: AppColors.warningOrange,
              onTap: onSnooze,
            ),
            const Divider(height: 1),
            _PopoverRow(
              icon: Icons.close,
              iconColor: AppColors.textSecondary,
              label: 'Skip',
              labelColor: AppColors.textPrimary,
              onTap: onSkip,
            ),
          ],
        ),
      ),
    );
  }
}

class _PopoverRow extends StatelessWidget {
  const _PopoverRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTextStyles.cardSubtitle.copyWith(
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
