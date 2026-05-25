import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/constants/AppShadowDesignTokens.dart';
import 'package:med_reminder/core/constants/AppSpacingLayoutTokens.dart';
import 'package:med_reminder/core/scheduling/MedicineScheduleFireCalculator.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/TabScreenScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/MedicinePillIconWidget.dart';
import 'package:med_reminder/core/widgets/common/SectionHeaderWidget.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsFunnelHelpers.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

class MedicinesListScreen extends ConsumerStatefulWidget {
  const MedicinesListScreen({super.key});
  @override
  ConsumerState<MedicinesListScreen> createState() =>
      _MedicinesListScreenState();
}

class _MedicinesListScreenState extends ConsumerState<MedicinesListScreen> {
  final _loggedSections = <String>{};
  final _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logSectionOnce(String section) {
    if (_loggedSections.contains(section)) return;
    _loggedSections.add(section);
    ref.read(appPrdAnalyticsBridgeProvider).medlistSectionExpanded(section);
  }

  Widget _wrapMedicinesTabScaffold({required Widget child}) {
    return Scaffold(backgroundColor: AppColors.backgroundGrey, body: child);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dataAsync = ref.watch(medicineAppDataNotifierProvider);

    return dataAsync.when(
      loading: () => _wrapMedicinesTabScaffold(
        child: const TabScreenScaffold(
          header: SizedBox.shrink(),
          showFab: false,
          body: Center(child: CupertinoActivityIndicator()),
        ),
      ),
      error: (e, _) => _wrapMedicinesTabScaffold(
        child: TabScreenScaffold(
          header: const SizedBox.shrink(),
          showFab: false,
          body: Center(child: Text('Error: $e')),
        ),
      ),
      data: (_) {
        final notifier = ref.read(medicineAppDataNotifierProvider.notifier);
        final allMedicines = notifier.allMedicinesForActiveProfile();
        final activeMedicines = allMedicines.where((m) => !m.isPaused).toList();
        final filteredMedicines = _searchQuery.isEmpty
            ? activeMedicines
            : activeMedicines
                .where((m) => m.displayName.toLowerCase().contains(_searchQuery.toLowerCase()))
                .toList();
        final scheduled = filteredMedicines.where((m) => !m.isOnDemand).toList();
        final onDemand = filteredMedicines.where((m) => m.isOnDemand).toList();
        final paused = _searchQuery.isEmpty
            ? allMedicines.where((m) => m.isPaused).toList()
            : <MedicineStoredRecordModel>[];

        return _wrapMedicinesTabScaffold(
          child: TabScreenScaffold(
            showFab: true,
            onFabPressed: () {
              startAddMedicineFunnelAnalytics(ref, 'medlist');
              ref.read(addMedicineDraftNotifierProvider.notifier).resetDraft();
              context.push('/add-medicine/name');
            },
            header: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              decoration: const BoxDecoration(
                color: AppColorsDesignTokens.backgroundPrimary,
                border: Border(
                  bottom: BorderSide(color: AppColorsDesignTokens.divider),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _isSearching
                        ? CupertinoSearchTextField(
                            controller: _searchController,
                            placeholder: 'Search medicines',
                            onChanged: (value) => setState(() {
                              _searchQuery = value.trim();
                            }),
                            onSubmitted: (value) => setState(() {
                              _searchQuery = value.trim();
                            }),
                          )
                        : Text(
                            l10n.medicinesListTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColorsDesignTokens.textPrimary,
                            ),
                          ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () {
                      setState(() {
                        if (_isSearching) {
                          _isSearching = false;
                          _searchQuery = '';
                          _searchController.clear();
                        } else {
                          _isSearching = true;
                        }
                      });
                    },
                    child: Icon(
                      _isSearching ? CupertinoIcons.clear : CupertinoIcons.search,
                      color: AppColorsDesignTokens.textPrimary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            body: allMedicines.isEmpty
                ? Center(
                    child: Text(
                      l10n.addFirstMedicineBody,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColorsDesignTokens.textSecondary,
                      ),
                    ),
                  )
                : _isSearching && filteredMedicines.isEmpty
                    ? const Center(
                        child: Text(
                          'No matching medicines',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColorsDesignTokens.textSecondary,
                          ),
                        ),
                      )
                    : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacingLayoutTokens.phoneContentPadding,
                      10,
                      AppSpacingLayoutTokens.phoneContentPadding,
                      0,
                    ),
                    children: [
                      if (scheduled.isNotEmpty) ...[
                        Builder(
                          builder: (_) {
                            _logSectionOnce('scheduled');
                            return SectionHeaderWidget(
                              label: l10n.scheduledSection(scheduled.length),
                            );
                          },
                        ),
                        SizedBox(height: AppDimensions.gapMD),
                        for (final m in scheduled)
                          _MedicineListRow(
                            title: m.displayName,
                            sub:
                                '${MedicineScheduleFireCalculator.buildDoseDescription(amount: m.doseAmount, unit: m.doseUnit)} · ${MedicineScheduleFireCalculator.buildScheduleSummary(m)}',
                            onTap: () {
                              ref
                                  .read(appPrdAnalyticsBridgeProvider)
                                  .medlistMedicineTapped(
                                    medicineId: m.medicineId,
                                    section: 'scheduled',
                                  );
                              context.push(
                                '/main/medicines/detail/${m.medicineId}',
                              );
                            },
                          ),
                      ],
                      if (onDemand.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Builder(
                          builder: (_) {
                            _logSectionOnce('on_demand');
                            return SectionHeaderWidget(
                              label: l10n.onDemandSection(onDemand.length),
                            );
                          },
                        ),
                        for (final m in onDemand)
                          _MedicineListRow(
                            title: m.displayName,
                            sub: 'As needed',
                            onTap: () {
                              ref
                                  .read(appPrdAnalyticsBridgeProvider)
                                  .medlistMedicineTapped(
                                    medicineId: m.medicineId,
                                    section: 'on_demand',
                                  );
                              context.push(
                                '/main/medicines/detail/${m.medicineId}',
                              );
                            },
                          ),
                      ],
                      if (paused.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Builder(
                          builder: (_) {
                            _logSectionOnce('paused');
                            return SectionHeaderWidget(
                              label: 'Paused (${paused.length})',
                            );
                          },
                        ),
                        for (final m in paused)
                          _MedicineListRow(
                            title: m.displayName,
                            sub: 'Paused',
                            onTap: () {
                              ref
                                  .read(appPrdAnalyticsBridgeProvider)
                                  .medlistMedicineTapped(
                                    medicineId: m.medicineId,
                                    section: 'paused',
                                  );
                              context.push(
                                '/main/medicines/detail/${m.medicineId}',
                              );
                            },
                          ),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _MedicineListRow extends StatelessWidget {
  const _MedicineListRow({
    required this.title,
    required this.sub,
    required this.onTap,
  });

  final String title;
  final String sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.gapMD),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingCardInner),
          decoration: BoxDecoration(
            color: AppColorsDesignTokens.backgroundPrimary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            boxShadow: AppShadowDesignTokens.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: AppDimensions.medIconSize,
                height: AppDimensions.medIconSize,
                decoration: BoxDecoration(
                  color: AppColorsDesignTokens.colorPrimaryTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const MedicinePillIconWidget(
                  size: 20,
                  primaryColor: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                    ),
                    Text(
                      sub,
                      style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_forward,
                size: 16,
                color: AppColorsDesignTokens.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
