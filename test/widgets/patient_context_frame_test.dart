import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/features/medical_context/application/patient_context_controller.dart';
import 'package:pmdap_mobile/features/medical_context/domain/patient_context.dart';
import 'package:pmdap_mobile/features/medical_context/presentation/patient_context_frame.dart';

import '../helpers/pump.dart';

class _SeededContextController extends PatientContextController {
  @override
  PatientContextState build() => const PatientContextState(
    context: PatientContext.minor(
      relationshipUuid: 'relationship-a',
      minorUuid: 'minor-a',
      safeDisplayName: 'طفل تجريبي ذو اسم طويل للاختبار',
    ),
  );
}

void main() {
  testWidgets('Arabic child banner and exit semantics fit 360x640', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      pumpApp(
        const PatientContextFrame(child: Scaffold(body: Text('content'))),
        locale: const Locale('ar'),
        themeMode: ThemeMode.dark,
        overrides: [
          patientContextControllerProvider.overrideWith(
            _SeededContextController.new,
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('عرض السجلات'), findsOneWidget);
    expect(find.text('العودة إلى سجلاتي'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
