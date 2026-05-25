import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';
import '../../theme/AppTypographyDesignTokens.dart';
import 'ShellBottomNavIconWidget.dart';

/// Wireframe bottom nav: 4 tabs, active tab blue bold.
class ShellBottomTabBar extends StatelessWidget {
  const ShellBottomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.todayLabel,
    required this.medicinesLabel,
    required this.historyLabel,
    required this.settingsLabel,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final String todayLabel;
  final String medicinesLabel;
  final String historyLabel;
  final String settingsLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColorsDesignTokens.backgroundPrimary,
        border: Border(top: BorderSide(color: AppColorsDesignTokens.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 14),
      child: Row(
        children: [
          _TabItemWidget(
            index: 0,
            currentIndex: currentIndex,
            tabKind: WireframeBottomNavTabKind.today,
            label: todayLabel,
            onTap: onTap,
          ),
          _TabItemWidget(
            index: 1,
            currentIndex: currentIndex,
            tabKind: WireframeBottomNavTabKind.medicines,
            label: medicinesLabel,
            onTap: onTap,
          ),
          _TabItemWidget(
            index: 2,
            currentIndex: currentIndex,
            tabKind: WireframeBottomNavTabKind.history,
            label: historyLabel,
            onTap: onTap,
          ),
          _TabItemWidget(
            index: 3,
            currentIndex: currentIndex,
            tabKind: WireframeBottomNavTabKind.settings,
            label: settingsLabel,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _TabItemWidget extends StatelessWidget {
  const _TabItemWidget({
    required this.index,
    required this.currentIndex,
    required this.tabKind,
    required this.label,
    required this.onTap,
  });

  final int index;
  final int currentIndex;
  final WireframeBottomNavTabKind tabKind;
  final String label;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final active = index == currentIndex;
    final color = active
        ? AppColorsDesignTokens.colorPrimary
        : AppColorsDesignTokens.textSecondary;
    return Expanded(
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShellBottomNavIconWidget(
              tabKind: tabKind,
              isActive: active,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypographyDesignTokens.navTabLabel.copyWith(
                color: color,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
