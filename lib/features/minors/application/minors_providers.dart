import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/guardian_relationship_summary.dart';
import '../../../core/models/minor.dart';
import '../../../core/models/pagination.dart';
import '../../identity/application/identity_providers.dart';
import '../../patient/application/patient_providers.dart';

final minorsProvider = FutureProvider.autoDispose<Page<Minor>>(
  (ref) => ref.watch(minorsApiProvider).list(),
);

final minorDetailProvider = FutureProvider.autoDispose.family<Minor, String>(
  (ref, uuid) => ref.watch(minorsApiProvider).detail(uuid),
);

final guardianRelationshipsProvider =
    FutureProvider.autoDispose<Page<GuardianRelationshipSummary>>(
      (ref) => ref.watch(minorsApiProvider).relationships(),
    );

final guardianRelationshipDetailProvider = FutureProvider.autoDispose
    .family<GuardianRelationshipSummary, String>(
      (ref, uuid) => ref.watch(minorsApiProvider).relationshipDetail(uuid),
    );

/// Whether the signed-in adult is an eligible guardian.
///
/// Mirrors the backend `guardian_not_verified` gate: PATIENT + ACTIVE + adult
/// + identity_status VERIFIED + a CURRENT & VERIFIED Unified National Card.
/// Used only for presentation gating — the backend remains authoritative.
class GuardianEligibility {
  const GuardianEligibility({
    required this.isEligible,
    this.checkedIdentity = false,
  });

  final bool isEligible;
  final bool checkedIdentity;
}

final guardianEligibilityProvider = Provider<AsyncValue<GuardianEligibility>>((
  ref,
) {
  final profileAsync = ref.watch(patientProfileProvider);
  final identityAsync = ref.watch(identityDocumentsProvider);
  if (profileAsync.isLoading || identityAsync.isLoading) {
    return const AsyncLoading();
  }
  if (profileAsync.hasError || identityAsync.hasError) {
    return AsyncError(
      profileAsync.error ?? identityAsync.error!,
      StackTrace.current,
    );
  }
  final profile = profileAsync.value!;
  final docs = identityAsync.value!.results;
  final hasCard = docs.any(
    (d) =>
        d.documentType == IdentityDocumentType.unifiedNationalCard &&
        d.verificationStatus == VerificationStatus.verified &&
        d.status == IdentityDocumentLifecycleStatus.current,
  );
  final eligible =
      !profile.isMinor &&
      profile.identityStatus == IdentityStatus.verified &&
      hasCard;
  return AsyncData(
    GuardianEligibility(isEligible: eligible, checkedIdentity: true),
  );
});
