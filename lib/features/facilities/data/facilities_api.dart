import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/facility.dart';
import '../../../core/models/pagination.dart';

class FacilitiesApi {
  FacilitiesApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  Future<Page<HealthcareFacility>> list({
    bool? active,
    String? country,
    String? region,
    String? city,
    FacilityType? type,
    int page = 1,
  }) async {
    try {
      final qp = <String, dynamic>{
        'page': page,
        if (active != null) 'active': active,
        if (country != null && country.isNotEmpty) 'country': country,
        if (region != null && region.isNotEmpty) 'region': region,
        if (city != null && city.isNotEmpty) 'city': city,
        if (type != null && type != FacilityType.unknown) 'type': type.api,
      };
      final resp = await _dio.get<dynamic>(
        ApiPaths.facilities,
        queryParameters: qp,
      );
      ensureData(resp.data);
      final pageJson =
          (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return Page<HealthcareFacility>.fromJson(
        pageJson,
        HealthcareFacility.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<HealthcareFacility> detail(String uuid) async {
    try {
      final resp = await _dio.get<dynamic>(ApiPaths.facilityDetail(uuid));
      return decodeData<HealthcareFacility>(
        resp.data,
        HealthcareFacility.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
