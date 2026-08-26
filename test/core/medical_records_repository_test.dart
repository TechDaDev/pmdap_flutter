import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/pagination.dart';
import 'package:pmdap_mobile/features/archive/data/archive_api.dart';
import 'package:pmdap_mobile/features/archive/data/minor_archive_api.dart';
import 'package:pmdap_mobile/features/documents/data/documents_api.dart';
import 'package:pmdap_mobile/features/medical_context/data/medical_records_repository.dart';
import 'package:pmdap_mobile/features/medical_context/domain/patient_context.dart';
import 'package:pmdap_mobile/features/minors/data/minor_documents_api.dart';
import 'package:pmdap_mobile/features/search/data/minor_search_api.dart';
import 'package:pmdap_mobile/features/search/data/search_api.dart';

const _emptyDocuments = Page<MedicalDocument>(
  count: 0,
  next: null,
  previous: null,
  results: [],
);

class _SelfDocumentsApi extends DocumentsApi {
  _SelfDocumentsApi() : super(Dio());
  int listCalls = 0;

  @override
  Future<Page<MedicalDocument>> list({int page = 1}) async {
    listCalls++;
    return _emptyDocuments;
  }
}

class _ChildDocumentsApi extends MinorDocumentsApi {
  _ChildDocumentsApi({this.denied = false}) : super(Dio());
  final bool denied;
  final minorUuids = <String>[];

  @override
  Future<Page<MedicalDocument>> list(String minorUuid, {int page = 1}) async {
    minorUuids.add(minorUuid);
    if (denied) {
      throw const ApiException(
        statusCode: 404,
        code: 'not_found',
        message: 'Not found.',
      );
    }
    return _emptyDocuments;
  }
}

MedicalRecordsRepository _repository({
  required DocumentsApi self,
  required MinorDocumentsApi child,
  void Function(PatientContext)? onDenied,
}) => MedicalRecordsRepository(
  documentsApi: self,
  minorDocumentsApi: child,
  archiveApi: ArchiveApi(Dio()),
  minorArchiveApi: MinorArchiveApi(Dio()),
  searchApi: SearchApi(Dio()),
  minorSearchApi: MinorSearchApi(Dio()),
  onMinorAccessDenied: onDenied ?? (_) {},
);

void main() {
  const selfContext = PatientContext.self();
  const childContext = PatientContext.minor(
    relationshipUuid: 'relationship-a',
    minorUuid: 'minor-a',
    safeDisplayName: 'Synthetic Child A',
  );

  test('context centrally selects self or minor document API', () async {
    final self = _SelfDocumentsApi();
    final child = _ChildDocumentsApi();
    final repository = _repository(self: self, child: child);

    await repository.listDocuments(selfContext);
    expect(self.listCalls, 1);
    expect(child.minorUuids, isEmpty);

    await repository.listDocuments(childContext);
    expect(self.listCalls, 1);
    expect(child.minorUuids, ['minor-a']);
  });

  test('minor 404 triggers safe-exit callback and is still surfaced', () async {
    PatientContext? deniedContext;
    final repository = _repository(
      self: _SelfDocumentsApi(),
      child: _ChildDocumentsApi(denied: true),
      onDenied: (context) => deniedContext = context,
    );

    await expectLater(
      repository.listDocuments(childContext),
      throwsA(isA<ApiException>()),
    );
    expect(deniedContext, childContext);
  });
}
