import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';

/// Uppercase grey section header (e.g. "TODAY'S MEDICINES — 5 SCHEDULED").
class SectionLabel extends StatelessWidget {
  const SectionLabel({
    super.key,
    required this.text,
    this.trailing,
  });

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text.toUpperCase(),
              style: AppTextStyles.sectionLabel,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
