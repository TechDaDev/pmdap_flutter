import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/patient.dart';
import '../../../core/utils/date_utils.dart';

class PatientApi {
  PatientApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  Future<PatientProfile> me() async {
    try {
      final resp = await _dio.get<dynamic>(ApiPaths.patientsMe);
      return decodeData<PatientProfile>(resp.data, PatientProfile.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Update allowed editable fields only (PATCH).
  Future<PatientProfile> update({
    String? fullName,
    DateTime? dateOfBirth,
    Sex? sex,
    String? nationality,
    BloodGroup? bloodGroup,
  }) async {
    try {
      final body = <String, dynamic>{
        if (fullName != null) 'full_name': fullName,
        if (dateOfBirth != null) 'date_of_birth': formatApiDate(dateOfBirth),
        if (sex != null) 'sex': sex.api,
        if (nationality != null) 'nationality': nationality,
        if (bloodGroup != null) 'blood_group': bloodGroup.api,
      };
      final resp = await _dio.patch<dynamic>(ApiPaths.patientsMe, data: body);
      return decodeData<PatientProfile>(resp.data, PatientProfile.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
