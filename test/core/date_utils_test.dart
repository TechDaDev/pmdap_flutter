import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/utils/date_utils.dart';

void main() {
  group('date utils', () {
    test('parseApiDate parses ISO YYYY-MM-DD', () {
      final d = parseApiDate('2024-05-06');
      expect(d, isNotNull);
      expect(d!.year, 2024);
      expect(d.month, 5);
      expect(d.day, 6);
    });

    test('parseApiDate returns null for null/empty/invalid', () {
      expect(parseApiDate(null), isNull);
      expect(parseApiDate(''), isNull);
      expect(parseApiDate('not-a-date'), isNull);
    });

    test('formatApiDate produces zero-padded YYYY-MM-DD', () {
      expect(formatApiDate(DateTime(2024, 5, 6)), '2024-05-06');
      expect(formatApiDate(DateTime(2024, 12, 31)), '2024-12-31');
      expect(formatApiDate(null), '');
    });

    test('round-trips', () {
      final d = parseApiDate('2023-01-09');
      expect(formatApiDate(d), '2023-01-09');
    });

    test('ageFromDob computes age', () {
      final dob = DateTime(2000, 5, 10);
      final now = DateTime(2026, 8, 10);
      expect(ageFromDob(dob, now: now), '26');
      final beforeBirthday = DateTime(2026, 5, 9);
      expect(ageFromDob(dob, now: beforeBirthday), '25');
    });
  });
}
