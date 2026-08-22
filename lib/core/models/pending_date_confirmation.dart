import '../models/enums.dart';

/// One report unit awaiting date confirmation, from the report-unit queue
/// (`/documents/date-confirmations/pending/`).
///
/// The REPORT PAGE is the unit: a multi-page PDF contributes up to N entries
/// (one per page), each with its own candidates. A page appears even when OCR
/// found no date (`detectedCandidates` empty, `requiresManualDate` true).
class PendingDateConfirmation {
  const PendingDateConfirmation({
    required this.documentUuid,
    required this.documentType,
    required this.processingStatus,
    required this.createdAt,
    required this.detectedCandidates,
    required this.requiresManualDate,
    this.pageNumber = 1,
    this.pageCount = 1,
    this.reportSubtype = '',
  });

  final String documentUuid;
  final MedicalDocumentType documentType;
  final ProcessingStatus processingStatus;
  final DateTime createdAt;
  final List<PendingDateCandidate> detectedCandidates;
  final bool requiresManualDate;

  /// Page number of the report unit this entry refers to.
  final int pageNumber;

  /// Total page count of the source document.
  final int pageCount;

  /// Detected report subtype (layout metadata only).
  final String reportSubtype;

  bool get isMultiPage => pageCount > 1;

  factory PendingDateConfirmation.fromJson(Map<String, dynamic> json) {
    return PendingDateConfirmation(
      documentUuid: json['document_uuid'] as String? ?? '',
      documentType: MedicalDocumentType.fromApi(
        json['document_type'] as String?,
      ),
      processingStatus: ProcessingStatus.fromApi(
        json['processing_status'] as String?,
      ),
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      detectedCandidates: ((json['detected_candidates'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(PendingDateCandidate.fromJson)
          .toList(),
      requiresManualDate: json['requires_manual_date'] as bool? ?? true,
      pageNumber: json['page_number'] as int? ?? 1,
      pageCount: json['page_count'] as int? ?? 1,
      reportSubtype: json['report_subtype'] as String? ?? '',
    );
  }
}

/// Safe subset of a detected date candidate (never raw OCR text).
class PendingDateCandidate {
  const PendingDateCandidate({
    required this.uuid,
    required this.date,
    required this.confidence,
    required this.type,
    required this.ambiguous,
    required this.isSuggested,
  });

  final String uuid;
  final DateTime? date;
  final double confidence;
  final String type;
  final bool ambiguous;
  final bool isSuggested;

  factory PendingDateCandidate.fromJson(Map<String, dynamic> json) {
    return PendingDateCandidate(
      uuid: json['uuid'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? ''),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      type: json['type'] as String? ?? '',
      ambiguous: json['ambiguous'] as bool? ?? false,
      isSuggested: json['is_suggested'] as bool? ?? false,
    );
  }
}
