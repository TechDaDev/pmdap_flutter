import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/widgets/patient_avatar.dart';
import 'package:pmdap_mobile/features/patient/application/patient_providers.dart';
import 'package:pmdap_mobile/features/patient/presentation/profile_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump.dart';

/// Minimal valid 1x1 transparent PNG.
final Uint8List _validPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
);

void main() {
  group('PatientAvatar', () {
    testWidgets('no avatarUrl -> initials fallback', (tester) async {
      await tester.pumpWidget(
        pumpApp(
          Material(
            child: PatientAvatar(
              fullName: 'Synthetic Patient',
              avatarUrl: null,
            ),
          ),
        ),
      );
      expect(find.text('SP'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('avatar bytes loaded -> image shown', (tester) async {
      await tester.pumpWidget(
        pumpApp(
          Material(
            child: PatientAvatar(
              fullName: 'Synthetic Patient',
              avatarUrl: '/api/v1/patients/me/avatar/',
            ),
          ),
          overrides: [
            patientAvatarProvider.overrideWith((ref) async => _validPng),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('SP'), findsNothing);
    });

    testWidgets('avatar fetch unavailable -> initials, no crash', (
      tester,
    ) async {
      await tester.pumpWidget(
        pumpApp(
          Material(
            child: PatientAvatar(
              fullName: 'Synthetic Patient',
              avatarUrl: '/api/v1/patients/me/avatar/',
            ),
          ),
          overrides: [patientAvatarProvider.overrideWith((ref) async => null)],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('SP'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('avatar provider throws -> initials fallback', (tester) async {
      await tester.pumpWidget(
        pumpApp(
          Material(
            child: PatientAvatar(
              fullName: 'Synthetic Patient',
              avatarUrl: '/api/v1/patients/me/avatar/',
            ),
          ),
          overrides: [
            patientAvatarProvider.overrideWith(
              (ref) async => throw Exception('network'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('SP'), findsOneWidget);
    });
  });

  group('Profile avatar sheet', () {
    Future<void> pumpProfile(
      WidgetTester tester, {
      required String? avatarUrl,
    }) async {
      final profile = sampleProfile().copyWith(avatarUrl: avatarUrl);
      await tester.pumpWidget(
        pumpApp(
          const ProfileScreen(),
          overrides: [
            patientProfileProvider.overrideWith((ref) async => profile),
            patientAvatarProvider.overrideWith((ref) async => null),
          ],
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('tapping avatar opens action sheet (no avatar -> no remove)', (
      tester,
    ) async {
      await pumpProfile(tester, avatarUrl: null);

      await tester.tap(find.byType(PatientAvatar).first);
      await tester.pumpAndSettle();

      expect(find.text('Change photo'), findsOneWidget);
      expect(find.text('Remove photo'), findsNothing);
    });

    testWidgets('avatar present -> sheet shows remove option', (tester) async {
      await pumpProfile(tester, avatarUrl: '/api/v1/patients/me/avatar/');

      await tester.tap(find.byType(PatientAvatar).first);
      await tester.pumpAndSettle();

      expect(find.text('Change photo'), findsOneWidget);
      expect(find.text('Remove photo'), findsOneWidget);
    });
  });
}
