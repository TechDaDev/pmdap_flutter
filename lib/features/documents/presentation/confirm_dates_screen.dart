import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/models/pending_date_confirmation.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/presentation.dart';
import '../../../core/utils/status_labels.dart';
import '../../medical_context/application/patient_context_controller.dart';
import '../../medical_context/domain/patient_context.dart';
import '../application/documents_providers.dart';

/// Confirm Dates queue — document-centric.
///
/// Single source (`pendingDateConfirmationDocumentsProvider`) shared with the
/// Home badge. A document appears even when OCR found NO date (manual entry
/// fallback). Tapping a card opens the per-document confirmation screen, which
/// owns candidate selection + manual date entry; it invalidates this provider
/// on success so the queue and badge refresh.
class ConfirmDatesScreen extends ConsumerWidget {
  const ConfirmDatesScreen({super.key, this.minorUuid});

  final String? minorUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(patientContextProvider);
    final effective = minorUuid == null
        ? selected
        : PatientContext.minor(
            relationshipUuid: selected.relationshipUuid ?? '',
            minorUuid: minorUuid!,
            safeDisplayName: selected.safeDisplayName ?? '',
          );
    final queueAsync = effective.isMinor
        ? ref.watch(contextPendingDateConfirmationDocumentsProvider(effective))
        : ref.watch(pendingDateConfirmationDocumentsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.confirmDatesTitle)),
      body: RefreshIndicator(
        onRefresh: () async {
          if (effective.isMinor) {
            ref.invalidate(
              contextPendingDateConfirmationDocumentsProvider(effective),
            );
          } else {
            ref.invalidate(pendingDateConfirmationDocumentsProvider);
          }
        },
        child: queueAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 160),
              Center(child: Text(l10n.errorGeneric)),
            ],
          ),
          data: (queue) {
            if (queue.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 160),
                  Center(
                    child: Text(
                      l10n.noDocumentsNeedConfirmation,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }
            final labels = StatusLabels(l10n);
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: queue.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = queue[index];
                return _PendingDocumentCard(
                  doc: entry,
                  typeLabel: labels.medicalDocumentTypeLabel(
                    entry.documentType,
                  ),
                  pageTitle: entry.isMultiPage
                      ? '${l10n.pageLabel} ${entry.pageNumber} · '
                            '${labels.reportSubtypeLabel(entry.reportSubtype)}'
                      : null,
                  l10n: l10n,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PendingDocumentCard extends StatelessWidget {
  const _PendingDocumentCard({
    required this.doc,
    required this.typeLabel,
    required this.l10n,
    this.pageTitle,
  });

  final PendingDateConfirmation doc;
  final String typeLabel;
  final AppLocalizations l10n;

  /// Multi-page PDF entries show "Page N · subtype" as their title.
  final String? pageTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = pageTitle ?? typeLabel;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event_busy_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      if (pageTitle != null)
                        Text(
                          typeLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  localizedDate(l10n, doc.createdAt),
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (doc.detectedCandidates.isEmpty) ...[
              Text(l10n.noDateDetected, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 2),
              Text(
                l10n.enterReportDate,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ] else ...[
              Text(
                l10n.suggestedDate,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              for (final c in doc.detectedCandidates)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        c.isSuggested
                            ? Icons.star
                            : Icons.event_available_outlined,
                        size: 16,
                        color: c.isSuggested
                            ? theme.colorScheme.tertiary
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        c.date == null ? '—' : formatApiDate(c.date),
                        style: c.isSuggested
                            ? const TextStyle(fontWeight: FontWeight.bold)
                            : null,
                      ),
                    ],
                  ),
                ),
            ],
            const SizedBox(height: 14),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.tonalIcon(
                onPressed: () => context.push(
                  doc.isMultiPage
                      ? '${Routes.documentDate(doc.documentUuid)}'
                            '?page=${doc.pageNumber}'
                      : Routes.documentDate(doc.documentUuid),
                  extra: null,
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: Text(l10n.confirmDate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
