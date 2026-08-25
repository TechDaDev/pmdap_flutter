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
import '../application/minors_providers.dart';
import 'minors_screen.dart';

class MinorDetailScreen extends ConsumerStatefulWidget {
  const MinorDetailScreen({super.key, required this.uuid});
  final String uuid;

  @override
  ConsumerState<MinorDetailScreen> createState() => _MinorDetailScreenState();
}

class _MinorDetailScreenState extends ConsumerState<MinorDetailScreen> {
  bool _revoking = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(guardianRelationshipDetailProvider(widget.uuid));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.relationshipDetails)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            error is ApiException && (error.isNotFound || error.isForbidden)
            ? EmptyState(
                icon: Icons.no_accounts_outlined,
                message: l10n.guardianAccessRemoved,
              )
            : Center(
                child: OutlinedButton(
                  onPressed: () => ref.invalidate(
                    guardianRelationshipDetailProvider(widget.uuid),
                  ),
                  child: Text(l10n.retry),
                ),
              ),
        data: _content,
      ),
    );
  }

  Widget _content(GuardianRelationshipSummary value) {
    final l10n = AppLocalizations.of(context);
    final labels = StatusLabels(l10n);
    final statusMessage = switch (value.status) {
      GuardianRelationshipStatus.pending => l10n.requestReceived,
      GuardianRelationshipStatus.rejected => l10n.requestRejected,
      GuardianRelationshipStatus.revoked => l10n.accessEnded,
      GuardianRelationshipStatus.verified => l10n.childStatusVerified,
      GuardianRelationshipStatus.unknown => l10n.childStatusUnknown,
    };
    return RefreshIndicator(
      onRefresh: () =>
          ref.refresh(guardianRelationshipDetailProvider(widget.uuid).future),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.family_restroom_outlined, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    value.child.fullName,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(relationshipStatusLabel(l10n, value.status)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _InfoRow(
                  l10n.childDigitalId,
                  value.child.digitalId,
                  forceLtr: true,
                ),
                _InfoRow(
                  l10n.relationship,
                  labels.relationshipLabel(value.relationship),
                ),
                _InfoRow(
                  l10n.relationshipStatus,
                  relationshipStatusLabel(l10n, value.status),
                ),
                _InfoRow(
                  value.isVerified ? l10n.activeSince : l10n.submittedOn,
                  localizedDate(
                    l10n,
                    value.isVerified ? value.verifiedAt : value.createdAt,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(statusMessage, textAlign: TextAlign.center),
          if (value.isVerified) ...[
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: () =>
                  context.push(Routes.minorDocuments(value.child.uuid)),
              icon: const Icon(Icons.description_outlined),
              label: Text(l10n.minorDocuments),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.push(Routes.minorArchive(value.child.uuid)),
                    icon: const Icon(Icons.archive_outlined),
                    label: Text(l10n.minorArchive),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.push(Routes.minorSearch(value.child.uuid)),
                    icon: const Icon(Icons.search),
                    label: Text(l10n.minorSearch),
                  ),
                ),
              ],
            ),
          ],
          if (value.canRevoke) ...[
            const SizedBox(height: 28),
            OutlinedButton.icon(
              onPressed: _revoking ? null : () => _confirmRevoke(value.uuid),
              icon: const Icon(Icons.link_off_outlined),
              label: Text(l10n.revokeAccess),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmRevoke(String relationshipUuid) async {
    if (_revoking) return;
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.revokeConfirmTitle),
        content: Text(l10n.revokeConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.revokeAccess),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _revoking = true);
    try {
      await ref.read(minorsApiProvider).revokeRelationship(relationshipUuid);
      ref.invalidate(guardianRelationshipsProvider);
      ref.invalidate(guardianRelationshipDetailProvider(widget.uuid));
    } on ApiException catch (error) {
      if (!mounted) return;
      final message = error.statusCode == 409
          ? l10n.relationshipConflict
          : error.message;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _revoking = false);
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.forceLtr = false});
  final String label;
  final String value;
  final bool forceLtr;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
        Directionality(
          textDirection: forceLtr
              ? TextDirection.ltr
              : Directionality.of(context),
          child: Text(value.isEmpty ? '—' : value),
        ),
      ],
    ),
  );
}
