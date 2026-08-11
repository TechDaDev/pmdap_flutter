import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/presentation.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/pmdap_scaffold.dart';
import '../application/minors_providers.dart';

/// Guardian view of linked minor patients.
class MinorsScreen extends ConsumerWidget {
  const MinorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final eligibility = ref.watch(guardianEligibilityProvider);

    // Present the eligibility gate before the normal minors workflow.
    return PmdapScaffold(
      title: l10n.minorsTitle,
      floatingActionButton: eligibility.valueOrNull?.isEligible == true
          ? FloatingActionButton.extended(
              onPressed: () => context.push(Routes.minorsNew),
              icon: const Icon(Icons.person_add_alt),
              label: Text(l10n.addMinor),
            )
          : null,
      body: eligibility.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _buildMinorsList(context, ref),
        data: (elig) => elig.isEligible
            ? _buildMinorsList(context, ref)
            : _GuardianEligibilityView(
                onVerify: () => context.push(Routes.identity),
              ),
      ),
    );
  }

  Widget _buildMinorsList(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(minorsProvider);
    return AsyncStateView(
      value: async,
      onRetry: () => ref.invalidate(minorsProvider),
      emptyBuilder: (page) => page.results.isEmpty
          ? EmptyState(icon: Icons.family_restroom, message: l10n.noMinors)
          : null,
      builder: (page) {
        final labels = StatusLabels(l10n);
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: page.results.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final minor = page.results[i];
            final pending =
                minor.relationship?.verificationStatus ==
                VerificationStatus.pending;
            final dob = localizedDate(l10n, minor.dateOfBirth);
            return ListTile(
              // PENDING relationships are not fully accessible — detail and
              // protected sub-routes require VERIFIED + active.
              onTap: pending
                  ? null
                  : () => context.push(Routes.minorDetail(minor.uuid)),
              enabled: !pending,
              leading: CircleAvatar(
                child: Text(patientInitials(minor.fullName)),
              ),
              title: Text(minor.fullName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pending
                        ? l10n.relationshipPending
                        : '${l10n.minorAge}: ${minor.age} · $dob',
                  ),
                  if (!pending) ...[
                    const SizedBox(height: 2),
                    // Digital ID — keep LTR inside Arabic UI.
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '${l10n.digitalId}: ${minor.digitalId}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: labels.verification(
                minor.relationship?.verificationStatus ??
                    VerificationStatus.unknown,
              ),
            );
          },
        );
      },
    );
  }
}

/// Bilingual gate shown when the guardian is not yet eligible.
class _GuardianEligibilityView extends StatelessWidget {
  const _GuardianEligibilityView({required this.onVerify});

  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.guardianEligibilityTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.guardianEligibilityBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onVerify,
              icon: const Icon(Icons.badge_outlined),
              label: Text(l10n.verifyIdentity),
            ),
          ],
        ),
      ),
    );
  }
}
