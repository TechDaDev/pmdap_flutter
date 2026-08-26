import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/guardian_relationship_summary.dart';
import '../../../core/utils/presentation.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/pmdap_scaffold.dart';
import '../application/minors_providers.dart';
import '../../medical_context/application/patient_context_controller.dart';

class MinorsScreen extends ConsumerStatefulWidget {
  const MinorsScreen({super.key});

  @override
  ConsumerState<MinorsScreen> createState() => _MinorsScreenState();
}

class _MinorsScreenState extends ConsumerState<MinorsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(guardianRelationshipsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final relationships = ref.watch(guardianRelationshipsProvider);
    final eligibility = ref.watch(guardianEligibilityProvider);
    final canAdd = eligibility.valueOrNull?.isEligible == true;
    return PmdapScaffold(
      title: l10n.myChildrenTitle,
      floatingActionButton: canAdd
          ? FloatingActionButton.extended(
              onPressed: () => context.push(Routes.minorsNew),
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: Text(l10n.addMinor),
            )
          : null,
      body: relationships.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _ErrorState(
          onRetry: () => ref.invalidate(guardianRelationshipsProvider),
        ),
        data: (page) => RefreshIndicator(
          onRefresh: () => ref.refresh(guardianRelationshipsProvider.future),
          child: page.results.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * .68,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmptyState(
                            icon: Icons.family_restroom_outlined,
                            message:
                                '${l10n.myChildrenEmptyTitle}\n\n${l10n.myChildrenEmptyBody}',
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () => context.push(
                              canAdd ? Routes.minorsNew : Routes.identity,
                            ),
                            icon: Icon(
                              canAdd
                                  ? Icons.person_add_alt_1_outlined
                                  : Icons.verified_user_outlined,
                            ),
                            label: Text(
                              canAdd ? l10n.addFirstChild : l10n.verifyIdentity,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                  itemCount: page.results.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _RelationshipCard(
                    value: page.results[index],
                    onTap: () => context.push(
                      Routes.guardianRelationshipDetail(
                        page.results[index].uuid,
                      ),
                    ),
                    onOpen: page.results[index].isVerified
                        ? () => _openRecords(page.results[index])
                        : null,
                    onDismiss:
                        page.results[index].canDismiss &&
                            !page.results[index].isVerified
                        ? () => _confirmDismiss(page.results[index].uuid)
                        : null,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _confirmDismiss(String relationshipUuid) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dismissConfirmTitle),
        content: Text(l10n.dismissConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.removeRequest),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(minorsApiProvider).dismissRelationship(relationshipUuid);
      if (!mounted) return;
      ref.invalidate(guardianRelationshipsProvider);
    } on ApiException catch (error) {
      if (!mounted) return;
      final message = error.statusCode == 409
          ? l10n.relationshipConflict
          : error.message;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      ref.invalidate(guardianRelationshipsProvider);
    }
  }

  Future<void> _openRecords(GuardianRelationshipSummary relationship) async {
    final l10n = AppLocalizations.of(context);
    try {
      final entered = await ref
          .read(patientContextControllerProvider.notifier)
          .enter(relationship);
      if (!mounted) return;
      if (entered) {
        context.go(Routes.home);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.accessNoLongerActive)));
        ref.invalidate(guardianRelationshipsProvider);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.accessNoLongerActive)));
      ref.invalidate(guardianRelationshipsProvider);
    }
  }
}

class _RelationshipCard extends StatelessWidget {
  const _RelationshipCard({
    required this.value,
    required this.onTap,
    this.onOpen,
    this.onDismiss,
  });
  final GuardianRelationshipSummary value;
  final VoidCallback onTap;
  final VoidCallback? onOpen;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = StatusLabels(l10n);
    final color = _statusColor(Theme.of(context).colorScheme, value.status);
    return Semantics(
      button: true,
      label:
          '${value.child.fullName}, ${relationshipStatusLabel(l10n, value.status)}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(patientInitials(value.child.fullName)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value.child.fullName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(labels.relationshipLabel(value.relationship)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: .14),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              relationshipStatusLabel(l10n, value.status),
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (onOpen != null)
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: TextButton.icon(
                                onPressed: onOpen,
                                icon: const Icon(Icons.folder_shared_outlined),
                                label: Text(l10n.openRecords),
                              ),
                            ),
                          if (onDismiss != null)
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: TextButton.icon(
                                onPressed: onDismiss,
                                icon: const Icon(Icons.delete_outline),
                                label: Text(l10n.removeRequest),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 48),
            const SizedBox(height: 12),
            Text(l10n.relationshipRefreshFailed, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}

String relationshipStatusLabel(
  AppLocalizations l10n,
  GuardianRelationshipStatus status,
) => switch (status) {
  GuardianRelationshipStatus.pending => l10n.childStatusPending,
  GuardianRelationshipStatus.verified => l10n.childStatusVerified,
  GuardianRelationshipStatus.rejected => l10n.childStatusRejected,
  GuardianRelationshipStatus.revoked => l10n.childStatusRevoked,
  GuardianRelationshipStatus.unknown => l10n.childStatusUnknown,
};

Color _statusColor(ColorScheme colors, GuardianRelationshipStatus status) =>
    switch (status) {
      GuardianRelationshipStatus.verified => colors.primary,
      GuardianRelationshipStatus.pending => colors.tertiary,
      GuardianRelationshipStatus.rejected => colors.error,
      GuardianRelationshipStatus.revoked => colors.outline,
      GuardianRelationshipStatus.unknown => colors.outline,
    };
