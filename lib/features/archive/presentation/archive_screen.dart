import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/models/enums.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/document_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../application/archive_providers.dart';
import '../data/archive_api.dart';

/// Chronological archive with year/month/type/date-status filters.
/// Optional [minorUuid] for guardian-scoped archives.
class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key, this.minorUuid});

  final String? minorUuid;

  ArchiveScope get _scope => minorUuid == null
      ? const ArchiveScope.adult()
      : ArchiveScope.minor(minorUuid!);

  String get _filterKey => minorUuid ?? 'adult';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scope = _scope;
    final async = ref.watch(archiveProvider(scope));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.archiveTitle)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(archiveProvider(scope));
          ref.invalidate(archiveSummaryProvider(scope));
        },
        child: Column(
          children: [
            _Filters(filterKey: _filterKey),
            Expanded(
              child: AsyncStateView(
                value: async,
                onRetry: () => ref.invalidate(archiveProvider(scope)),
                emptyBuilder: (page) => page.results.isEmpty
                    ? EmptyState(
                        icon: Icons.archive_outlined,
                        message: l10n.noArchive,
                      )
                    : null,
                builder: (page) {
                  if (page.results.isEmpty) {
                    return EmptyState(
                      icon: Icons.archive_outlined,
                      message: l10n.noArchive,
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: page.results.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final doc = page.results[i];
                      return DocumentCard(
                        document: doc,
                        onTap: () => context.push(
                          Routes.documentDetail(doc.uuid),
                          extra: minorUuid,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Filters extends ConsumerWidget {
  const _Filters({required this.filterKey});

  final String filterKey;

  Future<void> _pickAndApply(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ArchiveQuery current,
    String title,
    List<(String, String)> options,
    ArchiveQuery Function(String) apply,
  ) async {
    final value = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final (label, value) in options)
                    ListTile(
                      title: Text(label),
                      onTap: () => Navigator.pop(context, value),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (value != null) {
      ref.read(archiveFilterProvider(filterKey).notifier).state = apply(value);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(archiveFilterProvider(filterKey));
    final currentYear = DateTime.now().year;

    final years = <(String, String)>[
      (l10n.allYears, ''),
      for (var y = currentYear; y >= currentYear - 8; y--) (y.toString(), '$y'),
    ];
    final types = <(String, String)>[
      (l10n.allTypes, ''),
      for (final t in MedicalDocumentType.values)
        if (t != MedicalDocumentType.unknown) (_docTypeLabel(t), t.api),
    ];
    final dateStatuses = <(String, String)>[
      (l10n.allDates, ''),
      (l10n.statusVerified, 'VERIFIED'),
      (l10n.unconfirmedDates, 'UNCONFIRMED'),
    ];

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: _FilterChipButton(
              label: query.year == null ? l10n.allYears : '${query.year}',
              onTap: () => _pickAndApply(
                context,
                ref,
                l10n,
                query,
                l10n.year,
                years,
                (v) => ArchiveQuery(
                  year: v.isEmpty ? null : int.parse(v),
                  month: null,
                  documentType: query.documentType,
                  healthcareFacilityId: query.healthcareFacilityId,
                  dateStatus: query.dateStatus,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: _FilterChipButton(
              label:
                  query.documentType == null ||
                      query.documentType == MedicalDocumentType.unknown
                  ? l10n.allTypes
                  : _docTypeLabel(query.documentType!),
              onTap: () => _pickAndApply(
                context,
                ref,
                l10n,
                query,
                l10n.documentType,
                types,
                (v) => ArchiveQuery(
                  year: query.year,
                  month: query.month,
                  documentType: v.isEmpty
                      ? null
                      : MedicalDocumentType.fromApi(v),
                  healthcareFacilityId: query.healthcareFacilityId,
                  dateStatus: query.dateStatus,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: _FilterChipButton(
              label: query.dateStatus == 'UNCONFIRMED'
                  ? l10n.unconfirmedDates
                  : (query.dateStatus == 'VERIFIED'
                        ? l10n.statusVerified
                        : l10n.allDates),
              onTap: () => _pickAndApply(
                context,
                ref,
                l10n,
                query,
                l10n.dateVerifiedLabel,
                dateStatuses,
                (v) => ArchiveQuery(
                  year: query.year,
                  month: query.month,
                  documentType: query.documentType,
                  healthcareFacilityId: query.healthcareFacilityId,
                  dateStatus: v.isEmpty ? null : v,
                ),
              ),
            ),
          ),
          if (query.year != null ||
              query.documentType != null ||
              query.dateStatus != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: IconButton(
                onPressed: () =>
                    ref.read(archiveFilterProvider(filterKey).notifier).state =
                        const ArchiveQuery(),
                icon: const Icon(Icons.filter_alt_off_outlined),
                tooltip: l10n.clearFilters,
              ),
            ),
        ],
      ),
    );
  }

  String _docTypeLabel(MedicalDocumentType t) =>
      t.api.split('_').map((w) => w.toLowerCase().capitalize()).join(' ');
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label),
    );
  }
}

extension _Cap on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}
