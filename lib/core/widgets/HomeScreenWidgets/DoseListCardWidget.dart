import 'package:flutter/widgets.dart';

import '../../../features/medicines/domain/MedicineReminderDataModels.dart';
import '../common/MedicineTileWidget.dart';

/// Wireframe med-card — delegates to [MedicineTile].
class DoseListCard extends StatelessWidget {
  const DoseListCard({
    super.key,
    required this.rowModel,
    this.showAccentBorder = false,
    this.useEyeDropIcon = false,
    this.showKebabMenu = false,
    this.showScheduledTime = true,
    this.showPopoverMenu = false,
    this.highlightMissedBorder = false,
    this.footerLink,
  });

  final MedicineDoseDisplayRowModel rowModel;
  final bool showAccentBorder;
  final bool useEyeDropIcon;
  final bool showKebabMenu;
  final bool showScheduledTime;
  final bool showPopoverMenu;
  final bool highlightMissedBorder;
  final Widget? footerLink;

  @override
  Widget build(BuildContext context) {
    return MedicineTile(
      rowModel: rowModel,
      showAccentBorder: showAccentBorder,
      useEyeDropIcon: useEyeDropIcon,
      showKebabMenu: showKebabMenu,
      showScheduledTime: showScheduledTime,
      showPopoverMenu: showPopoverMenu,
      highlightMissedBorder: highlightMissedBorder,
      footerLink: footerLink,
    );
  }
}
