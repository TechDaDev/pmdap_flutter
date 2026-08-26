import 'dart:typed_data';

import '../../../core/api/api_exception.dart';
import '../../../core/models/archive.dart';
import '../../../core/models/date_candidate.dart';
import '../../../core/models/document_page.dart';
import '../../../core/models/extracted_content.dart';
import '../../../core/models/lab_results.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/models/pagination.dart';
import '../../../core/models/pending_date_confirmation.dart';
import '../../archive/data/archive_api.dart';
import '../../archive/data/minor_archive_api.dart';
import '../../documents/data/documents_api.dart';
import '../../minors/data/minor_documents_api.dart';
import '../../search/data/minor_search_api.dart';
import '../../search/data/search_api.dart';
import '../domain/patient_context.dart';

/// Single selector for every self/minor medical route.
///
/// This chooses a URL family only. Backend authorization remains authoritative.
class MedicalRecordsRepository {
  MedicalRecordsRepository({
    required DocumentsApi documentsApi,
    required MinorDocumentsApi minorDocumentsApi,
    required ArchiveApi archiveApi,
    required MinorArchiveApi minorArchiveApi,
    required SearchApi searchApi,
    required MinorSearchApi minorSearchApi,
    required void Function(PatientContext context) onMinorAccessDenied,
  }) : _documents = documentsApi,
       _minorDocuments = minorDocumentsApi,
       _archive = archiveApi,
       _minorArchive = minorArchiveApi,
       _search = searchApi,
       _minorSearch = minorSearchApi,
       _onMinorAccessDenied = onMinorAccessDenied;

  final DocumentsApi _documents;
  final MinorDocumentsApi _minorDocuments;
  final ArchiveApi _archive;
  final MinorArchiveApi _minorArchive;
  final SearchApi _search;
  final MinorSearchApi _minorSearch;
  final void Function(PatientContext context) _onMinorAccessDenied;

  Future<T> _guard<T>(
    PatientContext context,
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on ApiException catch (error) {
      if (context.isMinor && (error.isForbidden || error.isNotFound)) {
        _onMinorAccessDenied(context);
      }
      rethrow;
    }
  }

  String _minor(PatientContext context) => context.minorUuid!;

  Future<Page<MedicalDocument>> listDocuments(PatientContext context) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.list(_minor(context))
        : _documents.list(),
  );

  Future<MedicalDocumentDetail> getDocument(
    PatientContext context,
    String uuid,
  ) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.detail(_minor(context), uuid)
        : _documents.detail(uuid),
  );

  Future<MedicalDocument> upload(
    PatientContext context,
    DocumentUploadInput input,
  ) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.upload(_minor(context), input)
        : _documents.upload(input),
  );

  Future<void> delete(PatientContext context, String uuid) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.delete(_minor(context), uuid)
        : _documents.delete(uuid),
  );

  Future<Uint8List> fetchFile(PatientContext context, String uuid) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.fetchFile(_minor(context), uuid)
        : _documents.fetchFile(uuid),
  );

  Future<LabResultsResponse> labResults(PatientContext context, String uuid) =>
      _guard(
        context,
        () => context.isMinor
            ? _minorDocuments.labResults(_minor(context), uuid)
            : _documents.labResults(uuid),
      );

  Future<ExtractedContentResponse> extractedContent(
    PatientContext context,
    String uuid,
  ) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.extractedContent(_minor(context), uuid)
        : _documents.extractedContent(uuid),
  );

  Future<Page<DateCandidate>> dateCandidates(
    PatientContext context,
    String uuid,
  ) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.dateCandidates(_minor(context), uuid)
        : _documents.dateCandidates(uuid),
  );

  Future<List<PendingDateConfirmation>> pendingDateConfirmations(
    PatientContext context,
  ) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.pendingDateConfirmations(_minor(context))
        : _documents.pendingDateConfirmations(),
  );

  Future<DocumentDateConfirmationResponse> confirmDate(
    PatientContext context,
    String uuid, {
    String? candidateId,
    DateTime? date,
  }) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.confirmDate(
            _minor(context),
            uuid,
            candidateId: candidateId,
            date: date,
          )
        : _documents.confirmDate(uuid, candidateId: candidateId, date: date),
  );

  Future<MedicalDocumentPageSummary> documentPages(
    PatientContext context,
    String uuid,
  ) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.documentPages(_minor(context), uuid)
        : _documents.documentPages(uuid),
  );

  Future<MedicalDocumentPageDetail> documentPageDetail(
    PatientContext context,
    String uuid,
    int pageNumber,
  ) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.documentPageDetail(_minor(context), uuid, pageNumber)
        : _documents.documentPageDetail(uuid, pageNumber),
  );

  Future<MedicalDocumentPageLabResults> pageLabResults(
    PatientContext context,
    String uuid,
    int pageNumber,
  ) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.pageLabResults(_minor(context), uuid, pageNumber)
        : _documents.pageLabResults(uuid, pageNumber),
  );

  Future<MedicalDocumentPageDetail> confirmPageDate(
    PatientContext context,
    String uuid,
    int pageNumber, {
    String? candidateId,
    DateTime? date,
  }) => _guard(
    context,
    () => context.isMinor
        ? _minorDocuments.confirmPageDate(
            _minor(context),
            uuid,
            pageNumber,
            candidateId: candidateId,
            date: date,
          )
        : _documents.confirmPageDate(
            uuid,
            pageNumber,
            candidateId: candidateId,
            date: date,
          ),
  );

  Future<ArchivePage<ArchiveDocument>> archive(
    PatientContext context,
    ArchiveQuery query,
  ) => _guard(
    context,
    () => context.isMinor
        ? _minorArchive.list(_minor(context), query)
        : _archive.list(query),
  );

  Future<ArchiveSummary> archiveSummary(PatientContext context) => _guard(
    context,
    () => context.isMinor
        ? _minorArchive.summary(_minor(context))
        : _archive.summary(),
  );

  Future<Page<ArchiveDocument>> search(
    PatientContext context,
    SearchQuery query,
  ) => _guard(
    context,
    () => context.isMinor
        ? _minorSearch.search(_minor(context), query)
        : _search.search(query),
  );
}
