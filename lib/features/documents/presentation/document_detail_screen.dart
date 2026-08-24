import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/date_candidate.dart';
import '../../../core/models/document_page.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/models/pagination.dart' as pag;
import '../../../core/utils/presentation.dart';
import '../../../core/utils/status_labels.dart';
import '../../documents/application/documents_providers.dart';
import 'document_page_section.dart';
import 'extracted_report_section.dart';
import 'lab_results_section.dart';

/// Medical document detail.
///
/// Polls the detail endpoint every 3s ONLY while processing is active, and
/// stops at terminal/actionable states. Private files are fetched through the
/// authenticated download endpoint, cached in the temp dir for viewing, then
/// cleaned up.
class DocumentDetailScreen extends ConsumerStatefulWidget {
  const DocumentDetailScreen({
    super.key,
    required this.uuid,
    this.minorUuid,
    this.clock,
  });

  final String uuid;
  final String? minorUuid;

  /// Injectable clock for the poll deadline (tests use fake time; production
  /// defaults to [DateTime.now]).
  final DateTime Function()? clock;

  @override
  ConsumerState<DocumentDetailScreen> createState() =>
      _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends ConsumerState<DocumentDetailScreen>
    with WidgetsBindingObserver {
  Future<MedicalDocumentDetail>? _future;

  /// Last successfully loaded detail. Kept so every 3s poll rebuilds with the
  /// previous data (no full-screen loading flash) while the fresh fetch is in
  /// flight; scroll position and rendered metadata stay stable.
  MedicalDocumentDetail? _lastDetail;

  Timer? _timer;
  AppLifecycleState _lifecycle = AppLifecycleState.resumed;

  /// When the poll window started (deadline anchor).
  DateTime? _pollStartedAt;

  /// True once the bounded poll window expired while still processing.
  bool _pollExpired = false;

  /// Last seen processing status — used to trigger list propagation only on
  /// real transitions (avoids refetch churn every poll).
  ProcessingStatus? _lastStatus;

  /// OCR can take minutes; poll generously but with a hard, finite deadline.
  static const Duration _maxPollDuration = Duration(minutes: 5);

  bool get _isMinor => widget.minorUuid != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycle = state;
    if (state == AppLifecycleState.resumed) {
      // Fresh poll window after returning to foreground; also refresh list
      // views so home/archive pick up any backend progress.
      _pollStartedAt = null;
      _pollExpired = false;
      invalidateMedicalDocumentLists(ref);
      _schedulePollingIfNeeded();
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _timer = null;
    // Note: no ref invalidation here — Riverpod forbids touching `ref` after
    // dispose. List/derived providers are autoDispose, so returning to home/
    // archive re-creates them and refetches fresh status anyway. Transitions
    // and app-resume invalidate while the widget is still alive.
    super.dispose();
  }

  DateTime _now() => (widget.clock ?? DateTime.now)();

  Future<MedicalDocumentDetail> _load() {
    if (_isMinor) {
      return ref
          .read(minorDocumentsApiProvider)
          .detail(widget.minorUuid!, widget.uuid);
    }
    return ref.read(documentsApiProvider).detail(widget.uuid);
  }

  void _reload() {
    // CRITICAL: never pass `() => _future = _load()` to setState — the arrow
    // returns a Future, and Flutter's debug assertion "setState() callback
    // argument returned a Future" throws on the FIRST poll tick in debug
    // builds, silently killing the poll chain and leaving the screen stuck on
    // the stale "OCR processing" status.
    final future = _load();
    setState(() {
      _future = future;
    });
  }

  void _invalidateLabResults() {
    if (_isMinor) {
      ref.invalidate(
        minorLabResultsProvider((
          minorUuid: widget.minorUuid!,
          documentUuid: widget.uuid,
        )),
      );
    } else {
      ref.invalidate(labResultsProvider(widget.uuid));
    }
  }

  void _scheduleNextPoll() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      // Clear BEFORE reload so the rebuild re-registers a handler on the new
      // future (otherwise the chain dies after one poll).
      _timer = null;
      if (mounted) _reload();
    });
  }

  /// Continue polling while the backend is still working, WITHOUT the chain
  /// dying on a transient network error. A failed poll keeps the current
  /// status on screen and simply retries after 3s until the deadline.
  void _schedulePollingIfNeeded() {
    final current = _future;
    if (current == null || _timer != null) return;
    current.then<void>(
      _handlePollResult,
      onError: (Object _) {
        if (!mounted) return;
        if (_lifecycle == AppLifecycleState.resumed && !_deadlineExceeded()) {
          _scheduleNextPoll();
        }
      },
    );
  }

  void _handlePollResult(MedicalDocumentDetail doc) {
    if (!mounted) return;
    // Retain the freshest data so a subsequent poll rebuilds on stable content.
    _lastDetail = doc;
    final status = doc.processingStatus;
    if (_lastStatus != status) {
      _lastStatus = status;
      // Status moved (including to a terminal state): refresh every list view.
      invalidateMedicalDocumentLists(ref);
      _invalidateLabResults();
    }
    _pollStartedAt ??= _now();
    if (status.isActive &&
        _lifecycle == AppLifecycleState.resumed &&
        !_deadlineExceeded()) {
      _scheduleNextPoll();
    } else {
      _timer?.cancel();
      if (_deadlineExceeded() && !_pollExpired) {
        setState(() => _pollExpired = true);
      }
    }
  }

  bool _deadlineExceeded() {
    final start = _pollStartedAt;
    return start != null && _now().difference(start) > _maxPollDuration;
  }

  Future<void> _viewFile(MedicalDocumentDetail doc) async {
    // In-app private viewer: fetch through authenticated API inside the viewer
    // screen (never a public URL, never an external app).
    await context.push(
      Routes.documentViewer(widget.uuid),
      extra: widget.minorUuid,
    );
  }

  /// Localized report-date value with a semantic fallback when the API has
  /// not produced a date yet.
  String _dateLabel(AppLocalizations l10n, MedicalDocumentDetail doc) {
    if (doc.documentDate != null) {
      return localizedDate(l10n, doc.documentDate);
    }
    if (doc.processingStatus.needsDateAction) {
      return l10n.needsDateConfirmation;
    }
    return l10n.dateNotDetected;
  }

  Future<void> _delete(MedicalDocumentDetail doc) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteDocument),
        content: Text(l10n.deleteDocumentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      if (_isMinor) {
        await ref
            .read(minorDocumentsApiProvider)
            .delete(widget.minorUuid!, widget.uuid);
      } else {
        await ref.read(documentsApiProvider).delete(widget.uuid);
      }
      ref.invalidate(documentsProvider);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleted)));
      navigator.maybePop();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.documentDetails),
        actions: [
          IconButton(
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
            tooltip: l10n.retry,
          ),
        ],
      ),
      body: FutureBuilder<MedicalDocumentDetail>(
        future: _future,
        initialData: _lastDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError && !snapshot.hasData) {
            return Center(
              child: Text(
                snapshot.error is ApiException
                    ? (snapshot.error! as ApiException).message
                    : l10n.errorGeneric,
              ),
            );
          }
          final doc = snapshot.data!;
          _schedulePollingIfNeeded();
          final labels = StatusLabels(l10n);
          final mime = doc.file?.mimeType ?? '';

          // A report date is authoritative only once confirmed by the user.
          // While awaiting confirmation we show the OCR "detected date"
          // candidate (or "Not detected"), never a fake "Report date".
          final confirmed = doc.dateVerified && doc.documentDate != null;
          final awaiting =
              !confirmed &&
              (doc.processingStatus.needsDateAction ||
                  doc.processingStatus == ProcessingStatus.dateDetected ||
                  doc.processingStatus == ProcessingStatus.dateNotFound);
          // Same authoritative candidate source as the Confirm Dates queue
          // (DateCandidate rows, is_current=True). Watching it here means a
          // provider invalidation after OCR completes also refreshes this
          // detail view — no stale candidate display.
          final candidatesAsync = _isMinor
              ? ref.watch(
                  minorDateCandidatesProvider((
                    minorUuid: widget.minorUuid!,
                    documentUuid: widget.uuid,
                  )),
                )
              : ref.watch(dateCandidatesProvider(widget.uuid));
          // Multi-page PDFs: one archived source document with independent
          // page report units. Single-page docs keep the classic flat view.
          // Gate the pages fetch on the stored file's page count so
          // single-page documents never touch the pages endpoint.
          final filePageCount = doc.file?.pageCount;
          final multiPage =
              !_isMinor && filePageCount != null && filePageCount > 1;
          final pagesAsync = multiPage
              ? ref.watch(documentPagesProvider(widget.uuid))
              : null;
          final isPdf = mime.contains('pdf');
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  labels.processing(doc.processingStatus),
                  const SizedBox(width: 8),
                  if (doc.processingStatus.isActive)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  // File type is shown inside the metadata card below.
                ],
              ),
              if (doc.processingStatus ==
                  ProcessingStatus.duplicateDetected) ...[
                const SizedBox(height: 12),
                Card(
                  margin: EdgeInsets.zero,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.duplicateDetectedTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.duplicateDetectedMessage,
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (doc.duplicateOf != null)
                              OutlinedButton.icon(
                                onPressed: () => context.push(
                                  Routes.documentDetail(doc.duplicateOf!),
                                  extra: widget.minorUuid,
                                ),
                                icon: const Icon(Icons.visibility_outlined),
                                label: Text(l10n.viewExisting),
                              ),
                            TextButton.icon(
                              onPressed: () => _delete(doc),
                              icon: Icon(
                                Icons.delete_outline,
                                color: theme.colorScheme.error,
                              ),
                              label: Text(
                                l10n.removeDuplicate,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (_pollExpired) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.hourglass_bottom, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.documentStillProcessing,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    _Row(l10n.title, doc.title),
                    _Row(
                      l10n.documentType,
                      labels.medicalDocumentTypeLabel(doc.documentType),
                    ),
                    if (doc.description.isNotEmpty)
                      _Row(l10n.description, doc.description),
                    if (confirmed) ...[
                      _Row(
                        l10n.reportDate,
                        localizedDate(l10n, doc.documentDate),
                      ),
                      _Row(l10n.dateVerifiedLabel, l10n.dateConfirmedState),
                    ] else if (awaiting) ...[
                      if (multiPage) ...[
                        _Row(
                          l10n.dateStatusLabel,
                          l10n.pagesNeedConfirmation(filePageCount!),
                        ),
                      ] else ...[
                        _CandidateDateRow(
                          candidates: candidatesAsync,
                          l10n: l10n,
                        ),
                        _Row(l10n.dateStatusLabel, l10n.needsConfirmation),
                      ],
                    ] else ...[
                      _Row(l10n.reportDate, _dateLabel(l10n, doc)),
                      _Row(
                        l10n.dateVerifiedLabel,
                        doc.dateVerified
                            ? l10n.dateConfirmedState
                            : l10n.needsDateConfirmation,
                      ),
                    ],
                    if (doc.healthcareFacility != null ||
                        doc.facilityName.isNotEmpty ||
                        doc.locationText.isNotEmpty)
                      _Row(
                        l10n.facility,
                        facilityDisplayName(
                          healthcareFacility: doc.healthcareFacility,
                          facilityName: doc.facilityName,
                          locationText: doc.locationText,
                        ),
                      ),
                    if (doc.department.isNotEmpty)
                      _Row(l10n.department, doc.department),
                    if (doc.physicianName.isNotEmpty)
                      _Row(l10n.physician, doc.physicianName),
                    _Row(
                      l10n.fileType,
                      isPdf ? 'PDF' : (mime.contains('png') ? 'PNG' : 'Image'),
                    ),
                  ],
                ),
              ),
              // Multi-page PDFs: page report-unit cards (independent status,
              // date state, results). Single-page docs keep the flat sections.
              if (multiPage) ...[
                const SizedBox(height: 16),
                DocumentPageSection(uuid: widget.uuid),
              ],
              // Structured lab results (derived, read-only). Only shown for
              // laboratory documents; the section hides itself for
              // NOT_APPLICABLE / non-lab docs. Multi-page PDFs render their
              // results per page in DocumentPageSection instead.
              if (!multiPage &&
                  doc.documentType == MedicalDocumentType.laboratory)
                LabResultsSection(
                  uuid: widget.uuid,
                  minorUuid: widget.minorUuid,
                ),
              // Narrative extracted report (radiology, imaging, letters).
              if (!multiPage &&
                  doc.documentType != MedicalDocumentType.laboratory)
                ExtractedReportSection(
                  uuid: widget.uuid,
                  minorUuid: widget.minorUuid,
                ),
              if (doc.file != null) ...[
                const SizedBox(height: 12),
                ExpansionTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.fileInfo),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  children: [
                    _Row(l10n.fileName, doc.file!.originalFilename),
                    _Row(l10n.fileType, doc.file!.mimeType),
                    _Row(l10n.fileSize, fileSizeLabel(doc.file!.sizeBytes)),
                    if (doc.file!.pageCount != null)
                      _Row(l10n.filePages, '${doc.file!.pageCount}'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: labels.integrity(doc.file!.integrityStatus),
                      ),
                    ),
                  ],
                ),
              ],
              if (doc.file != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _viewFile(doc),
                  icon: Icon(
                    isPdf
                        ? Icons.picture_as_pdf_outlined
                        : Icons.image_outlined,
                  ),
                  label: Text(l10n.viewFile),
                ),
              ],
              if (!multiPage &&
                  (doc.processingStatus.needsDateAction ||
                      doc.processingStatus ==
                          ProcessingStatus.dateDetected)) ...[
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () async {
                    // Await the confirmation screen so returning refreshes the
                    // detail + all list views — no manual refresh needed.
                    await context.push(
                      Routes.documentDate(widget.uuid),
                      extra: widget.minorUuid,
                    );
                    if (!mounted) return;
                    invalidateMedicalDocumentLists(ref);
                    _reload();
                  },
                  icon: const Icon(Icons.event_available),
                  label: Text(l10n.confirmDate),
                ),
              ],
              const SizedBox(height: 16),
              SafeArea(
                top: false,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                        child: Text(
                          l10n.documentActions,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.delete_outline,
                          color: theme.colorScheme.error,
                        ),
                        title: Text(
                          l10n.deleteDocument,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        onTap: () => _delete(doc),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// "Detected date" row shown while a document awaits date confirmation.
///
/// Renders the top-ranked OCR candidate with a "Suggested" badge, or
/// "Not detected" when OCR found no date. Multiple candidates surface an
/// "N possible dates detected" hint (the Confirm Dates screen still shows
/// every candidate). The candidate is never presented as a confirmed report
/// date.
class _CandidateDateRow extends StatelessWidget {
  const _CandidateDateRow({required this.candidates, required this.l10n});

  final AsyncValue<pag.Page<DateCandidate>> candidates;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.onSurfaceVariant;
    final display = _resolve(theme);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.detectedDateLabel,
                  style: TextStyle(color: secondary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(display.value, textAlign: TextAlign.end)),
            ],
          ),
          if (display.badge != null || display.note != null) ...[
            const SizedBox(height: 4),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (display.badge != null) display.badge!,
                  if (display.note != null)
                    Text(display.note!, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Resolve the detected-date display from the authoritative candidate page
  /// (loading / error / data). The OCR candidate is shown as "Suggested" —
  /// never as a confirmed report date.
  ({String value, Widget? badge, String? note}) _resolve(ThemeData theme) {
    if (candidates.isLoading) {
      return (value: l10n.loading, badge: null, note: null);
    }
    if (candidates.hasError) {
      return (value: '—', badge: null, note: null);
    }
    final items = candidates.value!.results
        .where((c) => c.date != null)
        .toList();
    if (items.isEmpty) {
      return (value: l10n.notDetected, badge: null, note: null);
    }
    final top = items.firstWhere(
      (c) => c.isSuggested,
      orElse: () => items.first,
    );
    return (
      value: localizedDate(l10n, top.date),
      badge: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          l10n.suggestedDate,
          style: TextStyle(
            fontSize: 11,
            color: theme.colorScheme.onTertiaryContainer,
          ),
        ),
      ),
      note: items.length > 1 ? l10n.possibleDatesDetected(items.length) : null,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
