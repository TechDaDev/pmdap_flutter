import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/extracted_content.dart';
import '../../../l10n/app_localizations.dart';
import '../application/documents_providers.dart';

/// "Extracted report" narrative section for the document detail page.
///
/// Shown for narrative documents (radiology, imaging, letters). The body is a
/// conservative, presentation-oriented rebuild of the persisted OCR text:
/// heading + paragraph sections, comfortable line height, no raw OCR line
/// numbers. The original uploaded report stays authoritative.
class ExtractedReportSection extends ConsumerWidget {
  const ExtractedReportSection({super.key, required this.uuid, this.minorUuid});

  final String uuid;
  final String? minorUuid;

  bool get _isMinor => minorUuid != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final async = _isMinor
        ? ref.watch(
            minorExtractedContentProvider((
              minorUuid: minorUuid!,
              documentUuid: uuid,
            )),
          )
        : ref.watch(extractedContentProvider(uuid));

    return async.when(
      loading: () => const _ExtractingCard(),
      error: (_, _) => const _UnavailableCard(),
      data: (data) {
        switch (data.contentKind) {
          case ExtractedContentKind.narrative:
            if (data.sections.isEmpty) {
              return const _NoContentCard();
            }
            return _SectionPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.extractedReport,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.resultsExtractedFromReport,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final section in data.sections) ...[
                            if (section.heading.isNotEmpty) ...[
                              Text(
                                section.heading,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],
                            Text(
                              section.body,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          case ExtractedContentKind.lab:
            // Laboratory documents use the dedicated structured lab section.
            return const SizedBox.shrink();
          case ExtractedContentKind.none:
          default:
            if (data.status == 'FAILED') {
              return const _UnavailableCard();
            }
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _ExtractingCard extends StatelessWidget {
  const _ExtractingCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return _SectionPadding(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.extractingResults,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnavailableCard extends StatelessWidget {
  const _UnavailableCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return _SectionPadding(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.reportUnavailable,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class _NoContentCard extends StatelessWidget {
  const _NoContentCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return _SectionPadding(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.noExtractedReportDetected,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class _SectionPadding extends StatelessWidget {
  const _SectionPadding({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 12), child: child);
  }
}
