import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/archive.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/pagination.dart';

/// Archive filters mirroring the frozen backend contract.
class ArchiveQuery {
  const ArchiveQuery({
    this.year,
    this.month,
    this.documentType,
    this.healthcareFacilityId,
    this.dateStatus,
  });

  final int? year;
  final int? month;
  final MedicalDocumentType? documentType;
  final String? healthcareFacilityId;

  /// VERIFIED | UNCONFIRMED (dates needing confirmation).
  final String? dateStatus;

  Map<String, dynamic> toQueryParameters({int page = 1}) => {
    'page': page,
    if (year != null) 'year': year,
    if (month != null) 'month': month,
    if (documentType != null && documentType != MedicalDocumentType.unknown)
      'document_type': documentType!.api,
    if (healthcareFacilityId != null)
      'healthcare_facility': healthcareFacilityId,
    if (dateStatus != null) 'date_status': dateStatus,
  };
}

class ArchiveApi {
  ArchiveApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  Future<ArchivePage<ArchiveDocument>> list(
    ArchiveQuery query, {
    int page = 1,
  }) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.archive,
        queryParameters: query.toQueryParameters(page: page),
      );
      return decodePage(
        resp.data,
        ArchivePage<ArchiveDocument>.fromJson,
        ArchiveDocument.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<ArchiveSummary> summary() async {
    try {
      final resp = await _dio.get<dynamic>(ApiPaths.archiveSummary);
      return decodeData<ArchiveSummary>(resp.data, ArchiveSummary.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
