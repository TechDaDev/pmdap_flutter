import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/archive.dart';
import '../../../core/models/pagination.dart';
import 'archive_api.dart';

/// Archive operations scoped to a minor (guardian flow).
class MinorArchiveApi {
  MinorArchiveApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  Future<ArchivePage<ArchiveDocument>> list(
    String minorUuid,
    ArchiveQuery query, {
    int page = 1,
  }) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorArchive(minorUuid),
        queryParameters: query.toQueryParameters(page: page),
      );
      ensureData(resp.data);
      final pageJson =
          (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return ArchivePage<ArchiveDocument>.fromJson(
        pageJson,
        ArchiveDocument.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<ArchiveSummary> summary(String minorUuid) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorArchiveSummary(minorUuid),
      );
      return decodeData<ArchiveSummary>(resp.data, ArchiveSummary.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
