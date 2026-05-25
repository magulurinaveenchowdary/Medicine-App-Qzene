import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_styles.dart';

/// Colored circle with initial letter (Margaret blue, David orange, etc.).
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.letter,
    required this.backgroundColor,
    this.size = AppDimensions.profileAvatarSmall,
  });

  final String letter;
  final Color backgroundColor;
  final double size;

  factory ProfileAvatar.margaret({double size = AppDimensions.profileAvatarSmall}) {
    return ProfileAvatar(
      letter: 'M',
      backgroundColor: AppColors.avatarMargaretBlue,
      size: size,
    );
  }

  factory ProfileAvatar.david({double size = AppDimensions.profileAvatarSmall}) {
    return ProfileAvatar(
      letter: 'D',
      backgroundColor: AppColors.avatarDavidOrange,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        letter,
        style: AppTextStyles.buttonLabel.copyWith(
          fontSize: size * 0.42,
          color: AppColors.cardWhite,
        ),
      ),
    );
  }
}
