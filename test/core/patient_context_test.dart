import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/di/providers.dart';
import 'package:pmdap_mobile/core/models/enums.dart';
import 'package:pmdap_mobile/core/models/guardian_relationship_summary.dart';
import 'package:pmdap_mobile/features/medical_context/application/patient_context_controller.dart';
import 'package:pmdap_mobile/features/medical_context/domain/patient_context.dart';
import 'package:pmdap_mobile/features/minors/data/minors_api.dart';

GuardianRelationshipSummary _relationship(
  String minorUuid, {
  GuardianRelationshipStatus status = GuardianRelationshipStatus.verified,
}) => GuardianRelationshipSummary(
  uuid: 'relationship-$minorUuid',
  child: GuardianChildSummary(
    uuid: minorUuid,
    digitalId: 'not-used',
    fullName: 'Synthetic $minorUuid',
  ),
  relationship: Relationship.mother,
  status: status,
  canRevoke: status == GuardianRelationshipStatus.verified,
);

class _RelationshipApi extends MinorsApi {
  _RelationshipApi(this.live) : super(Dio());
  GuardianRelationshipSummary live;

  @override
  Future<GuardianRelationshipSummary> relationshipDetail(String uuid) async =>
      live;
}

void main() {
  test('self, child A, and child B have isolated stable cache keys', () {
    const self = PatientContext.self();
    const childA = PatientContext.minor(
      relationshipUuid: 'rel-a',
      minorUuid: 'minor-a',
      safeDisplayName: 'A',
    );
    const childB = PatientContext.minor(
      relationshipUuid: 'rel-b',
      minorUuid: 'minor-b',
      safeDisplayName: 'B',
    );
    expect({self.cacheKey, childA.cacheKey, childB.cacheKey}, hasLength(3));
    expect(childA, isNot(childB));
  });

  test(
    'entry revalidates live VERIFIED state and matching denial exits',
    () async {
      final candidate = _relationship('minor-a');
      final api = _RelationshipApi(candidate);
      final container = ProviderContainer(
        overrides: [minorsApiProvider.overrideWithValue(api)],
      );
      addTearDown(container.dispose);

      expect(container.read(patientContextProvider).isMinor, isFalse);
      expect(
        await container
            .read(patientContextControllerProvider.notifier)
            .enter(candidate),
        isTrue,
      );
      final childContext = container.read(patientContextProvider);
      expect(childContext.cacheKey, 'minor:minor-a');

      const other = PatientContext.minor(
        relationshipUuid: 'rel-b',
        minorUuid: 'minor-b',
        safeDisplayName: 'B',
      );
      container
          .read(patientContextControllerProvider.notifier)
          .accessDenied(other);
      expect(container.read(patientContextProvider), childContext);

      container
          .read(patientContextControllerProvider.notifier)
          .accessDenied(childContext);
      expect(container.read(patientContextProvider).isMinor, isFalse);
      expect(
        container.read(patientContextControllerProvider).exitReason,
        PatientContextExitReason.accessLost,
      );
    },
  );

  test(
    'pending relationship cannot enter and new container cold-starts self',
    () async {
      final pending = _relationship(
        'minor-pending',
        status: GuardianRelationshipStatus.pending,
      );
      final container = ProviderContainer(
        overrides: [
          minorsApiProvider.overrideWithValue(_RelationshipApi(pending)),
        ],
      );
      addTearDown(container.dispose);
      expect(
        await container
            .read(patientContextControllerProvider.notifier)
            .enter(pending),
        isFalse,
      );
      expect(container.read(patientContextProvider).isMinor, isFalse);

      final coldStart = ProviderContainer();
      addTearDown(coldStart.dispose);
      expect(coldStart.read(patientContextProvider).isMinor, isFalse);
    },
  );
}
