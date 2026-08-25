import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('family data is review-only and absent from relationship surfaces', () {
    final api = File(
      'lib/features/minors/data/minors_api.dart',
    ).readAsStringSync();
    final wizard = File(
      'lib/features/minors/presentation/minor_create_screen.dart',
    ).readAsStringSync();
    final list = File(
      'lib/features/minors/presentation/minors_screen.dart',
    ).readAsStringSync();

    expect(api.contains("'family_number'"), isFalse);
    expect(api.contains('familyNumber'), isFalse);
    expect(wizard.contains('l10n.familyNumber'), isTrue);
    expect(wizard.contains('_LockedIdentityField'), isTrue);
    expect(list.contains('dateOfBirth'), isFalse);
    expect(list.contains('minorSearch'), isFalse);
    expect(list.toLowerCase().contains('search child'), isFalse);
  });
}
