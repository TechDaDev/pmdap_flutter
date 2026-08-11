import 'dart:typed_data';

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

  /// Fetch the private avatar as authenticated raw image bytes.
  ///
  /// Authorization comes from the shared [AuthInterceptor] — never passed
  /// around screens. The response is binary, not the JSON envelope, so it is
  /// read directly with `ResponseType.bytes` (no [decodeData]).
  ///
  /// Throws mapped [ApiException] (e.g. 404/503); callers decide fallback.
  Future<Uint8List> fetchAvatar() async {
    try {
      final resp = await _dio.get<List<int>>(
        ApiPaths.patientAvatar,
        options: Options(responseType: ResponseType.bytes),
      );
      final data = resp.data;
      if (data is Uint8List) return data;
      return Uint8List.fromList(data ?? const []);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Upload/replace the avatar (multipart PATCH). Sends only the avatar field.
  Future<PatientProfile> updateAvatar({
    required String filePath,
    required String filename,
  }) async {
    try {
      final form = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath, filename: filename),
      });
      final resp = await _dio.patch<dynamic>(ApiPaths.patientsMe, data: form);
      return decodeData<PatientProfile>(resp.data, PatientProfile.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Clear the avatar. Backend serializer accepts `avatar: null`; sent as JSON
  /// (DRF multipart cannot reliably represent null).
  Future<PatientProfile> removeAvatar() async {
    try {
      final resp = await _dio.patch<dynamic>(
        ApiPaths.patientsMe,
        data: {'avatar': null},
      );
      return decodeData<PatientProfile>(resp.data, PatientProfile.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
