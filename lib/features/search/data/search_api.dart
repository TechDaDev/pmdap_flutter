import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/archive.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/pagination.dart';

/// Search filters matching the frozen backend contract.
class SearchQuery {
  const SearchQuery({
    this.q,
    this.dateFrom,
    this.dateTo,
    this.year,
    this.month,
    this.documentType,
    this.healthcareFacilityId,
    this.department,
    this.physicianName,
    this.dateStatus,
    this.uploadedFrom,
    this.uploadedTo,
  });

  final String? q;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final int? year;
  final int? month;
  final MedicalDocumentType? documentType;
  final String? healthcareFacilityId;
  final String? department;
  final String? physicianName;
  final String? dateStatus;
  final DateTime? uploadedFrom;
  final DateTime? uploadedTo;

  Map<String, dynamic> toQueryParameters({int page = 1}) {
    String? fmt(DateTime? d) => d == null
        ? null
        : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    // Backend constraints, enforced client-side:
    // - UNCONFIRMED cannot combine with report-date/year/month filters
    // - month requires year
    // - date_from <= date_to; uploaded_from <= uploaded_to
    final unconfirmed = dateStatus == 'UNCONFIRMED';
    final reportDateFiltered = dateFrom != null || dateTo != null;
    final validDateRange =
        dateFrom == null || dateTo == null || !dateFrom!.isAfter(dateTo!);
    final validUploadRange =
        uploadedFrom == null ||
        uploadedTo == null ||
        !uploadedFrom!.isAfter(uploadedTo!);
    final effectiveYear = unconfirmed || reportDateFiltered ? null : year;
    final effectiveMonth = effectiveYear == null ? null : month;
    final sendDateFrom = !unconfirmed && validDateRange ? dateFrom : null;
    final sendDateTo = !unconfirmed && validDateRange ? dateTo : null;
    final sendUploadFrom = !unconfirmed && validUploadRange
        ? uploadedFrom
        : null;
    final sendUploadTo = !unconfirmed && validUploadRange ? uploadedTo : null;

    return {
      'page': page,
      if (q != null && q!.isNotEmpty) 'q': q,
      if (sendDateFrom != null) 'date_from': fmt(sendDateFrom),
      if (sendDateTo != null) 'date_to': fmt(sendDateTo),
      if (effectiveYear != null) 'year': effectiveYear,
      if (effectiveMonth != null) 'month': effectiveMonth,
      if (documentType != null && documentType != MedicalDocumentType.unknown)
        'document_type': documentType!.api,
      if (healthcareFacilityId != null)
        'healthcare_facility': healthcareFacilityId,
      if (department != null && department!.isNotEmpty)
        'department': department,
      if (physicianName != null && physicianName!.isNotEmpty)
        'physician_name': physicianName,
      if (sendUploadFrom != null) 'uploaded_from': fmt(sendUploadFrom),
      if (sendUploadTo != null) 'uploaded_to': fmt(sendUploadTo),
      if (dateStatus != null) 'date_status': dateStatus,
    };
  }
}

class SearchApi {
  SearchApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  /// Lexical search — never log the [SearchQuery.q] value.
  Future<Page<ArchiveDocument>> search(
    SearchQuery query, {
    int page = 1,
  }) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.search,
        queryParameters: query.toQueryParameters(page: page),
      );
      return decodePage(
        resp.data,
        Page<ArchiveDocument>.fromJson,
        ArchiveDocument.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
