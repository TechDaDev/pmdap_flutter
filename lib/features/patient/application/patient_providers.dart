import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/patient.dart';

final patientProfileProvider = FutureProvider.autoDispose<PatientProfile>(
  (ref) => ref.watch(patientApiProvider).me(),
);
