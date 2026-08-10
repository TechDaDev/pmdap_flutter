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

  Map<String, dynamic> toQueryParameters({int page = 1}) {
    String? fmt(DateTime? d) => d == null
        ? null
        : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return {
      'page': page,
      if (q != null && q!.isNotEmpty) 'q': q,
      if (dateFrom != null) 'date_from': fmt(dateFrom),
      if (dateTo != null) 'date_to': fmt(dateTo),
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (documentType != null && documentType != MedicalDocumentType.unknown)
        'document_type': documentType!.api,
      if (healthcareFacilityId != null)
        'healthcare_facility': healthcareFacilityId,
      if (department != null && department!.isNotEmpty)
        'department': department,
      if (physicianName != null && physicianName!.isNotEmpty)
        'physician_name': physicianName,
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
      ensureData(resp.data);
      final pageJson =
          (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return Page<ArchiveDocument>.fromJson(pageJson, ArchiveDocument.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
