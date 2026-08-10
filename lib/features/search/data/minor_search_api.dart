import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/archive.dart';
import '../../../core/models/pagination.dart';
import 'search_api.dart';

/// Lexical search scoped to a minor (guardian flow).
class MinorSearchApi {
  MinorSearchApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  Future<Page<ArchiveDocument>> search(
    String minorUuid,
    SearchQuery query, {
    int page = 1,
  }) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minorSearch(minorUuid),
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
