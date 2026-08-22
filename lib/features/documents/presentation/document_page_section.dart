import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pmdap_mobile/app/router.dart';
import 'package:pmdap_mobile/core/models/document_page.dart';
import 'package:pmdap_mobile/core/utils/status_labels.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../application/documents_providers.dart';

/// "Extracted reports · N pages" section for multi-page PDFs.
///
/// One compact card per independent page/report unit (page number, detected
/// subtype, status, date state, result count). Tapping a card opens that
/// page's results. Hidden entirely for single-page documents.
class DocumentPageSection extends ConsumerWidget {
  const DocumentPageSection({super.key, required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final pagesAsync = ref.watch(documentPagesProvider(uuid));
    return pagesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (Object _, StackTrace __) => const SizedBox.shrink(),
      data: (summary) {
        if (summary.pageCount <= 1) return const SizedBox.shrink();
        final labels = StatusLabels(l10n);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                l10n.extractedReports(summary.pageCount),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var i = 0; i < summary.pages.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    _PageCard(
                      page: summary.pages[i],
                      labels: labels,
                      l10n: l10n,
                      onTap: () =>
                          context.push(Routes.documentPageResults(uuid, i + 1)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PageCard extends StatelessWidget {
  const _PageCard({
    required this.page,
    required this.labels,
    required this.l10n,
    required this.onTap,
  });

  final MedicalDocumentPageSummaryItem page;
  final StatusLabels labels;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtype = page.reportSubtype.isEmpty
        ? l10n.unknownStatus
        : labels.reportSubtypeLabel(page.reportSubtype);
    final String dateState;
    if (page.dateVerified && page.documentDate != null) {
      dateState = l10n.dateConfirmedState;
    } else if (page.processingStatus == 'AWAITING_CONFIRMATION') {
      dateState = l10n.needsDateConfirmation;
    } else if (page.processingStatus == 'FAILED') {
      dateState = l10n.statusFailed;
    } else {
      dateState = l10n.dateNotDetected;
    }
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: Text('${page.pageNumber}', style: theme.textTheme.labelLarge),
      ),
      title: Text(
        subtype,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            labels.pageStatusBadge(page.processingStatus),
            Text(
              '${page.labResultCount} ${l10n.results}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              dateState,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
