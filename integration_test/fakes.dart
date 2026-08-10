import 'package:dio/dio.dart';
import 'package:pmdap_mobile/core/models/archive.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/minor.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/core/models/patient.dart';
import 'package:pmdap_mobile/core/models/token_pair.dart';
import 'package:pmdap_mobile/core/models/user.dart';
import 'package:pmdap_mobile/core/storage/refresh_token_storage.dart';
import 'package:pmdap_mobile/features/archive/data/archive_api.dart';
import 'package:pmdap_mobile/features/auth/data/auth_api.dart';
import 'package:pmdap_mobile/features/documents/data/documents_api.dart';
import 'package:pmdap_mobile/features/minors/data/minors_api.dart';
import 'package:pmdap_mobile/features/patient/data/patient_api.dart';
import 'package:pmdap_mobile/features/search/data/search_api.dart';

class FakeRefreshStorage implements RefreshTokenStorage {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String token) async => value = token;
  @override
  Future<void> clear() async => value = null;
}

class FakeAuthApi extends AuthApi {
  FakeAuthApi() : super(Dio());

  @override
  Future<TokenPair> login({
    required String email,
    required String password,
  }) async {
    return const TokenPair(access: 'access', refresh: 'refresh');
  }

  @override
  Future<PublicUser> me() async => const PublicUser(
    uuid: 'u1',
    email: 'patient@example.com',
    role: Role.patient,
  );

  @override
  Future<void> logout(String refresh) async {}
}

class FakePatientApi extends PatientApi {
  FakePatientApi() : super(Dio());

  @override
  Future<PatientProfile> me() async => PatientProfile(
    uuid: 'p1',
    digitalId: '12345678901234567',
    fullName: 'Synthetic Patient',
    dateOfBirth: DateTime(1990, 5, 10),
    age: 36,
    isMinor: false,
    sex: Sex.male,
    nationality: 'IQ',
    bloodGroup: BloodGroup.aPos,
    identityStatus: IdentityStatus.verified,
  );
}

class FakeDocumentsApi extends DocumentsApi {
  FakeDocumentsApi() : super(Dio());

  @override
  Future<Page<MedicalDocument>> list({int page = 1}) async {
    return Page<MedicalDocument>(
      count: 1,
      next: null,
      previous: null,
      results: [
        MedicalDocument(
          uuid: 'd1',
          documentType: MedicalDocumentType.laboratory,
          classificationSource: ClassificationSource.systemDefault,
          title: 'Lab Report',
          description: 'Synthetic',
          documentDate: DateTime(2024, 3, 15),
          dateSource: DateSource.userConfirmed,
          dateVerified: true,
          facilityName: 'Central Lab',
          locationText: '',
          department: 'Hematology',
          physicianName: 'Dr X',
          processingStatus: ProcessingStatus.dateConfirmed,
          archiveStatus: ArchiveStatus.active,
        ),
      ],
    );
  }
}

class FakeArchiveApi extends ArchiveApi {
  FakeArchiveApi() : super(Dio());

  @override
  Future<ArchivePage<ArchiveDocument>> list(
    ArchiveQuery query, {
    int page = 1,
  }) async {
    return ArchivePage<ArchiveDocument>(
      count: 1,
      next: null,
      previous: null,
      results: [
        ArchiveDocument(
          uuid: 'a1',
          title: 'Archive Report',
          documentType: MedicalDocumentType.consultation,
          documentDate: DateTime(2023, 11, 2),
          dateVerified: true,
          dateSource: DateSource.userConfirmed,
          facilityName: 'City Clinic',
          locationText: '',
          department: 'General',
          physicianName: 'Dr Y',
          processingStatus: ProcessingStatus.dateConfirmed,
        ),
      ],
      unconfirmedDateCount: 0,
    );
  }

  @override
  Future<ArchiveSummary> summary() async => const ArchiveSummary();
}

class FakeSearchApi extends SearchApi {
  FakeSearchApi() : super(Dio());

  @override
  Future<Page<ArchiveDocument>> search(
    SearchQuery query, {
    int page = 1,
  }) async {
    return Page<ArchiveDocument>(
      count: 1,
      next: null,
      previous: null,
      results: [
        ArchiveDocument(
          uuid: 'a1',
          title: 'Archive Report',
          documentType: MedicalDocumentType.consultation,
          documentDate: DateTime(2023, 11, 2),
          dateVerified: true,
          dateSource: DateSource.userConfirmed,
          facilityName: 'City Clinic',
          locationText: '',
          department: 'General',
          physicianName: 'Dr Y',
          processingStatus: ProcessingStatus.dateConfirmed,
        ),
      ],
    );
  }
}

class FakeMinorsApi extends MinorsApi {
  FakeMinorsApi() : super(Dio());

  @override
  Future<Page<Minor>> list({int page = 1}) async {
    return Page<Minor>(
      count: 1,
      next: null,
      previous: null,
      results: [
        Minor(
          uuid: 'm1',
          digitalId: '98765432101234567',
          fullName: 'Synthetic Child',
          dateOfBirth: DateTime(2015, 8, 20),
          age: 10,
          isMinor: true,
          sex: Sex.female,
          nationality: 'IQ',
          bloodGroup: BloodGroup.oPos,
          identityStatus: IdentityStatus.pendingVerification,
          relationship: GuardianRelationship(
            uuid: 'r1',
            relationship: Relationship.father,
            verificationStatus: VerificationStatus.verified,
            active: true,
          ),
        ),
      ],
    );
  }
}
