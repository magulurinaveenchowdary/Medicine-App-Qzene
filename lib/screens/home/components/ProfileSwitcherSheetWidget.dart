import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reminder/core/constants/AppColorsDesignTokens.dart';
import 'package:med_reminder/features/medicines/application/MedicineAppDataNotifier.dart';
import 'package:med_reminder/features/medicines/domain/MedicineReminderDataModels.dart';

class ProfileSwitcherSheetWidget extends ConsumerWidget {
  const ProfileSwitcherSheetWidget({super.key});

  static Future<void> show(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => const ProfileSwitcherSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(medicineAppDataNotifierProvider).valueOrNull;
    final activeId = ref.watch(activeUserProfileIdProvider);
    final profiles = snapshot?.profiles ?? const <UserProfileRecordModel>[];

    return Material(
      color: AppColorsDesignTokens.backgroundPrimary,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Switch profile',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            for (final profile in profiles)
              ListTile(
                leading: CircleAvatar(
                  child: Text(profile.avatarLetter ?? profile.displayName.characters.first),
                ),
                title: Text(profile.displayName),
                subtitle: Text(
                  '${ref.read(medicineAppDataNotifierProvider.notifier).medicineCountForProfile(profile.profileId)} medicines',
                ),
                trailing: profile.profileId == activeId
                    ? const Icon(CupertinoIcons.checkmark, color: AppColorsDesignTokens.colorPrimary)
                    : null,
                onTap: () async {
                  await ref
                      .read(medicineAppDataNotifierProvider.notifier)
                      .switchActiveProfile(profile.profileId);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            if (profiles.length < 3)
              ListTile(
                leading: const Icon(CupertinoIcons.add_circled),
                title: const Text('Add profile'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/main/settings/profiles');
                },
              ),
            ListTile(
              leading: const Icon(CupertinoIcons.gear),
              title: const Text('Manage profiles'),
              onTap: () {
                Navigator.pop(context);
                context.push('/main/settings/profiles');
              },
            ),
          ],
        ),
      ),
    );
  }
}
