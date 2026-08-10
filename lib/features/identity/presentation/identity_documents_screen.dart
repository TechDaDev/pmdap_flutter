import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/identity.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/pmdap_scaffold.dart';
import '../../../core/widgets/status_badge.dart';
import '../application/identity_providers.dart';

/// Pre-camera identity document list + history.
class IdentityDocumentsScreen extends ConsumerWidget {
  const IdentityDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(identityDocumentsProvider);

    return PmdapScaffold(
      title: l10n.identityTitle,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.identityNew),
        icon: const Icon(Icons.add_a_photo_outlined),
        label: Text(l10n.addIdentityDocument),
      ),
      body: AsyncStateView(
        value: async,
        onRetry: () => ref.invalidate(identityDocumentsProvider),
        emptyBuilder: (page) => page.results.isEmpty
            ? EmptyState(
                icon: Icons.badge_outlined,
                message: l10n.noIdentityDocuments,
              )
            : null,
        builder: (page) {
          final labels = StatusLabels(l10n);
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: page.results.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final doc = page.results[i];
              return _IdentityTile(
                doc: doc,
                statusLabel: labels.verification(doc.verificationStatus),
                tone: _toneFor(doc.verificationStatus),
                onTap: () => context.push(Routes.identityDetail(doc.uuid)),
              );
            },
          );
        },
      ),
    );
  }

  StatusTone _toneFor(VerificationStatus s) {
    switch (s) {
      case VerificationStatus.verified:
        return StatusTone.success;
      case VerificationStatus.pending:
        return StatusTone.warning;
      case VerificationStatus.rejected:
        return StatusTone.error;
      case VerificationStatus.unknown:
        return StatusTone.neutral;
    }
  }
}

class _IdentityTile extends StatelessWidget {
  const _IdentityTile({
    required this.doc,
    required this.statusLabel,
    required this.tone,
    this.onTap,
  });

  final IdentityDocumentSummary doc;
  final String statusLabel;
  final StatusTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = StatusLabels(l10n);
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(child: const Icon(Icons.badge_outlined)),
      title: Text(labels.identityDocumentType(doc.documentType)),
      subtitle: Text(
        doc.issuingCountry.isNotEmpty ? doc.issuingCountry : l10n.noData,
      ),
      trailing: StatusBadge.fromTone(label: statusLabel, tone: tone),
    );
  }
}
