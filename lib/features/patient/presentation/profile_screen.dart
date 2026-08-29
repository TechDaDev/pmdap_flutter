import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/config/app_config.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/patient.dart';
import '../../../core/utils/presentation.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/patient_avatar.dart';
import '../../auth/application/session_controller.dart';
import '../../medical_context/application/patient_context_controller.dart';
import '../../patient/application/patient_providers.dart';

/// Patient profile — display of safe public/account fields plus the private
/// authenticated avatar. Avatar editing is independent of identity verification.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => _confirmLogout(context),
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
                    if (ref.watch(patientContextProvider).isMinor) ...[
                      _ChildContextNotice(l10n: l10n),
                      const SizedBox(height: 16),
                    ],
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        if (_busy)
                          Opacity(
                            opacity: 0.55,
                            child: PatientAvatar(
                              fullName: profile.fullName,
                              avatarUrl: profile.avatarUrl,
                              radius: 44,
                              semanticLabel: l10n.profilePhoto,
                            ),
                          )
                        else
                          PatientAvatar(
                            fullName: profile.fullName,
                            avatarUrl: profile.avatarUrl,
                            radius: 44,
                            semanticLabel: l10n.profilePhoto,
                            onTap: () => _showAvatarSheet(profile),
                          ),
                        if (_busy)
                          const Positioned.fill(
                            child: Center(
                              child: SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: () => _showAvatarSheet(profile),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.surface,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.photo_camera_outlined,
                                size: 18,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                      ],
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
                            value: profile.nationality.trim().isEmpty
                                ? l10n.notProvided
                                : countryName(profile.nationality, l10n),
                          ),
                          if (user != null)
                            _InfoRow(
                              label: l10n.email,
                              value: user.email,
                              forceLtr: true,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        onTap: () => context.push(Routes.minors),
                        leading: const Icon(Icons.family_restroom_outlined),
                        title: Text(l10n.myChildrenTitle),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        onTap: () => context.push(Routes.passwordChange),
                        leading: const Icon(Icons.security_outlined),
                        title: Text(l10n.securityTitle),
                        subtitle: Text(l10n.changePassword),
                        trailing: const Icon(Icons.chevron_right_rounded),
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

  Future<void> _showAvatarSheet(PatientProfile profile) async {
    final l10n = AppLocalizations.of(context);
    final hasAvatar = profile.avatarUrl != null;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: Text(l10n.profilePhoto),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.changePhoto),
              onTap: () => Navigator.pop(context, 'change'),
            ),
            if (hasAvatar)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.removePhoto),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
            ListTile(
              leading: const Icon(Icons.close),
              title: Text(l10n.cancel),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (action == 'change') {
      await _pickAndUpload();
    } else if (action == 'remove') {
      await _confirmRemove();
    }
  }

  Future<void> _pickAndUpload() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final XFile? file;
    try {
      file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.unableToUpdatePhoto)));
      return;
    }
    if (file == null || !mounted) return;

    // Offer normal images only (JPEG/PNG). Never accept PDFs here.
    final lower = file.path.toLowerCase();
    final supported =
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
    if (!supported) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.unsupportedImageFormat)),
      );
      return;
    }

    setState(() => _busy = true);
    try {
      await ref
          .read(patientApiProvider)
          .updateAvatar(filePath: file.path, filename: file.name);
      ref.invalidate(patientProfileProvider);
      ref.invalidate(patientAvatarProvider);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.photoUpdated)));
    } on ApiException {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.unableToUpdatePhoto)));
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.unableToUpdatePhoto)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmRemove() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removePhotoConfirm),
        content: Text(l10n.removePhotoExplain),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.removePhoto),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref.read(patientApiProvider).removeAvatar();
      ref.invalidate(patientProfileProvider);
      ref.invalidate(patientAvatarProvider);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.photoRemoved)));
    } on ApiException {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.unableToUpdatePhoto)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final scheme = Theme.of(context).colorScheme;
    var busy = false;
    // Result: 'ok' = logged out, 'fail' = logout errored, false = cancelled.
    final result = await showDialog<Object>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          icon: Icon(Icons.logout, color: scheme.error),
          title: Text(l10n.logout, textAlign: TextAlign.center),
          content: Text(l10n.logoutConfirm, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          actions: [
            TextButton(
              onPressed: busy
                  ? null
                  : () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: scheme.error,
                foregroundColor: scheme.onError,
              ),
              onPressed: busy
                  ? null
                  : () async {
                      setDialogState(() => busy = true);
                      final ok = await _runLogout();
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext, ok ? 'ok' : 'fail');
                      }
                    },
              child: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.logout),
            ),
          ],
        ),
      ),
    );
    if (result == 'ok') {
      if (context.mounted) context.go(Routes.login);
    } else if (result == 'fail' && context.mounted) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    }
  }

  /// Best-effort backend logout then local session clear. Returns true on
  /// success; keeps the user signed in on failure.
  Future<bool> _runLogout() async {
    try {
      await ref.read(sessionControllerProvider.notifier).logout();
      return true;
    } catch (_) {
      return false;
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
            child: Text(value, textAlign: TextAlign.end, softWrap: true),
          )
        : Text(value, textAlign: TextAlign.end, softWrap: true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: valueText),
        ],
      ),
    );
  }
}

/// Notice shown on the guardian's Profile while child context is active:
/// authentication/account settings belong to the guardian, not the child.
class _ChildContextNotice extends ConsumerWidget {
  const _ChildContextNotice({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childName = ref.watch(patientContextProvider).safeDisplayName ?? '';
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.family_restroom_rounded,
              color: scheme.onSecondaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.profileChildContextNotice(childName),
                style: TextStyle(color: scheme.onSecondaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
