import 'package:flutter/cupertino.dart';

import '../../constants/AppColorsDesignTokens.dart';
import '../../constants/AppSpacingLayoutTokens.dart';

/// Grouped label/value rows inside a white card (detail / settings).
class DetailRowsCard extends StatelessWidget {
  const DetailRowsCard({
    super.key,
    required this.rows,
  });

  final List<DetailRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsDesignTokens.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppSpacingLayoutTokens.cardRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            DetailRowTile(
              rowData: rows[i],
              showDivider: i < rows.length - 1,
            ),
        ],
      ),
    );
  }
}

class DetailRowData {
  const DetailRowData({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}

class DetailRowTile extends StatelessWidget {
  const DetailRowTile({
    super.key,
    required this.rowData,
    this.showDivider = true,
  });

  final DetailRowData rowData;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(color: AppColorsDesignTokens.divider),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            rowData.label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColorsDesignTokens.textPrimary,
            ),
          ),
          Flexible(
            child: Text(
              rowData.value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                color: rowData.valueColor ?? AppColorsDesignTokens.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
