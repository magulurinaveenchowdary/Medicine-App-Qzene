import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reminder/core/constants/CategoryFormUnitMappingConstants.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/AppModalOverlayScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/SectionLabelWidget.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';

class AddMedicineUnitPickerSheet extends ConsumerWidget {
  const AddMedicineUnitPickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      barrierColor: AppColors.modalScrim,
      builder: (ctx) => const AddMedicineUnitPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(addMedicineDraftNotifierProvider);
    final compatibleUnits = CategoryFormUnitMappingConstants.compatibleUnitsForForm(
      draft.categoryFormLabel,
    );
    final defaultUnit = CategoryFormUnitMappingConstants.defaultUnitForForm(
      draft.categoryFormLabel,
    );

    final screenSize = MediaQuery.sizeOf(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenSize.width,
            maxHeight: screenSize.height * 0.75,
          ),
          child: SingleChildScrollView(
            child: AppModalBottomSheetSurface(
              children: [
                Text(
                  'Choose unit',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 17),
                ),
                SizedBox(height: AppDimensions.gapMD),
                const SectionLabel(text: 'COMPATIBLE UNITS'),
                for (final unit in compatibleUnits)
                  _CompatibleUnitRow(
                    label: unit,
                    isSelected: unit == draft.doseUnit,
                    isDefault: unit == defaultUnit,
                    onTap: () {
                      ref.read(appPrdAnalyticsBridgeProvider).addMedUnitSelected(
                            unit,
                            wasDefault: unit == defaultUnit,
                          );
                      ref
                          .read(addMedicineDraftNotifierProvider.notifier)
                          .applyDoseUnit(unit);
                      Navigator.pop(context);
                    },
                  ),
                SizedBox(height: AppDimensions.gapMD),
                OutlinedButton.icon(
                  onPressed: () async {
                    final custom = await showDialog<String>(
                      context: context,
                      builder: (ctx) {
                        final controller = TextEditingController();
                        return AlertDialog(
                          title: const Text('Custom unit'),
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'e.g., half tablet',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(ctx, controller.text.trim()),
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                    if (custom != null && custom.isNotEmpty) {
                      ref
                          .read(appPrdAnalyticsBridgeProvider)
                          .addMedUnitCustomEntered(custom.length);
                      ref
                          .read(addMedicineDraftNotifierProvider.notifier)
                          .applyDoseUnit(custom);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusButton),
                    ),
                  ),
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: AppColors.primaryBlue,
                  ),
                  label: Text(
                    'Custom unit...',
                    style: AppTextStyles.cardTitle.copyWith(
                      fontSize: 14,
                      color: AppColors.primaryBlue,
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

class _CompatibleUnitRow extends StatelessWidget {
  const _CompatibleUnitRow({
    required this.label,
    required this.isSelected,
    required this.isDefault,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDefault;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: AppDimensions.gapSM),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingCardInner,
            vertical: AppDimensions.gapMD,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryBlueTint,
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(label, style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
              ),
              Icon(Icons.check, size: 16, color: AppColors.primaryBlue),
              if (isDefault) ...[
                SizedBox(width: AppDimensions.gapSM / 2),
                Text(
                  'Default',
                  style: AppTextStyles.cardSubtitle.copyWith(
                    fontSize: 12,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.gapMD),
        child: Text(label, style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
      ),
    );
  }
}
