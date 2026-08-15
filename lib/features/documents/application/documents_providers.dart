import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/date_candidate.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/models/pagination.dart';
import '../data/medical_image_optimizer.dart';

/// Native medical image optimizer (client-side performance layer). Server
/// validation remains authoritative; this only prepares a smaller derivative.
final medicalImageOptimizerProvider = Provider<MedicalImageOptimizer>(
  (ref) => NativeMedicalImageOptimizer(),
);

final documentsProvider = FutureProvider.autoDispose<Page<MedicalDocument>>(
  (ref) => ref.watch(documentsApiProvider).list(),
);

final documentDetailProvider = FutureProvider.autoDispose
    .family<MedicalDocumentDetail, String>(
      (ref, uuid) => ref.watch(documentsApiProvider).detail(uuid),
    );

final dateCandidatesProvider = FutureProvider.autoDispose
    .family<Page<DateCandidate>, String>(
      (ref, uuid) => ref.watch(documentsApiProvider).dateCandidates(uuid),
    );
