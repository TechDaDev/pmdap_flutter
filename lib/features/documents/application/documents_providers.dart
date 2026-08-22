import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/date_candidate.dart';
import '../../../core/models/document_page.dart';
import '../../../core/models/extracted_content.dart';
import '../../../core/models/lab_results.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/models/pagination.dart';
import '../../../core/models/pending_date_confirmation.dart';
import '../../archive/application/archive_providers.dart';
import '../data/medical_image_optimizer.dart';

/// Native medical image optimizer (client-side performance layer). Server
/// validation remains authoritative; this only prepares a smaller derivative.
final medicalImageOptimizerProvider = Provider<MedicalImageOptimizer>(
  (ref) => NativeMedicalImageOptimizer(),
);

/// Force all medical-document list/derived views to refetch so a terminal OCR
/// status (AWAITING_CONFIRMATION etc.) is reflected everywhere — home recent
/// documents, archive, date-confirmation count — without app restart.
///
/// Invalidating a family provider refreshes every instance (all archive
/// scopes, all date-candidate sets). Safe to call repeatedly; providers that
/// are not currently watched do no network work until next read.
void invalidateMedicalDocumentLists(WidgetRef ref) {
  ref.invalidate(documentsProvider);
  ref.invalidate(archiveProvider);
  ref.invalidate(archiveSummaryProvider);
  ref.invalidate(dateCandidatesProvider);
  ref.invalidate(minorDateCandidatesProvider);
  ref.invalidate(pendingDateConfirmationDocumentsProvider);
  ref.invalidate(minorPendingDateConfirmationDocumentsProvider);
  // Structured lab results follow the document-processing lifecycle.
  ref.invalidate(labResultsProvider);
  ref.invalidate(minorLabResultsProvider);
  // Page report units + page lab results follow the same lifecycle.
  ref.invalidate(documentPagesProvider);
  ref.invalidate(documentPageDetailProvider);
  ref.invalidate(documentPageLabResultsProvider);
  // Extracted narrative content follows the same lifecycle.
  ref.invalidate(extractedContentProvider);
  ref.invalidate(minorExtractedContentProvider);
}

final documentsProvider = FutureProvider.autoDispose<Page<MedicalDocument>>(
  (ref) => ref.watch(documentsApiProvider).list(),
);

/// Document-centric date-confirmation queue. Single source for BOTH the Home
/// badge count and the Confirm Dates page — one provider, no drift.
final pendingDateConfirmationDocumentsProvider =
    FutureProvider.autoDispose<List<PendingDateConfirmation>>(
      (ref) => ref.watch(documentsApiProvider).pendingDateConfirmations(),
    );

final documentDetailProvider = FutureProvider.autoDispose
    .family<MedicalDocumentDetail, String>(
      (ref, uuid) => ref.watch(documentsApiProvider).detail(uuid),
    );

/// Structured lab results for one owned document (read-only, memory-only).
final labResultsProvider = FutureProvider.autoDispose
    .family<LabResultsResponse, String>(
      (ref, uuid) => ref.watch(documentsApiProvider).labResults(uuid),
    );

/// Minor-scoped structured lab results (guardian flow).
final minorLabResultsProvider = FutureProvider.autoDispose
    .family<LabResultsResponse, ({String minorUuid, String documentUuid})>(
      (ref, args) => ref
          .watch(minorDocumentsApiProvider)
          .labResults(args.minorUuid, args.documentUuid),
    );

/// Extracted content (narrative sections) for one owned document.
final extractedContentProvider = FutureProvider.autoDispose
    .family<ExtractedContentResponse, String>(
      (ref, uuid) => ref.watch(documentsApiProvider).extractedContent(uuid),
    );

/// Minor-scoped extracted content (guardian flow).
final minorExtractedContentProvider = FutureProvider.autoDispose
    .family<
      ExtractedContentResponse,
      ({String minorUuid, String documentUuid})
    >(
      (ref, args) => ref
          .watch(minorDocumentsApiProvider)
          .extractedContent(args.minorUuid, args.documentUuid),
    );

final dateCandidatesProvider = FutureProvider.autoDispose
    .family<Page<DateCandidate>, String>(
      (ref, uuid) => ref.watch(documentsApiProvider).dateCandidates(uuid),
    );

/// Report-unit summary for one owned document (multi-page PDFs).
final documentPagesProvider = FutureProvider.autoDispose
    .family<MedicalDocumentPageSummary, String>(
      (ref, uuid) => ref.watch(documentsApiProvider).documentPages(uuid),
    );

/// One report page unit detail (own candidates + lab results).
final documentPageDetailProvider = FutureProvider.autoDispose
    .family<MedicalDocumentPageDetail, ({String uuid, int pageNumber})>(
      (ref, args) => ref
          .watch(documentsApiProvider)
          .documentPageDetail(args.uuid, args.pageNumber),
    );

/// Structured lab results for ONE report page (owner-only).
final documentPageLabResultsProvider = FutureProvider.autoDispose
    .family<MedicalDocumentPageLabResults, ({String uuid, int pageNumber})>(
      (ref, args) => ref
          .watch(documentsApiProvider)
          .pageLabResults(args.uuid, args.pageNumber),
    );

/// Minor-scoped date-candidate page (guardian flow). Same authoritative
/// candidate source as the adult provider — both hit
/// `document.date_candidates.filter(is_current=True)`.
final minorDateCandidatesProvider = FutureProvider.autoDispose
    .family<Page<DateCandidate>, ({String minorUuid, String documentUuid})>(
      (ref, args) => ref
          .watch(minorDocumentsApiProvider)
          .dateCandidates(args.minorUuid, args.documentUuid),
    );

/// Minor-scoped date-confirmation queue (guardian flow).
final minorPendingDateConfirmationDocumentsProvider = FutureProvider.autoDispose
    .family<List<PendingDateConfirmation>, String>(
      (ref, minorUuid) => ref
          .watch(minorDocumentsApiProvider)
          .pendingDateConfirmations(minorUuid),
    );
