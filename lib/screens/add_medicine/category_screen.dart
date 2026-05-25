import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/CategoryFormGridData.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddFlowPageScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/PrimaryActionButtonWidget.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/CategoryFormTileWidget.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddMedicineFlowStepHeadingWidget.dart';
import 'package:med_reminder/core/analytics/AppAnalyticsMappingHelpers.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';

class AddMedicineCategoryScreen extends ConsumerStatefulWidget {
  const AddMedicineCategoryScreen({super.key});
  @override
  ConsumerState<AddMedicineCategoryScreen> createState() =>
      _AddMedicineCategoryScreenState();
}

class _AddMedicineCategoryScreenState extends ConsumerState<AddMedicineCategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appPrdAnalyticsBridgeProvider).addMedCategoryView();
    });
  }

  void _continueToDose() {
    context.push('/add-medicine/dose');
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabel = ref.watch(
      addMedicineDraftNotifierProvider.select((d) => d.categoryFormLabel),
    );

    return AddFlowPageScaffold(
      headerTitle: 'Category',
      stepLabel: '2 / 7',
      showBannerAd: false,
      bottomButton: PrimaryActionButton(
        label: 'Continue',
        onPressed: _continueToDose,
      ),
      children: [
        const AddMedicineFlowStepHeadingWidget(
          title: 'What form is it?',
          bottomSpacing: AppDimensions.gapMD,
        ),
        // 2-column grid for the first 8 items (horizontal layout)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppDimensions.gapSM,
            crossAxisSpacing: AppDimensions.gapSM,
            childAspectRatio: 2.8,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            final item = CategoryFormGridData.gridItems[index];
            return CategoryFormTileWidget(
              itemData: item,
              isSelected: item.label == selectedLabel,
              isHorizontal: true,
              onTap: () {
                ref.read(appPrdAnalyticsBridgeProvider).addMedCategorySelected(
                      AppAnalyticsMappingHelpers.categorySlug(item.label),
                    );
                ref
                    .read(addMedicineDraftNotifierProvider.notifier)
                    .applyCategoryForm(item.label);
              },
            );
          },
        ),
        const SizedBox(height: AppDimensions.gapSM),
        // 4-column grid for the remaining 18 items (vertical layout)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: AppDimensions.gapSM,
            crossAxisSpacing: AppDimensions.gapSM,
            childAspectRatio: 0.85,
          ),
          itemCount: CategoryFormGridData.gridItems.length - 8,
          itemBuilder: (context, index) {
            final item = CategoryFormGridData.gridItems[index + 8];
            return CategoryFormTileWidget(
              itemData: item,
              isSelected: item.label == selectedLabel,
              isHorizontal: false,
              onTap: () {
                ref.read(appPrdAnalyticsBridgeProvider).addMedCategorySelected(
                      AppAnalyticsMappingHelpers.categorySlug(item.label),
                    );
                ref
                    .read(addMedicineDraftNotifierProvider.notifier)
                    .applyCategoryForm(item.label);
              },
            );
          },
        ),
      ],
    );
  }
}
