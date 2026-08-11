import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/minor.dart';
import '../../../core/models/pagination.dart';
import '../../../core/utils/date_utils.dart';

class MinorCreateSubmission {
  const MinorCreateSubmission({
    required this.fullName,
    required this.dateOfBirth,
    required this.sex,
    required this.nationality,
    this.bloodGroup = BloodGroup.unknown,
    required this.relationship,
    required this.documentType,
    required this.documentNumber,
    this.nationalNumber = '',
    this.familyNumber = '',
    this.issuingCountry,
    this.issueDate,
    this.expiryDate,
    required this.frontPath,
    required this.frontFilename,
    this.backPath,
    this.backFilename,
    this.evidenceType,
    this.evidencePath,
    this.evidenceFilename,
  });

  final String fullName;
  final DateTime? dateOfBirth;
  final Sex sex;
  final String nationality;
  final BloodGroup bloodGroup;
  final Relationship relationship;
  final IdentityDocumentType documentType;
  final String documentNumber;
  final String nationalNumber;
  final String familyNumber;

  /// Document issuing country — a separate field from child nationality.
  final String? issuingCountry;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String frontPath;
  final String frontFilename;
  final String? backPath;
  final String? backFilename;

  /// Guardian evidence is optional for father/mother and required for a legal
  /// guardian. Evidence type and file must be supplied together.
  final EvidenceType? evidenceType;
  final String? evidencePath;
  final String? evidenceFilename;

  /// True when the payload has both (or neither) evidence parts.
  bool get evidenceComplete => (evidenceType == null) == (evidencePath == null);
}

class MinorsApi {
  MinorsApi(this._dio);

  final Dio _dio;
  final ApiErrorMapper _mapper = const ApiErrorMapper();

  Future<Page<Minor>> list({int page = 1}) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.minors,
        queryParameters: {'page': page},
      );
      return decodePage(resp.data, Page<Minor>.fromJson, Minor.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<Minor> detail(String uuid) async {
    try {
      final resp = await _dio.get<dynamic>(ApiPaths.minorDetail(uuid));
      return decodeData<Minor>(resp.data, Minor.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  /// Create a minor. The `Idempotency-Key` header is required by the backend.
  Future<MinorCreateResponse> create(
    MinorCreateSubmission s, {
    required String idempotencyKey,
  }) async {
    try {
      final form = FormData.fromMap({
        'full_name': s.fullName,
        'date_of_birth': formatApiDate(s.dateOfBirth),
        'sex': s.sex.api,
        'nationality': s.nationality,
        if (s.bloodGroup != BloodGroup.unknown) 'blood_group': s.bloodGroup.api,
        'relationship': s.relationship.api,
        'document_type': s.documentType.api,
        'document_number': s.documentNumber,
        'national_number': s.nationalNumber,
        'family_number': s.familyNumber,
        if (s.issuingCountry != null && s.issuingCountry!.isNotEmpty)
          'issuing_country': s.issuingCountry,
        if (s.issueDate != null) 'issue_date': formatApiDate(s.issueDate),
        if (s.expiryDate != null) 'expiry_date': formatApiDate(s.expiryDate),
        'front_image': await MultipartFile.fromFile(
          s.frontPath,
          filename: s.frontFilename,
        ),
        if (s.backPath != null)
          'back_image': await MultipartFile.fromFile(
            s.backPath!,
            filename: s.backFilename ?? 'back',
          ),
        // Evidence is optional (father/mother); when present, type + file are
        // always sent together, never one without the other.
        if (s.evidencePath != null && s.evidenceType != null)
          'evidence_type': s.evidenceType!.api,
        if (s.evidencePath != null)
          'evidence_file': await MultipartFile.fromFile(
            s.evidencePath!,
            filename: s.evidenceFilename ?? 'evidence',
          ),
      });
      final resp = await _dio.post<dynamic>(
        ApiPaths.minors,
        data: form,
        options: Options(headers: {'Idempotency-Key': idempotencyKey}),
      );
      return decodeData<MinorCreateResponse>(
        resp.data,
        MinorCreateResponse.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
