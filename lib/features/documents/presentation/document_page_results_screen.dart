import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pmdap_mobile/app/router.dart';
import 'package:pmdap_mobile/core/models/document_page.dart';
import 'package:pmdap_mobile/core/models/lab_results.dart';
import 'package:pmdap_mobile/core/utils/status_labels.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../application/documents_providers.dart';

/// Results for ONE report page unit of a multi-page PDF.
///
/// Own title ("Page N · subtype"), own status, own extracted results, own
/// date state. Never dumps results from other pages.
class DocumentPageResultsScreen extends ConsumerWidget {
  const DocumentPageResultsScreen({
    super.key,
    required this.uuid,
    required this.pageNumber,
  });

  final String uuid;
  final int pageNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final detailAsync = ref.watch(
      documentPageDetailProvider((uuid: uuid, pageNumber: pageNumber)),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${l10n.pageLabel} $pageNumber',
          style: theme.textTheme.titleMedium,
        ),
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace __) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.resultsNotAvailable,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
        data: (detail) {
          final labels = StatusLabels(l10n);
          final subtype = detail.reportSubtype.isEmpty
              ? l10n.unknownStatus
              : labels.reportSubtypeLabel(detail.reportSubtype);
          final extracting =
              detail.processingStatus == 'EXTRACTING' ||
              detail.processingStatus == 'OCR_PROCESSING' ||
              detail.processingStatus == 'QUEUED';
          final failed = detail.processingStatus == 'FAILED';
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      subtype,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  labels.pageStatusBadge(detail.processingStatus),
                ],
              ),
              const SizedBox(height: 12),
              _DateStateRow(detail: detail, l10n: l10n, labels: labels),
              const SizedBox(height: 16),
              Text(
                '${l10n.extractedResults} · ${detail.labResultCount}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (extracting)
                _ExtractingCard(l10n: l10n)
              else if (failed)
                _FailedCard(l10n: l10n, labels: labels)
              else if (detail.labResults.isEmpty)
                _EmptyCard(l10n: l10n)
              else
                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final result in detail.labResults)
                        _ResultRow(result: result, l10n: l10n),
                    ],
                  ),
                ),
              if (detail.dateVerified && detail.documentDate != null) ...[
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '${l10n.reportDate}: '
                      '${_formatDate(l10n, detail.documentDate!)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.push(Routes.documentViewer(uuid)),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: Text(l10n.viewOriginalPdf),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(AppLocalizations l10n, DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

class _DateStateRow extends StatelessWidget {
  const _DateStateRow({
    required this.detail,
    required this.l10n,
    required this.labels,
  });

  final MedicalDocumentPageDetail detail;
  final AppLocalizations l10n;
  final StatusLabels labels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String label;
    if (detail.dateVerified && detail.documentDate != null) {
      label = l10n.dateConfirmedState;
    } else if (detail.processingStatus == 'AWAITING_CONFIRMATION') {
      label = l10n.needsDateConfirmation;
    } else if (detail.processingStatus == 'FAILED') {
      label = l10n.statusFailed;
    } else {
      label = l10n.dateNotDetected;
    }
    return Row(
      children: [
        Icon(
          Icons.event_outlined,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _ExtractingCard extends StatelessWidget {
  const _ExtractingCard({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.statusExtracting)),
          ],
        ),
      ),
    );
  }
}

class _FailedCard extends StatelessWidget {
  const _FailedCard({required this.l10n, required this.labels});
  final AppLocalizations l10n;
  final StatusLabels labels;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labels.pageStatusBadge('FAILED'),
            const SizedBox(height: 8),
            Text(l10n.resultsNotAvailable),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(l10n.noResultsOnPage),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result, required this.l10n});
  final LabResultItem result;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ref = result.referenceRangeRaw.isEmpty
        ? ''
        : '${l10n.reference}: ${result.referenceRangeRaw}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.testNameRaw,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (ref.isNotEmpty)
                  Text(
                    ref,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              result.resultRaw,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
