import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/date_candidate.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/models/pagination.dart';

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
