import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/lab_results.dart';
import '../../../l10n/app_localizations.dart';
import '../application/documents_providers.dart';

/// Threshold below which an extracted row asks the patient to double check
/// against the original report. Neutral, never alarming.
const double lowLabConfidenceThreshold = 0.6;

/// "Extracted results" section for the document detail page.
///
/// Read-only derived view. The original uploaded report stays authoritative.
/// Rendered inline in the page scroll (never a nested independent scroll).
class LabResultsSection extends ConsumerWidget {
  const LabResultsSection({super.key, required this.uuid, this.minorUuid});

  final String uuid;
  final String? minorUuid;

  bool get _isMinor => minorUuid != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final async = _isMinor
        ? ref.watch(
            minorLabResultsProvider((
              minorUuid: minorUuid!,
              documentUuid: uuid,
            )),
          )
        : ref.watch(labResultsProvider(uuid));

    return async.when(
      loading: () => const _ExtractingCard(),
      error: (_, _) => const _UnavailableCard(),
      data: (data) {
        switch (data.extractionStatus) {
          case LabExtractionStatus.notApplicable:
            // Non-applicable / non-lab: hide the section entirely.
            return const SizedBox.shrink();
          case LabExtractionStatus.queued:
            return const _ExtractingCard();
          case LabExtractionStatus.failed:
            return const _UnavailableCard();
          case LabExtractionStatus.completed:
            if (data.results.isEmpty) {
              return const _ZeroResultsCard();
            }
            return _SectionPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(resultCount: data.resultCount, l10n: l10n),
                  const SizedBox(height: 8),
                  Text(
                    l10n.resultsExtractedFromReport,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  for (final result in data.results) ...[
                    LabResultCard(result: result, l10n: l10n),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.resultCount, required this.l10n});

  final int resultCount;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.extractedResults,
            style: theme.textTheme.titleMedium,
          ),
        ),
        Text(
          l10n.resultsCount(resultCount),
          style: theme.textTheme.labelMedium,
        ),
      ],
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
            l10n.structuredResultsUnavailable,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class _ZeroResultsCard extends StatelessWidget {
  const _ZeroResultsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return _SectionPadding(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.noStructuredResultsDetected,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

/// Vertical separation between the metadata block and this section, applied
/// only when the section is actually visible.
class _SectionPadding extends StatelessWidget {
  const _SectionPadding({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 12), child: child);
  }
}

/// One patient-facing result card.
class LabResultCard extends StatelessWidget {
  const LabResultCard({super.key, required this.result, required this.l10n});

  final LabResultItem result;
  final AppLocalizations l10n;

  String get _valueText {
    final value = result.resultRaw.isNotEmpty
        ? result.resultRaw
        : result.resultText;
    final unit = result.unitRaw;
    if (unit.isEmpty) return value;
    return '$value $unit';
  }

  String get _semanticsLabel {
    final ref = result.referenceRangeRaw.isNotEmpty
        ? result.referenceRangeRaw
        : '';
    return [
      result.testNameRaw,
      if (_valueText.isNotEmpty) '${l10n.result} $_valueText',
      if (ref.isNotEmpty) '${l10n.referenceRange} $ref',
      if (result.flagRaw.isNotEmpty) '${l10n.reportFlag}: ${result.flagRaw}',
    ].join('. ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lowConfidence =
        result.extractionConfidence < lowLabConfidenceThreshold;
    return Semantics(
      container: true,
      label: _semanticsLabel,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(result.testNameRaw, style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              _ltr(Text(_valueText, style: theme.textTheme.bodyLarge)),
              if (result.referenceRangeRaw.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(l10n.referenceRange, style: theme.textTheme.labelSmall),
                _ltr(
                  Text(
                    result.referenceRangeRaw,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
              if (result.flagRaw.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '${l10n.reportFlag}: ${result.flagRaw}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              if (lowConfidence) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.verified_user_outlined, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.verifyWithOriginalReport,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Keep numeric values / Latin units from visual reversal inside RTL UI.
  Widget _ltr(Widget child) {
    return Directionality(textDirection: TextDirection.ltr, child: child);
  }
}
