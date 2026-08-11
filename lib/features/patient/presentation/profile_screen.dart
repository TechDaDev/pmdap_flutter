import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/config/app_config.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/presentation.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../auth/application/session_controller.dart';
import '../../patient/application/patient_providers.dart';

/// Patient profile — read-only display of safe public/account fields.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(patientProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          if (AppConfig.isDebug)
            IconButton(
              onPressed: () => context.push(Routes.devHealth),
              icon: const Icon(Icons.health_and_safety_outlined),
              tooltip: l10n.healthCheck,
            ),
          IconButton(
            onPressed: () => _confirmLogout(context, ref),
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(patientProfileProvider),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AsyncStateView(
              value: profileAsync,
              onRetry: () => ref.invalidate(patientProfileProvider),
              builder: (profile) {
                final labels = StatusLabels(l10n);
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(
                        patientInitials(profile.fullName),
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile.fullName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    labels.identity(profile.identityStatus),
                    const SizedBox(height: 24),
                    Card(
                      child: Column(
                        children: [
                          _InfoRow(
                            label: l10n.digitalId,
                            // Identifier — keep LTR inside Arabic UI.
                            value: profile.digitalId,
                            forceLtr: true,
                          ),
                          _InfoRow(
                            label: l10n.fullName,
                            value: profile.fullName,
                          ),
                          _InfoRow(
                            label: l10n.dateOfBirth,
                            value: _orNotProvided(
                              l10n,
                              localizedDate(l10n, profile.dateOfBirth),
                            ),
                          ),
                          _InfoRow(label: l10n.age, value: '${profile.age}'),
                          _InfoRow(
                            label: l10n.sex,
                            value: _sexLabel(l10n, profile.sex),
                          ),
                          _InfoRow(
                            label: l10n.bloodGroup,
                            value: _bloodLabel(profile.bloodGroup),
                          ),
                          _InfoRow(
                            label: l10n.nationality,
                            value: profile.nationality.isEmpty
                                ? l10n.notProvided
                                : profile.nationality,
                          ),
                          if (user != null)
                            _InfoRow(label: l10n.email, value: user.email),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        onTap: () => context.push(Routes.settings),
                        leading: const Icon(Icons.settings_outlined),
                        title: Text(l10n.appSettings),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => context.push(Routes.profileEdit),
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(l10n.editProfile),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(sessionControllerProvider.notifier).logout();
      if (!context.mounted) return;
      context.go(Routes.login);
    }
  }

  String _sexLabel(AppLocalizations l10n, Sex s) {
    switch (s) {
      case Sex.male:
        return l10n.male;
      case Sex.female:
        return l10n.female;
      case Sex.unspecified:
        return l10n.unspecified;
      case Sex.unknown:
        return l10n.unknownStatus;
    }
  }

  String _bloodLabel(BloodGroup b) => b == BloodGroup.unknown ? '—' : b.api;

  /// Empty display value (e.g. missing date) renders as "Not provided".
  String _orNotProvided(AppLocalizations l10n, String value) =>
      value.isEmpty ? l10n.notProvided : value;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.forceLtr = false,
  });

  final String label;
  final String value;
  final bool forceLtr;

  @override
  Widget build(BuildContext context) {
    final valueText = forceLtr
        ? Directionality(
            textDirection: TextDirection.ltr,
            child: Text(value, textAlign: TextAlign.end),
          )
        : Text(value, textAlign: TextAlign.end);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: valueText),
        ],
      ),
    );
  }
}
