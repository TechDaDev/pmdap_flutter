import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/api/business_errors.dart';
import 'package:pmdap_mobile/core/api/api_exception.dart';
import 'package:pmdap_mobile/core/models/claim.dart';
import 'package:pmdap_mobile/core/utils/uuid.dart';
import 'package:pmdap_mobile/features/archive/data/archive_api.dart';
import 'package:pmdap_mobile/features/search/data/search_api.dart';

void main() {
  group('firstNestedMessage (recursive validation details)', () {
    test('top-level String', () {
      expect(
        firstNestedMessage({'email': 'Already used.'}),
        'email: Already used.',
      );
    });

    test('top-level List<String>', () {
      expect(
        firstNestedMessage({
          'password': ['Too short.', 'Needs a number.'],
        }),
        'password: Too short.',
      );
    });

    test('nested patient.date_of_birth', () {
      final details = {
        'patient': {
          'date_of_birth': [
            'Direct account ownership requires an adult patient.',
          ],
        },
      };
      expect(
        firstNestedMessage(details),
        'patient: Direct account ownership requires an adult patient.',
      );
    });

    test('deeply nested list-of-maps', () {
      expect(
        firstNestedMessage({
          'a': {
            'b': [
              {
                'c': ['deep message'],
              },
            ],
          },
        }),
        'a: deep message',
      );
    });

    test('empty returns null', () {
      expect(firstNestedMessage(const {}), isNull);
    });
  });

  group('BusinessErrorMessages', () {
    String? keyFor(String code) => BusinessErrorMessages.copyKeyFor(
      ApiException(code: code, message: 'raw', details: {}),
    );

    test('guardian_not_verified maps to eligibility copy key', () {
      expect(keyFor('guardian_not_verified'), 'guardianEligibilityTitle');
    });

    test('patient_not_minor maps to under-18 copy key', () {
      expect(keyFor('patient_not_minor'), 'dobUnder18');
    });

    test('relationship_evidence_required maps to evidence key', () {
      expect(
        keyFor('relationship_evidence_required'),
        'legalGuardianEvidenceRequired',
      );
    });

    test('throttled and network have safe copy keys', () {
      expect(keyFor('throttled'), 'throttled');
      expect(
        BusinessErrorMessages.copyKeyFor(const ApiException.network()),
        'networkError',
      );
    });

    test('unknown code returns null (backend message fallback)', () {
      expect(keyFor('custom_code'), isNull);
    });
  });

  group('ArchiveQuery mutual exclusion', () {
    test('UNCONFIRMED drops year and month', () {
      final params = ArchiveQuery(
        year: 2026,
        month: 3,
        dateStatus: 'UNCONFIRMED',
      ).toQueryParameters();
      expect(params.containsKey('year'), isFalse);
      expect(params.containsKey('month'), isFalse);
      expect(params['date_status'], 'UNCONFIRMED');
    });

    test('VERIFIED keeps year/month', () {
      final params = ArchiveQuery(
        year: 2026,
        month: 3,
        dateStatus: 'VERIFIED',
      ).toQueryParameters();
      expect(params['year'], 2026);
      expect(params['month'], 3);
      expect(params['date_status'], 'VERIFIED');
    });
  });

  group('SearchQuery contract', () {
    test('exposes uploaded_from and uploaded_to', () {
      final params = SearchQuery(
        q: 'lab',
        uploadedFrom: DateTime(2026, 1, 1),
        uploadedTo: DateTime(2026, 3, 31),
      ).toQueryParameters();
      expect(params['uploaded_from'], '2026-01-01');
      expect(params['uploaded_to'], '2026-03-31');
      expect(params['q'], 'lab');
    });

    test('month without year is dropped', () {
      final params = SearchQuery(month: 5).toQueryParameters();
      expect(params.containsKey('month'), isFalse);
    });

    test('UNCONFIRMED drops report-date and upload filters', () {
      final params = SearchQuery(
        dateStatus: 'UNCONFIRMED',
        year: 2026,
        dateFrom: DateTime(2026, 1, 1),
        uploadedTo: DateTime(2026, 6, 1),
      ).toQueryParameters();
      expect(params.containsKey('year'), isFalse);
      expect(params.containsKey('date_from'), isFalse);
      expect(params.containsKey('uploaded_to'), isFalse);
      expect(params['date_status'], 'UNCONFIRMED');
    });

    test('invalid date range is not sent', () {
      final params = SearchQuery(
        dateFrom: DateTime(2026, 6, 1),
        dateTo: DateTime(2026, 1, 1),
      ).toQueryParameters();
      expect(params.containsKey('date_from'), isFalse);
      expect(params.containsKey('date_to'), isFalse);
    });
  });

  group('IdempotencyKeyManager', () {
    test('same payload retry returns the same key', () {
      final manager = IdempotencyKeyManager();
      final first = manager.keyForSubmission();
      final second = manager.keyForSubmission();
      expect(first, second);
      expect(manager.current, first);
    });

    test('changed content yields a new key', () {
      final manager = IdempotencyKeyManager();
      final first = manager.keyForSubmission();
      manager.noteContentChanged();
      final second = manager.keyForSubmission();
      expect(second, isNot(first));
    });

    test('reset yields a new key after success', () {
      final manager = IdempotencyKeyManager();
      final first = manager.keyForSubmission();
      manager.reset();
      final second = manager.keyForSubmission();
      expect(second, isNot(first));
    });
  });

  group('generateUuidV4', () {
    test('produces RFC 4122 v4 shape', () {
      final id = generateUuidV4();
      expect(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ).hasMatch(id),
        isTrue,
      );
    });

    test('produces distinct values', () {
      final a = generateUuidV4();
      final b = generateUuidV4();
      expect(a, isNot(b));
    });
  });

  group('ClaimReceipt (snake_case)', () {
    test('parses claim_id + status', () {
      final receipt = ClaimReceipt.fromJson({
        'claim_id': '11111111-2222-4333-8444-555555555555',
        'status': 'PENDING',
      });
      expect(receipt.claimId, '11111111-2222-4333-8444-555555555555');
      expect(receipt.status, 'PENDING');
    });
  });

  group('BACKEND CONTRACT DEFECT: ACCOUNT_CLAIM_DIGITAL_ID_REGEX', () {
    test('documents the incompatibility (expected blocker)', () {
      // Backend generates PT-XXXX-XXXX-XXXX (patients/services.py) but the
      // claim serializer requires ^\d{17}$ (claims/serializers.py). A real
      // Digital ID cannot satisfy the claim validator — tracked in
      // docs/account_claim_digital_id_defect.md. Flutter keeps the canonical
      // PT format and does NOT transform it.
      final canonical = 'PT-MK3T-G5VB-5573';
      expect(
        RegExp(r'^PT-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}$').hasMatch(canonical),
        isTrue,
      );
      // Backend currently demands 17 digits — this is the contradiction.
      expect(RegExp(r'^\d{17}$').hasMatch(canonical), isFalse);
    });
  });
}
