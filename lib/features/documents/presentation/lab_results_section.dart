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
                  const SizedBox(height: 4),
                  Text(
                    l10n.resultsExtractedFromReport,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (
                          var index = 0;
                          index < data.results.length;
                          index++
                        ) ...[
                          if (index > 0) const Divider(height: 1),
                          _LabResultRow(
                            result: data.results[index],
                            l10n: l10n,
                          ),
                        ],
                      ],
                    ),
                  ),
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

/// One compact professional result row (test | value+unit, reference below).
///
/// Dense table-like layout (no one-card-per-test) so CBC-style reports with
/// many rows stay scannable. Numeric values / Latin units are kept LTR inside
/// RTL UI; the flag is a neutral badge (no clinical colouring).
class _LabResultRow extends StatelessWidget {
  const _LabResultRow({required this.result, required this.l10n});

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
    final outline = theme.colorScheme.outline;
    final lowConfidence =
        result.extractionConfidence < lowLabConfidenceThreshold;
    return Semantics(
      container: true,
      label: _semanticsLabel,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    result.testNameRaw,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _ltr(
                        Text(
                          _valueText,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      if (result.flagRaw.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        _FlagBadge(flag: result.flagRaw),
                      ],
                      if (lowConfidence) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              size: 14,
                              color: outline,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                l10n.verifyWithOriginalReport,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: outline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (result.referenceRangeRaw.isNotEmpty) ...[
              const SizedBox(height: 4),
              _ltr(
                Text(
                  '${l10n.referenceRange}: ${result.referenceRangeRaw}',
                  style: theme.textTheme.bodySmall?.copyWith(color: outline),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Keep numeric values / Latin units from visual reversal inside RTL UI.
  Widget _ltr(Widget child) {
    return Directionality(textDirection: TextDirection.ltr, child: child);
  }
}

/// Neutral flag badge (H/L/R/*). No clinical colouring — the printed flag is
/// reported as-is and the patient always checks the original report.
class _FlagBadge extends StatelessWidget {
  const _FlagBadge({required this.flag});

  final String flag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: outline.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        flag,
        style: theme.textTheme.labelSmall?.copyWith(color: outline),
      ),
    );
  }
}
