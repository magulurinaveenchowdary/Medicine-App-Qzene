import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/MedicineAutocompleteSearchConstants.dart';
import 'package:med_reminder/core/providers/AppBootstrapInitializationProvider.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddFlowPageScaffoldWidget.dart';
import 'package:med_reminder/core/widgets/common/FormSectionCardWidget.dart';
import 'package:med_reminder/core/widgets/common/PrimaryActionButtonWidget.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/MedicineNameAutocompleteListWidget.dart';
import 'package:med_reminder/core/widgets/AddMedicineFlowWidgets/AddMedicineFlowStepHeadingWidget.dart';
import 'package:med_reminder/features/medicines/application/AddMedicineDraftNotifier.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';

class AddMedicineNameScreen extends ConsumerStatefulWidget {
  const AddMedicineNameScreen({super.key});
  @override
  ConsumerState<AddMedicineNameScreen> createState() =>
      _AddMedicineNameScreenState();
}

class _AddMedicineNameScreenState extends ConsumerState<AddMedicineNameScreen> {
  final nameController = TextEditingController();
  final nameFocusNode = FocusNode();
  List<MedicineCatalogSuggestionModel> _suggestions = const [];
  Timer? _searchDebounce;
  int _searchGeneration = 0;
  bool _catalogReady = false;
  String? _committedName;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(addMedicineDraftNotifierProvider);
    if (draft.displayName.isNotEmpty) {
      nameController.text = draft.displayName;
      _committedName = draft.displayName;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(appPrdAnalyticsBridgeProvider).addMedNameScreenView();
      await ref.read(medicineCatalogSearchServiceProvider).ensureLoaded();
      if (!mounted) return;
      setState(() => _catalogReady = true);
      if (_committedName == null) _scheduleSearch();
    });
    nameController.addListener(_onQueryChanged);
  }

  void _onQueryChanged() {
    if (_committedName != null && nameController.text != _committedName) {
      _committedName = null;
    }
    setState(() {});
    if (_committedName == null) {
      _scheduleSearch();
    }
  }

  void _scheduleSearch() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(
        milliseconds: MedicineAutocompleteSearchConstants.searchDebounceMs,
      ),
      _runSearch,
    );
  }

  List<String> _profileCustomDisplayNames() {
    final profileId = ref.read(activeUserProfileIdProvider);
    final snapshot = ref.read(medicineAppDataNotifierProvider).valueOrNull;
    if (snapshot == null) return const [];
    return snapshot.medicines
        .where((m) => m.profileId == profileId && m.isCustomMedicine)
        .map((m) => m.displayName)
        .toSet()
        .toList();
  }

  Future<void> _runSearch() async {
    final query = nameController.text;
    final generation = ++_searchGeneration;

    if (query.trim().length < MedicineAutocompleteSearchConstants.minQueryLength) {
      if (mounted && generation == _searchGeneration) {
        setState(() => _suggestions = const []);
      }
      return;
    }

    if (!_catalogReady) return;

    final catalog = ref.read(medicineCatalogSearchServiceProvider);
    final customNames = _profileCustomDisplayNames();

    await Future<void>.delayed(Duration.zero);
    if (!mounted || generation != _searchGeneration) return;

    final results = catalog.searchSuggestions(
      query,
      profileCustomDisplayNames: customNames,
    );

    if (!mounted ||
        generation != _searchGeneration ||
        _committedName != null) {
      return;
    }

    setState(() => _suggestions = results);

    ref.read(appPrdAnalyticsBridgeProvider).addMedSearchResults(
          queryLength: query.trim().length,
          resultCount: results.length,
          hasFuzzyMatch: results.isNotEmpty,
        );
  }

  bool _hasExactMatch(String query) {
    final lower = query.toLowerCase();
    return _suggestions.any((s) => s.displayName.toLowerCase() == lower);
  }

  void _selectSuggestion(MedicineCatalogSuggestionModel suggestion) {
    ref.read(appPrdAnalyticsBridgeProvider).addMedSuggestionSelected(
          source: suggestion.isProfileCustom ? 'profile_custom' : 'db',
          queryLength: nameController.text.trim().length,
        );
    if (suggestion.isProfileCustom) {
      ref
          .read(addMedicineDraftNotifierProvider.notifier)
          .applyCustomMedicineName(suggestion.displayName);
    } else {
      ref
          .read(addMedicineDraftNotifierProvider.notifier)
          .applyCatalogSuggestion(suggestion);
    }
    _searchDebounce?.cancel();
    _searchGeneration++;
    nameController.text = suggestion.displayName;
    _committedName = suggestion.displayName;
    _suggestions = const [];
    nameFocusNode.unfocus();
    setState(() {});
  }

  void _addCustom() {
    final query = nameController.text.trim();
    if (query.isEmpty) return;
    ref.read(appPrdAnalyticsBridgeProvider).addMedCustomAdded(query.length);
    ref.read(addMedicineDraftNotifierProvider.notifier).applyCustomMedicineName(query);
    _searchDebounce?.cancel();
    _searchGeneration++;
    _committedName = query;
    _suggestions = const [];
    nameFocusNode.unfocus();
    setState(() {});
  }

  void _continueToCategory() {
    final query = nameController.text.trim();
    if (query.isEmpty) return;

    final exact = _suggestions.where(
      (s) => s.displayName.toLowerCase() == query.toLowerCase(),
    );
    if (exact.isNotEmpty) {
      _selectSuggestion(exact.first);
    } else {
      ref.read(appPrdAnalyticsBridgeProvider).addMedCustomAdded(query.length);
      ref
          .read(addMedicineDraftNotifierProvider.notifier)
          .applyCustomMedicineName(query);
    }
    context.push('/add-medicine/category');
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    nameController.removeListener(_onQueryChanged);
    nameController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = nameController.text.trim();
    final showSuggestions = _committedName == null &&
        query.length >= MedicineAutocompleteSearchConstants.minQueryLength;
    final suggestionRows = _suggestions
        .map(
          (s) => MedicineNameSuggestionData(
            name: s.displayName,
            ingredientLine: s.ingredientLine,
          ),
        )
        .toList();
    final canContinue = query.isNotEmpty;
    final showCustomAdd =
        showSuggestions && query.isNotEmpty && !_hasExactMatch(query);

    return AddFlowPageScaffold(
      headerTitle: 'Add Medicine',
      stepLabel: '1 / 7',
      showBannerAd: true,
      bottomButton: IgnorePointer(
        ignoring: !canContinue,
        child: Opacity(
          opacity: canContinue ? 1 : 0.4,
          child: PrimaryActionButton(
            label: 'Continue',
            onPressed: _continueToCategory,
          ),
        ),
      ),
      children: [
        const AddMedicineFlowStepHeadingWidget(
          title: "What's the name?",
          subtitle: 'Start typing — pick from suggestions.',
        ),
        FormSectionCard(
          marginBottom: AppDimensions.gapSM,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingCardInner,
            vertical: AppDimensions.gapMD,
          ),
          child: CupertinoTextField(
            controller: nameController,
            focusNode: nameFocusNode,
            placeholder: 'Enter your medicine name',
            decoration: const BoxDecoration(),
            style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
            padding: EdgeInsets.zero,
            cursorColor: AppColors.primaryBlue,
            textInputAction: TextInputAction.done,
            onSubmitted: canContinue ? (_) => _continueToCategory() : null,
          ),
        ),
        if (showSuggestions)
          MedicineNameAutocompleteListWidget(
            suggestions: suggestionRows,
            customQuery: showCustomAdd ? query : null,
            onSuggestionTap: (row) {
              final match = _suggestions.firstWhere(
                (s) => s.displayName == row.name,
                orElse: () => MedicineCatalogSuggestionModel(
                  catalogEntryRaw: row.name,
                  displayName: row.name,
                  ingredientLine: row.ingredientLine,
                ),
              );
              _selectSuggestion(match);
            },
            onCustomAddTap: _addCustom,
          ),
      ],
    );
  }
}
