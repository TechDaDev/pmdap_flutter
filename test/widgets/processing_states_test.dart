import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/features/documents/data/documents_api.dart';
import 'package:pmdap_mobile/features/documents/presentation/document_detail_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

class _FakeDocumentsApi extends DocumentsApi {
  _FakeDocumentsApi(this._detail) : super(Dio());

  final MedicalDocumentDetail _detail;
  int detailCalls = 0;
  bool deleted = false;

  @override
  Future<MedicalDocumentDetail> detail(String uuid) async {
    detailCalls++;
    return _detail;
  }

  @override
  Future<void> delete(String uuid) async {
    deleted = true;
  }
}

void main() {
  testWidgets('awaiting-confirmation shows confirm date action', (
    tester,
  ) async {
    final api = _FakeDocumentsApi(
      sampleDocumentDetail(processing: ProcessingStatus.awaitingConfirmation),
    );
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Confirm date'), findsOneWidget);
    expect(find.text('Awaiting confirmation'), findsOneWidget);
    // No polling timer for terminal/actionable states.
  });

  testWidgets('failed status shows failure label, no confirm action', (
    tester,
  ) async {
    final api = _FakeDocumentsApi(
      sampleDocumentDetail(processing: ProcessingStatus.failed),
    );
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Failed'), findsOneWidget);
    expect(find.text('Confirm date'), findsNothing);
  });

  testWidgets('delete requires confirmation and removes', (tester) async {
    final api = _FakeDocumentsApi(sampleDocumentDetail());
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Delete document'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete document'));
    await tester.pumpAndSettle();
    expect(
      find.text('Delete this document from your archive?'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(api.deleted, isTrue);
  });
}
