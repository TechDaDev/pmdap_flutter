import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/minor.dart';
import '../../../core/models/pagination.dart';

final minorsProvider = FutureProvider.autoDispose<Page<Minor>>(
  (ref) => ref.watch(minorsApiProvider).list(),
);

final minorDetailProvider = FutureProvider.autoDispose.family<Minor, String>(
  (ref, uuid) => ref.watch(minorsApiProvider).detail(uuid),
);
