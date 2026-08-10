import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/patient_card.dart';
import '../application/minors_providers.dart';

/// Minor detail + navigation into minor-scoped documents/archive/search.
/// Guardian access that has ended (404/403) is handled gracefully.
class MinorDetailScreen extends ConsumerWidget {
  const MinorDetailScreen({super.key, required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(minorDetailProvider(uuid));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.minorsTitle)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) {
          if (e is ApiException && (e.isNotFound || e.isForbidden)) {
            return EmptyState(
              icon: Icons.no_accounts_outlined,
              message: l10n.guardianAccessRemoved,
            );
          }
          return Center(child: Text(l10n.errorGeneric));
        },
        data: (minor) {
          final labels = StatusLabels(l10n);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              PatientCard.fromMinor(minor: minor),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    _InfoRow(l10n.minorAge, '${minor.age}'),
                    _InfoRow(
                      l10n.dateOfBirth,
                      formatApiDate(minor.dateOfBirth),
                    ),
                    _InfoRow(l10n.sex, _sexLabel(l10n, minor.sex)),
                    _InfoRow(
                      l10n.bloodGroup,
                      minor.bloodGroup == BloodGroup.unknown
                          ? '—'
                          : minor.bloodGroup.api,
                    ),
                    _InfoRow(l10n.nationality, minor.nationality),
                    _InfoRow(
                      l10n.relationship,
                      labels.relationship(
                        minor.relationship?.relationship ??
                            Relationship.unknown,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () => context.push(Routes.minorDocuments(uuid)),
                icon: const Icon(Icons.description_outlined),
                label: Text(l10n.minorDocuments),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(Routes.minorArchive(uuid)),
                      icon: const Icon(Icons.archive_outlined),
                      label: Text(l10n.minorArchive),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(Routes.minorSearch(uuid)),
                      icon: const Icon(Icons.search),
                      label: Text(l10n.minorSearch),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String _sexLabel(AppLocalizations l10n, Sex s) {
    switch (s) {
      case Sex.male:
        return l10n.male;
      case Sex.female:
        return l10n.female;
      case Sex.unspecified:
        return l10n.unspecified;
      case Sex.unknown:
        return l10n.unknownStatus;
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
