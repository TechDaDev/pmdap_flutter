import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error_mapper.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/guardian_relationship_summary.dart';
import '../../../core/models/minor.dart';
import '../../../core/models/pagination.dart';
import '../../../core/utils/date_utils.dart';
import '../../identity/data/identity_image_part.dart';

class MinorCreateSubmission {
  const MinorCreateSubmission({
    required this.firstName,
    this.fatherName = '',
    this.grandfatherName = '',
    required this.dateOfBirth,
    required this.sex,
    required this.nationality,
    this.bloodGroup = BloodGroup.unknown,
    required this.relationship,
    required this.documentType,
    this.documentNumber = '',
    this.nationalNumber = '',
    this.extractionJobId,
    this.issuingCountry,
    this.issueDate,
    this.expiryDate,
    this.frontPath,
    this.frontFilename,
    this.backPath,
    this.backFilename,
    this.evidenceType,
    this.evidencePath,
    this.evidenceFilename,
  });

  final String firstName;
  final String fatherName;
  final String grandfatherName;
  String get displayName => [
    firstName,
    fatherName,
    grandfatherName,
  ].where((part) => part.trim().isNotEmpty).join(' ');
  final DateTime? dateOfBirth;
  final Sex sex;
  final String nationality;
  final BloodGroup bloodGroup;
  final Relationship relationship;
  final IdentityDocumentType documentType;
  final String documentNumber;
  final String nationalNumber;
  final String? extractionJobId;

  /// Document issuing country — a separate field from child nationality.
  final String? issuingCountry;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String? frontPath;
  final String? frontFilename;
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
        'full_name': s.displayName,
        'name': s.firstName,
        if (s.fatherName.isNotEmpty) 'father_name': s.fatherName,
        if (s.grandfatherName.isNotEmpty) 'grandfather_name': s.grandfatherName,
        'date_of_birth': formatApiDate(s.dateOfBirth),
        'sex': s.sex.api,
        'nationality': s.nationality,
        if (s.bloodGroup != BloodGroup.unknown) 'blood_group': s.bloodGroup.api,
        'relationship': s.relationship.api,
        'document_type': s.documentType.api,
        if (s.extractionJobId != null) 'extraction_job_id': s.extractionJobId,
        if (s.extractionJobId == null) 'document_number': s.documentNumber,
        if (s.extractionJobId == null) 'national_number': s.nationalNumber,
        if (s.issuingCountry != null && s.issuingCountry!.isNotEmpty)
          'issuing_country': s.issuingCountry,
        if (s.issueDate != null) 'issue_date': formatApiDate(s.issueDate),
        if (s.expiryDate != null) 'expiry_date': formatApiDate(s.expiryDate),
        if (s.extractionJobId == null && s.frontPath != null)
          'front_image': await identityMultipartFile(
            s.frontPath!,
            side: 'front',
          ),
        if (s.extractionJobId == null && s.backPath != null)
          'back_image': await identityMultipartFile(s.backPath!, side: 'back'),
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

  Future<Page<GuardianRelationshipSummary>> relationships({
    int page = 1,
  }) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.guardianRelationships,
        queryParameters: {'page': page},
      );
      return decodePage(
        resp.data,
        Page<GuardianRelationshipSummary>.fromJson,
        GuardianRelationshipSummary.fromJson,
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<GuardianRelationshipSummary> relationshipDetail(String uuid) async {
    try {
      final resp = await _dio.get<dynamic>(
        ApiPaths.guardianRelationshipDetail(uuid),
      );
      return decodeData(resp.data, GuardianRelationshipSummary.fromJson);
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }

  Future<void> revokeRelationship(String uuid) async {
    try {
      await _dio.post<dynamic>(
        ApiPaths.guardianRelationshipRevoke(uuid),
        data: const {'reason': 'Revoked by guardian'},
      );
    } on DioException catch (e) {
      throw _mapper.map(e);
    }
  }
}
