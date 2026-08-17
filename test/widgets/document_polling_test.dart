import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/date_candidate.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/medical_document.dart';
import 'package:pmdap_mobile/core/models/pagination.dart' as pag;
import 'package:pmdap_mobile/features/documents/application/documents_providers.dart';
import 'package:pmdap_mobile/features/documents/data/documents_api.dart';
import 'package:pmdap_mobile/features/documents/presentation/document_detail_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

class _FakeDocumentsApi extends DocumentsApi {
  _FakeDocumentsApi(this._doc) : super(Dio());

  MedicalDocumentDetail _doc;
  int detailCalls = 0;
  int uploadCalls = 0;

  @override
  Future<MedicalDocumentDetail> detail(String uuid) async {
    detailCalls++;
    return _doc;
  }

  @override
  Future<pag.Page<DateCandidate>> dateCandidates(
    String uuid, {
    int page = 1,
  }) async {
    return pag.Page<DateCandidate>(
      count: 0,
      next: null,
      previous: null,
      results: const [],
    );
  }

  @override
  Future<MedicalDocument> upload(DocumentUploadInput input) async {
    uploadCalls++;
    throw UnimplementedError('polling must never trigger an upload');
  }
}

/// Watches the adult document list so provider invalidation is observable.
class _ListProbe extends ConsumerWidget {
  const _ListProbe();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(documentsProvider);
    return const SizedBox.shrink();
  }
}

pag.Page<MedicalDocument> _emptyPage() =>
    pag.Page(count: 0, next: null, previous: null, results: const []);

/// Renders a couple of frames without waiting for (active) poll timers to
/// settle. pumpAndSettle would hang while a poll timer is armed.
Future<void> _pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('polls while processing, then terminal stops polling', (
    tester,
  ) async {
    final api = _FakeDocumentsApi(
      sampleDocumentDetail(processing: ProcessingStatus.processing),
    );
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await _pumpFrames(tester);
    final callsAtStart = api.detailCalls;
    expect(callsAtStart, greaterThan(0));

    // While processing, the 3s poll timer fires and refetches.
    await tester.pump(const Duration(seconds: 3));
    await _pumpFrames(tester);
    expect(api.detailCalls, greaterThan(callsAtStart));

    // Backend completes -> terminal state on the next poll.
    api._doc = sampleDocumentDetail(
      processing: ProcessingStatus.awaitingConfirmation,
    );
    await tester.pump(const Duration(seconds: 3));
    await _pumpFrames(tester);
    expect(find.text('Awaiting confirmation'), findsOneWidget);

    // Terminal: no further polling.
    final callsAtTerminal = api.detailCalls;
    await tester.pump(const Duration(seconds: 30));
    await _pumpFrames(tester);
    expect(api.detailCalls, callsAtTerminal);
    // Polling must never create a second document.
    expect(api.uploadCalls, 0);
  });

  testWidgets('PROCESSING -> FAILED shows failure label and stops polling', (
    tester,
  ) async {
    final api = _FakeDocumentsApi(
      sampleDocumentDetail(processing: ProcessingStatus.processing),
    );
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await _pumpFrames(tester);

    api._doc = sampleDocumentDetail(processing: ProcessingStatus.failed);
    await tester.pump(const Duration(seconds: 3));
    await _pumpFrames(tester);
    expect(find.text('Failed'), findsOneWidget);

    final calls = api.detailCalls;
    await tester.pump(const Duration(seconds: 30));
    await _pumpFrames(tester);
    expect(api.detailCalls, calls);
  });

  testWidgets('screen disposed stops polling', (tester) async {
    final api = _FakeDocumentsApi(
      sampleDocumentDetail(processing: ProcessingStatus.ocrProcessing),
    );
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1'),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await _pumpFrames(tester);
    final calls = api.detailCalls;

    // Leave the screen (replace with an empty scaffold).
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 30));
    await _pumpFrames(tester);
    expect(api.detailCalls, calls);
  });

  testWidgets('hard deadline stops polling and shows still-processing note', (
    tester,
  ) async {
    var fakeNow = DateTime(2026, 1, 1, 0, 0, 0);
    final api = _FakeDocumentsApi(
      sampleDocumentDetail(processing: ProcessingStatus.ocrProcessing),
    );
    await tester.pumpWidget(
      pumpApp(
        DocumentDetailScreen(uuid: 'd1', clock: () => fakeNow),
        overrides: [documentsApiProvider.overrideWithValue(api)],
      ),
    );
    await _pumpFrames(tester);

    // Advance past the 5-minute deadline (fake clock + fake timers together).
    for (var i = 0; i < 105; i++) {
      fakeNow = fakeNow.add(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 3));
    }
    await _pumpFrames(tester);

    // Deadline message shown; polling stopped.
    expect(find.textContaining('still being processed'), findsOneWidget);
    final calls = api.detailCalls;
    await tester.pump(const Duration(seconds: 30));
    await _pumpFrames(tester);
    expect(api.detailCalls, calls);
  });

  testWidgets('app resume re-arms polling and refreshes list views', (
    tester,
  ) async {
    var listFetches = 0;
    final api = _FakeDocumentsApi(
      sampleDocumentDetail(processing: ProcessingStatus.ocrProcessing),
    );
    await tester.pumpWidget(
      pumpApp(
        const Column(
          children: [
            _ListProbe(),
            Expanded(child: DocumentDetailScreen(uuid: 'd1')),
          ],
        ),
        overrides: [
          documentsApiProvider.overrideWithValue(api),
          documentsProvider.overrideWith((ref) {
            listFetches++;
            return _emptyPage();
          }),
        ],
      ),
    );
    await _pumpFrames(tester);
    final fetchesBeforeResume = listFetches;
    final detailBeforeResume = api.detailCalls;

    // Background then resume: observer re-arms polling + invalidates lists.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await _pumpFrames(tester);

    // Resume invalidated the watched list -> refetch happened.
    expect(listFetches, greaterThan(fetchesBeforeResume));
    // Resume re-armed the 3s poll -> next tick refetches detail.
    await tester.pump(const Duration(seconds: 3));
    await _pumpFrames(tester);
    expect(api.detailCalls, greaterThan(detailBeforeResume));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await _pumpFrames(tester);
  });
}
