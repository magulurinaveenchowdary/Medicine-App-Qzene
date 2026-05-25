import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/analytics/AppAnalyticsMappingHelpers.dart';
import 'package:med_reminder/core/analytics/AppPrdAnalyticsBridge.dart';
import 'package:med_reminder/core/theme/app_colors.dart';
import 'package:med_reminder/core/theme/app_dimensions.dart';
import 'package:med_reminder/core/theme/app_text_styles.dart';
import 'package:med_reminder/core/widgets/common/AdBannerWidget.dart';
import 'package:med_reminder/core/widgets/common/AppCardWidget.dart';
import 'package:med_reminder/core/widgets/common/AddFlowHeaderWidget.dart';
import 'package:med_reminder/core/widgets/common/StatusBadgeWidget.dart';
import 'package:med_reminder/core/widgets/common/DashedBorderBoxWidget.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';
import 'package:med_reminder/l10n/app_localizations.dart';

class ProfilesScreen extends ConsumerStatefulWidget {
  const ProfilesScreen({super.key});
  @override
  ConsumerState<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends ConsumerState<ProfilesScreen> {
  Future<void> _addProfile() async {
    final controller = TextEditingController();
    final name = await showCupertinoDialog<String>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('New profile'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(controller: controller, placeholder: 'Name'),
        ),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          CupertinoDialogAction(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: const Text('Add')),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    final created = await ref.read(medicineAppDataNotifierProvider.notifier).addProfile(name);
    if (created != null && mounted) {
      await ref.read(medicineAppDataNotifierProvider.notifier).switchActiveProfile(created.profileId);
    }
  }

  Future<void> _renameProfile(UserProfileRecordModel profile) async {
    final controller = TextEditingController(text: profile.displayName);
    final newName = await showCupertinoDialog<String>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Rename profile'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(controller: controller),
        ),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          CupertinoDialogAction(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    controller.dispose();
    if (newName == null || newName.isEmpty || newName == profile.displayName) return;
    await ref.read(medicineAppDataNotifierProvider.notifier).upsertProfile(
          profile.copyWith(displayName: newName, avatarLetter: newName.characters.first.toUpperCase()),
        );
    await ref.read(appPrdAnalyticsBridgeProvider).profileRenamed(
          AppAnalyticsMappingHelpers.hashProfileIdForAnalytics(profile.profileId),
        );
    await ref.read(appPrdAnalyticsBridgeProvider).profileEdited(
          AppAnalyticsMappingHelpers.hashProfileIdForAnalytics(profile.profileId),
          ['name'],
        );
  }

  Future<void> _deleteProfile(UserProfileRecordModel profile, int medicineCount) async {
    final snapshot = ref.read(medicineAppDataNotifierProvider).valueOrNull;
    final hadHistory = snapshot?.doseOccurrences.any((o) => o.profileId == profile.profileId) ?? false;
    final confirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete profile?'),
        content: const Text('Medicines and history for this profile will be removed.'),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await ref.read(medicineAppDataNotifierProvider.notifier).deleteProfile(profile.profileId);
    await ref.read(appPrdAnalyticsBridgeProvider).profileDeleted(
          hadMedicines: medicineCount > 0,
          hadHistory: hadHistory,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = ref.watch(medicineAppDataNotifierProvider);
    final activeId = ref.watch(activeUserProfileIdProvider);

    return Material(
      color: AppColors.backgroundGrey,
      child: SafeArea(
        child: Column(
          children: [
            AddFlowHeader(title: l10n.profilesTitle, onBack: () => context.pop()),
            Expanded(
              child: data.when(
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (snapshot) {
                  final notifier = ref.read(medicineAppDataNotifierProvider.notifier);
                  return Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingScreenH),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Up to 3 profiles per device.', style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12)),
                        const SizedBox(height: AppDimensions.gapSM),
                        for (final profile in snapshot.profiles)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppDimensions.gapMD),
                            child: AppCard(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(child: Text(profile.avatarLetter ?? profile.displayName.characters.first)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(profile.displayName, style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                                            Text(
                                              '${notifier.medicineCountForProfile(profile.profileId)} medicines',
                                              style: AppTextStyles.cardSubtitle.copyWith(fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (profile.profileId == activeId)
                                        const StatusBadge(label: 'Active', kind: MedicineStatusBadgeKind.active)
                                      else
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () => notifier.switchActiveProfile(profile.profileId),
                                          child: const Text('Switch'),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => _renameProfile(profile),
                                        child: const Text('Rename'),
                                      ),
                                      if (snapshot.profiles.length > 1)
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () => _deleteProfile(
                                            profile,
                                            notifier.medicineCountForProfile(profile.profileId),
                                          ),
                                          child: const Text('Delete', style: TextStyle(color: AppColors.errorRed)),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (snapshot.profiles.length < 3)
                          GestureDetector(
                            onTap: _addProfile,
                            child: DashedBorderBoxWidget(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                child: Column(
                                  children: [
                                    Text('+ Add a profile', style: AppTextStyles.cardTitle.copyWith(fontSize: 14, color: AppColors.primaryBlue)),
                                    Text('${3 - snapshot.profiles.length} slot(s) left', style: AppTextStyles.cardSubtitle.copyWith(fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        const Spacer(),
                        const AdBanner(placement: 'profiles'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
