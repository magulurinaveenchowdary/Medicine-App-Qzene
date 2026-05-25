import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';

/// Home top bar: avatar + profile name + calendar.
class HomeProfileTopBar extends StatelessWidget {
  const HomeProfileTopBar({
    super.key,
    required this.profileName,
    required this.avatarLetter,
    this.onCalendarTap,
    this.onProfileTap,
    this.onNotificationTap,
  });

  final String profileName;
  final String avatarLetter;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: AppColorsDesignTokens.backgroundPrimary,
        border: Border(bottom: BorderSide(color: AppColorsDesignTokens.divider)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColorsDesignTokens.colorPrimary,
              shape: BoxShape.circle,
            ),
            child: Text(
              avatarLetter,
              style: const TextStyle(
                color: AppColorsDesignTokens.backgroundPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onTap: onProfileTap,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      profileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColorsDesignTokens.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.chevron_down,
                    size: 14,
                    color: AppColorsDesignTokens.colorPrimary,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          if (onCalendarTap != null) ...[
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(36, 44),
              onPressed: onCalendarTap,
              child: const Icon(
                CupertinoIcons.calendar_today,
                color: AppColorsDesignTokens.colorPrimary,
                size: 22,
              ),
            ),
            const SizedBox(width: 4),
          ],
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size(36, 44),
            onPressed: onNotificationTap ?? () {},
            child: const Icon(
              CupertinoIcons.bell,
              color: AppColorsDesignTokens.colorPrimary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
