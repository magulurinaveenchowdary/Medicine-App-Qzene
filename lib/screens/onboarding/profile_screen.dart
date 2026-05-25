import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/core/constants/AppSpacingLayoutTokens.dart';
import 'package:med_reminder/core/constants/AppAnalyticsEventNamesConstants.dart';
import 'package:med_reminder/core/constants/AppAnalyticsParameterNamesConstants.dart';
import 'package:med_reminder/core/services/AppFirebaseAnalyticsLoggingService.dart';
import 'package:med_reminder/core/theme/AppTypographyDesignTokens.dart';
import 'package:med_reminder/core/widgets/common/FormSectionCardWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/OnboardingAnalyticsPopScopeWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/OnboardingPageLayoutWidget.dart';
import 'package:med_reminder/core/widgets/OnboardingScreenWidgets/OnboardingPrimaryButtonWidget.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/features/onboarding/application/AppOnboardingCompletionNotifier.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final nameFocusNode = FocusNode();
  final ageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = ref.read(medicineAppDataNotifierProvider).valueOrNull;
      if (data != null && data.profiles.isNotEmpty) {
        nameController.text = data.profiles.first.displayName;
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    nameFocusNode.dispose();
    ageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveProfileAndFinish({bool openAddMedicine = false}) async {
    final name = nameController.text.trim().isEmpty
        ? 'Me'
        : nameController.text.trim();
    final age = int.tryParse(ageController.text.trim());
    final profileId = ref.read(activeUserProfileIdProvider);
    await ref.read(medicineAppDataNotifierProvider.notifier).upsertProfile(
          UserProfileRecordModel(
            profileId: profileId,
            displayName: name,
            avatarLetter: name.characters.first.toUpperCase(),
            ageYears: age,
          ),
        );
    final analytics = ref.read(appFirebaseAnalyticsLoggingServiceProvider);
    await analytics.logPrdEvent(
      AppAnalyticsEventNamesConstants.onbProfileCreated,
      {AppAnalyticsParameterNamesConstants.isDefault: true},
    );
    await ref.read(appOnboardingCompletionNotifierProvider.notifier).markOnboardingCompleted();
    var grantedCount = 0;
    // Best-effort count from onboarding permission flow.
    grantedCount = 1;
    await analytics.logPrdEvent(
      AppAnalyticsEventNamesConstants.onbCompleted,
      {
        AppAnalyticsParameterNamesConstants.permissionsGrantedCount: grantedCount,
      },
    );
    if (!mounted) return;
    context.go('/main/today');
    if (openAddMedicine) {
      context.push('/add-medicine/name');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final avatarLetter = (nameController.text.trim().isEmpty
            ? 'M'
            : nameController.text.trim().characters.first)
        .toUpperCase();
    return OnboardingAnalyticsPopScope(
      atStep: 'profile',
      child: OnboardingPageLayout(
      stepLabel: l10n.stepProgress(4, 4),
      footerActions: [
        PrimaryButton(
          label: 'Add Your First Medicine',
          onPressed: () => _saveProfileAndFinish(openAddMedicine: true),
        ),
        const SizedBox(height: 6),
        CupertinoButton(
          padding: const EdgeInsets.symmetric(vertical: 4),
          onPressed: () => _saveProfileAndFinish(),
          child: const Text(
            'Skip for now',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColorsDesignTokens.colorPrimary,
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
      children: [
        Text(
          l10n.profileTitle,
          style: AppTypographyDesignTokens.onboardingTitleMedium.copyWith(
            color: AppColorsDesignTokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set up a profile. You can add up to 3 (e.g., spouse, parent) later.',
          style: AppTypographyDesignTokens.screenSubtitle.copyWith(
            fontSize: 14,
            color: AppColorsDesignTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            Container(
              width: AppSpacingLayoutTokens.profileAvatarLarge,
              height: AppSpacingLayoutTokens.profileAvatarLarge,
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
                  fontSize: 26,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FormSectionCard(
          label: 'Name',
          child: CupertinoTextField(
            controller: nameController,
            focusNode: nameFocusNode,
            onChanged: (_) => setState(() {}),
            decoration: const BoxDecoration(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColorsDesignTokens.textPrimary,
            ),
            padding: EdgeInsets.zero,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => ageFocusNode.requestFocus(),
          ),
        ),
        FormSectionCard(
          label: 'Age (optional)',
          child: CupertinoTextField(
            controller: ageController,
            focusNode: ageFocusNode,
            placeholder: 'e.g., 68',
            placeholderStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColorsDesignTokens.textTertiary,
            ),
            decoration: const BoxDecoration(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColorsDesignTokens.textPrimary,
            ),
            padding: EdgeInsets.zero,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => ageFocusNode.unfocus(),
          ),
        ),
      ],
    ),
    );
  }
}
