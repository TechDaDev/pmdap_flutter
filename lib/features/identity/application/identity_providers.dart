import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/identity.dart';
import '../../../core/models/pagination.dart';

final identityDocumentsProvider =
    FutureProvider.autoDispose<Page<IdentityDocumentSummary>>(
      (ref) => ref.watch(identityApiProvider).list(),
    );

final identityDocumentDetailProvider = FutureProvider.autoDispose
    .family<IdentityDocumentDetail, String>(
      (ref, uuid) => ref.watch(identityApiProvider).detail(uuid),
    );
