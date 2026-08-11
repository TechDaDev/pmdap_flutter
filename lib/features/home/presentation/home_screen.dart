import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/models/patient.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/patient_avatar.dart';
import '../../../core/widgets/section_header.dart';
import '../../archive/application/archive_providers.dart';
import '../../archive/data/archive_api.dart';
import '../../documents/application/documents_providers.dart';
import '../../documents/presentation/medical_document_card.dart';
import '../../patient/application/patient_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(patientProfileProvider);
    final summaryAsync = ref.watch(
      archiveSummaryProvider(const ArchiveScope.adult()),
    );
    final docsAsync = ref.watch(documentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appFullName),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.lg),
            child: PatientAvatar(
              fullName: profileAsync.valueOrNull?.fullName ?? '',
              avatarUrl: profileAsync.valueOrNull?.avatarUrl,
              radius: 18,
              onTap: () => context.push(Routes.profile),
              semanticLabel: l10n.profile,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryNavy,
        onRefresh: () async {
          ref.invalidate(patientProfileProvider);
          ref.invalidate(archiveSummaryProvider(const ArchiveScope.adult()));
          ref.invalidate(documentsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageH,
            AppSpacing.pageH,
            AppSpacing.pageH,
            AppSpacing.xxxl,
          ),
          children: [
            AsyncStateView(
              value: profileAsync,
              builder: (profile) => _Greeting(profile: profile, l10n: l10n),
            ),
            const SizedBox(height: AppSpacing.xl),
            AsyncStateView(
              value: profileAsync,
              builder: (profile) =>
                  _DigitalIdCard(profile: profile, l10n: l10n),
            ),
            const SizedBox(height: AppSpacing.md),
            AsyncStateView(
              value: profileAsync,
              builder: (profile) => _IdentityCard(profile: profile, l10n: l10n),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _ShortcutGrid(
              l10n: l10n,
              unconfirmedCount:
                  summaryAsync.valueOrNull?.unconfirmedDateCount ?? 0,
            ),
            const SizedBox(height: AppSpacing.xxl),
            SectionHeader(
              title: l10n.recentDocuments,
              actionLabel: l10n.viewAll,
              onAction: () => context.push(Routes.documents),
            ),
            AsyncStateView(
              value: docsAsync,
              builder: (page) {
                final docs = page.results.take(5).toList();
                if (docs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageH,
                    ),
                    child: Text(
                      l10n.noDocuments,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final doc in docs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: MedicalDocumentCard(
                          document: doc,
                          onTap: () =>
                              context.push(Routes.documentDetail(doc.uuid)),
                        ),
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
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.profile, required this.l10n});

  final PatientProfile profile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final firstName = profile.fullName.split(' ').first;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Separate spans keep mixed-script greetings (e.g. English "Hello,"
        // + Arabic patient name) bidi-stable without translating the name.
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: l10n.hello,
                style: TextStyle(color: scheme.onSurface),
              ),
              TextSpan(
                text: ' $firstName',
                style: TextStyle(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.medicalRecordOverview,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _DigitalIdCard extends StatelessWidget {
  const _DigitalIdCard({required this.profile, required this.l10n});

  final PatientProfile profile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.largeCard),
        gradient: const LinearGradient(
          colors: [AppColors.primaryNavy, AppColors.primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_rounded,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.patientDigitalId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Digital ID is an identifier — keep LTR even inside Arabic UI.
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              profile.digitalId,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            profile.fullName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.permanentIdentifier,
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.profile, required this.l10n});

  final PatientProfile profile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final labels = StatusLabels(l10n);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    color: AppColors.primaryNavy,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.identityVerification,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Scale the badge instead of overflowing the card width.
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: labels.identity(profile.identityStatus),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => context.push(Routes.identity),
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Text(
                  l10n.manageIdentity,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutGrid extends StatelessWidget {
  const _ShortcutGrid({required this.l10n, required this.unconfirmedCount});

  final AppLocalizations l10n;
  final int unconfirmedCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text(
            l10n.documentsAndActions,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.5,
          children: [
            _Shortcut(
              icon: Icons.upload_file_rounded,
              label: l10n.uploadDocumentShortcut,
              color: AppColors.brandTeal,
              onTap: () => context.push(Routes.documentsNew),
            ),
            _Shortcut(
              icon: Icons.fact_check_outlined,
              label: l10n.needsConfirmationShortcut,
              color: AppColors.warning,
              count: unconfirmedCount,
              onTap: () => context.push(
                Routes.archive,
                // Pre-filter to documents needing date confirmation.
                extra: const ArchiveQuery(dateStatus: 'UNCONFIRMED'),
              ),
            ),
            _Shortcut(
              icon: Icons.family_restroom_rounded,
              label: l10n.myChildrenShortcut,
              color: AppColors.brandCyan,
              onTap: () => context.push(Routes.minors),
            ),
            _Shortcut(
              icon: Icons.badge_outlined,
              label: l10n.identityShortcut,
              color: AppColors.primaryBlue,
              onTap: () => context.push(Routes.identity),
            ),
          ],
        ),
      ],
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.count,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 19),
              ),
              const SizedBox(height: 4),
              // Scale down instead of splitting a word mid-character.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (count != null && count! > 0) ...[
                const SizedBox(height: 2),
                Text(
                  '$count',
                  style: TextStyle(fontSize: 12, color: AppColors.warning),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
