import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/widgets/patient_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../archive/application/archive_providers.dart';
import '../../documents/application/documents_providers.dart';
import '../../documents/presentation/medical_document_card.dart';
import '../../patient/application/patient_providers.dart';

/// Home dashboard — real API data only. No fake analytics, no AI, no diagnosis.
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
      appBar: AppBar(title: Text(l10n.appName)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(patientProfileProvider);
          ref.invalidate(archiveSummaryProvider(const ArchiveScope.adult()));
          ref.invalidate(documentsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            AsyncStateView(
              value: profileAsync,
              builder: (profile) => PatientCard.fromProfile(profile: profile),
            ),
            const SizedBox(height: 8),
            _QuickActions(onTapIdentity: () => context.push(Routes.identity)),
            SectionHeader(title: l10n.needsDateConfirmation),
            AsyncStateView(
              value: summaryAsync,
              builder: (summary) => _UnconfirmedStrip(
                count: summary.unconfirmedDateCount,
                onTap: () => context.push(Routes.archive),
              ),
            ),
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
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.noDocuments),
                  );
                }
                return Column(
                  children: [
                    for (final doc in docs)
                      MedicalDocumentCard(
                        document: doc,
                        onTap: () =>
                            context.push(Routes.documentDetail(doc.uuid)),
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

class _UnconfirmedStrip extends StatelessWidget {
  const _UnconfirmedStrip({required this.count, this.onTap});

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (count == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(l10n.dateUnconfirmed),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: theme.colorScheme.tertiaryContainer,
        child: ListTile(
          leading: const Icon(Icons.event_busy),
          title: Text('$count ${l10n.needsDateConfirmation}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({this.onTapIdentity});

  final VoidCallback? onTapIdentity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ActionChip(
            avatar: const Icon(Icons.badge_outlined),
            label: Text(l10n.identity),
            onPressed: () => context.push(Routes.identity),
          ),
          ActionChip(
            avatar: const Icon(Icons.family_restroom),
            label: Text(l10n.minors),
            onPressed: () => context.push(Routes.minors),
          ),
          ActionChip(
            avatar: const Icon(Icons.description_outlined),
            label: Text(l10n.documents),
            onPressed: () => context.push(Routes.documents),
          ),
          ActionChip(
            avatar: const Icon(Icons.manage_accounts_outlined),
            label: Text(l10n.accountClaim),
            onPressed: () => context.push(Routes.claims),
          ),
        ],
      ),
    );
  }
}
