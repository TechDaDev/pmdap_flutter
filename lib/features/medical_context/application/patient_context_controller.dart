import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/guardian_relationship_summary.dart';
import '../domain/patient_context.dart';

enum PatientContextExitReason { user, accessLost, signedOut }

final class PatientContextState {
  const PatientContextState({
    this.context = const PatientContext.self(),
    this.exitReason,
    this.eventId = 0,
  });

  final PatientContext context;
  final PatientContextExitReason? exitReason;
  final int eventId;
}

class PatientContextController extends Notifier<PatientContextState> {
  @override
  PatientContextState build() => const PatientContextState();

  /// Revalidates server state before entering. Route parameters never grant
  /// access; only the live relationship response can select a child context.
  Future<bool> enter(GuardianRelationshipSummary candidate) async {
    final live = await ref
        .read(minorsApiProvider)
        .relationshipDetail(candidate.uuid);
    if (!live.isVerified ||
        live.child.uuid.isEmpty ||
        live.child.uuid != candidate.child.uuid) {
      return false;
    }
    state = PatientContextState(
      context: PatientContext.minor(
        relationshipUuid: live.uuid,
        minorUuid: live.child.uuid,
        safeDisplayName: live.child.fullName,
      ),
      eventId: state.eventId + 1,
    );
    return true;
  }

  /// Deep-link gate: discovers the live relationship, then reuses [enter].
  Future<bool> enterByMinorUuid(String minorUuid) async {
    final page = await ref.read(minorsApiProvider).relationships();
    final matches = page.results.where(
      (item) => item.child.uuid == minorUuid && item.isVerified,
    );
    if (matches.isEmpty) return false;
    return enter(matches.first);
  }

  void exit({PatientContextExitReason reason = PatientContextExitReason.user}) {
    state = PatientContextState(exitReason: reason, eventId: state.eventId + 1);
  }

  void accessDenied(PatientContext failedContext) {
    if (failedContext.isMinor && state.context == failedContext) {
      exit(reason: PatientContextExitReason.accessLost);
    }
  }
}

final patientContextControllerProvider =
    NotifierProvider<PatientContextController, PatientContextState>(
      PatientContextController.new,
    );

final patientContextProvider = Provider<PatientContext>(
  (ref) => ref.watch(patientContextControllerProvider).context,
);
