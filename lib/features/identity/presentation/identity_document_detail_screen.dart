import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/private_image_viewer.dart';
import '../../../core/widgets/status_badge.dart';
import '../application/identity_providers.dart';

/// Identity document detail — verification state + private image viewing
/// (via authenticated bytes; nothing is saved to the gallery).
class IdentityDocumentDetailScreen extends ConsumerWidget {
  const IdentityDocumentDetailScreen({super.key, required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(identityDocumentDetailProvider(uuid));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.identityTitle),
        actions: [
          IconButton(
            onPressed: () => context.push('/identity/$uuid/replace'),
            icon: const Icon(Icons.swap_horiz),
            tooltip: l10n.replaceIdentityDocument,
          ),
        ],
      ),
      body: AsyncStateView(
        value: async,
        onRetry: () => ref.invalidate(identityDocumentDetailProvider(uuid)),
        builder: (doc) {
          final labels = StatusLabels(l10n);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: StatusBadge.neutral(
                  label: labels.verificationLabel(doc.verificationStatus),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    _Row(
                      l10n.documentType,
                      labels.identityTypeLabel(doc.documentType),
                    ),
                    _Row(l10n.documentNumber, doc.documentNumber),
                    if (doc.nationalNumber.isNotEmpty)
                      _Row(l10n.nationalNumber, doc.nationalNumber),
                    if (doc.familyNumber.isNotEmpty)
                      _Row(l10n.familyNumber, doc.familyNumber),
                    _Row(l10n.issuingCountry, doc.issuingCountry),
                    _Row(l10n.issueDate, formatApiDate(doc.issueDate)),
                    _Row(l10n.expiryDate, formatApiDate(doc.expiryDate)),
                    _Row(
                      l10n.verificationStatus,
                      labels.verificationLabel(doc.verificationStatus),
                    ),
                  ],
                ),
              ),
              if (doc.rejectionReason.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  doc.rejectionReason,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                l10n.replacementInfo,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              if (doc.availableImages.isNotEmpty)
                _ImageButtons(
                  uuid: uuid,
                  images: doc.availableImages,
                  ref: ref,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ImageButtons extends StatelessWidget {
  const _ImageButtons({
    required this.uuid,
    required this.images,
    required this.ref,
  });

  final String uuid;
  final List<String> images;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 8,
      children: [
        for (final side in images)
          ActionChip(
            avatar: const Icon(Icons.image_outlined),
            label: Text(l10n.viewImage),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PrivateImageViewer(
                    title: '$l10n.viewImage ($side)',
                    fetchBytes: () =>
                        ref.read(identityApiProvider).fetchImage(uuid, side),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: Text(value.isEmpty ? '—' : value, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
