import '../models/enums.dart';

/// One document awaiting date confirmation, from the document-centric queue
/// (`/documents/date-confirmations/pending/`).
///
/// The DOCUMENT is the unit: it appears even when OCR found no date
/// (`detectedCandidates` empty, `requiresManualDate` true).
class PendingDateConfirmation {
  const PendingDateConfirmation({
    required this.documentUuid,
    required this.documentType,
    required this.processingStatus,
    required this.createdAt,
    required this.detectedCandidates,
    required this.requiresManualDate,
  });

  final String documentUuid;
  final MedicalDocumentType documentType;
  final ProcessingStatus processingStatus;
  final DateTime createdAt;
  final List<PendingDateCandidate> detectedCandidates;
  final bool requiresManualDate;

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
