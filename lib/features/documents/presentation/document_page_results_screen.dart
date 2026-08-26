import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pmdap_mobile/app/router.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/document_page.dart';
import 'package:pmdap_mobile/core/models/lab_results.dart';
import 'package:pmdap_mobile/core/utils/status_labels.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../application/documents_providers.dart';
import '../../medical_context/application/patient_context_controller.dart';
import '../../medical_context/domain/patient_context.dart';

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
    final patientContext = ref.watch(patientContextProvider);
    final detailAsync = patientContext.isMinor
        ? ref.watch(
            contextDocumentPageDetailProvider((
              context: patientContext,
              uuid: uuid,
              pageNumber: pageNumber,
            )),
          )
        : ref.watch(
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
        error: (Object error, StackTrace _) => Center(
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
              if (detail.processingStatus == 'AWAITING_CONFIRMATION' &&
                  !detail.dateVerified) ...[
                const SizedBox(height: 8),
                _DateConfirmSection(
                  patientContext: patientContext,
                  uuid: uuid,
                  pageNumber: pageNumber,
                  detail: detail,
                ),
              ],
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
              Text(
                l10n.sourceDocument,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.push(Routes.documentViewer(uuid)),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: Text(l10n.viewOriginalPdf),
              ),
              // Keep the CTA clear of the system bottom inset on this
              // top-level route (no PMDAP bottom nav here).
              SizedBox(height: 16 + MediaQuery.of(context).viewPadding.bottom),
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

class _DateConfirmSection extends ConsumerStatefulWidget {
  const _DateConfirmSection({
    required this.uuid,
    required this.pageNumber,
    required this.detail,
    required this.patientContext,
  });

  final String uuid;
  final int pageNumber;
  final MedicalDocumentPageDetail detail;
  final PatientContext patientContext;

  @override
  ConsumerState<_DateConfirmSection> createState() =>
      _DateConfirmSectionState();
}

class _DateConfirmSectionState extends ConsumerState<_DateConfirmSection> {
  DateTime? _manualDate;
  bool _confirming = false;
  String? _errorMessage;

  Future<void> _confirm({String? candidateId}) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _confirming = true;
      _errorMessage = null;
    });
    try {
      await ref
          .read(medicalRecordsRepositoryProvider)
          .confirmPageDate(
            widget.patientContext,
            widget.uuid,
            widget.pageNumber,
            candidateId: candidateId,
            date: candidateId == null ? _manualDate : null,
          );
      // Page + parent summaries follow the confirmed page.
      if (widget.patientContext.isMinor) {
        ref.invalidate(
          contextDocumentPageDetailProvider((
            context: widget.patientContext,
            uuid: widget.uuid,
            pageNumber: widget.pageNumber,
          )),
        );
        ref.invalidate(
          contextDocumentPagesProvider((
            context: widget.patientContext,
            uuid: widget.uuid,
          )),
        );
      } else {
        ref.invalidate(
          documentPageDetailProvider((
            uuid: widget.uuid,
            pageNumber: widget.pageNumber,
          )),
        );
        ref.invalidate(documentPagesProvider(widget.uuid));
      }
      invalidateMedicalDocumentLists(ref, widget.patientContext);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.dateConfirmed)));
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } catch (_) {
      if (mounted) setState(() => _errorMessage = l10n.confirmFailed);
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  Future<void> _pickManualDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _manualDate ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: AppLocalizations.of(context).manualDate,
    );
    if (picked != null) setState(() => _manualDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final candidates = widget.detail.detectedCandidates;
    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.confirmThisPage,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (candidates.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                l10n.suggestedDate,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              for (final c in candidates.take(3))
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
                        c.date == null ? '—' : _formatDateYmd(c.date!),
                        style: c.isSuggested
                            ? const TextStyle(fontWeight: FontWeight.bold)
                            : null,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in candidates.take(3))
                    FilledButton.tonalIcon(
                      onPressed: _confirming
                          ? null
                          : () => _confirm(candidateId: c.uuid),
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: Text(
                        c.date == null ? '—' : _formatDateYmd(c.date!),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _pickManualDate,
                  icon: const Icon(Icons.edit_calendar_outlined, size: 18),
                  label: Text(
                    _manualDate == null
                        ? l10n.manualDate
                        : _formatDateYmd(_manualDate!),
                  ),
                ),
                if (_manualDate != null) ...[
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _confirming ? null : () => _confirm(),
                    child: _confirming
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.confirmDate),
                  ),
                ],
              ],
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _formatDateYmd(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

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
