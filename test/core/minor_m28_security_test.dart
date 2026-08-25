import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('minor request never sends or renders family data', () {
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
    expect(wizard.contains('familyNumber'), isFalse);
    expect(list.contains('dateOfBirth'), isFalse);
    expect(list.contains('minorSearch'), isFalse);
    expect(list.toLowerCase().contains('search child'), isFalse);
  });
}
