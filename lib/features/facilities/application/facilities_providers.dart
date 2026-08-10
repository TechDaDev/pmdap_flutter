import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/facility.dart';
import '../../../core/models/pagination.dart';

final facilitiesProvider = FutureProvider.autoDispose<Page<HealthcareFacility>>(
  (ref) => ref.watch(facilitiesApiProvider).list(),
);
