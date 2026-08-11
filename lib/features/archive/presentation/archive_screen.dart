import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/models/enums.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/document_card.dart';
import '../application/archive_providers.dart';
import '../data/archive_api.dart';

/// Chronological archive with year/month/type/date-status filters.
/// Optional [minorUuid] for guardian-scoped archives.
class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key, this.minorUuid});

  final String? minorUuid;

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  ArchiveScope get _scope => widget.minorUuid == null
      ? const ArchiveScope.adult()
      : ArchiveScope.minor(widget.minorUuid!);

  String get _filterKey => widget.minorUuid ?? 'adult';

  @override
  void initState() {
    super.initState();
    // Allow "Needs confirmation" shortcut to open the archive pre-filtered
    // with date_status=UNCONFIRMED (never combined with year/month).
    final extra = GoRouter.maybeOf(
      context,
    )?.routerDelegate.currentConfiguration.extra;
    if (extra is ArchiveQuery) {
      ref.read(archiveFilterProvider(_filterKey).notifier).state = extra;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = _scope;
    final async = ref.watch(archiveProvider(scope));
    final unconfirmed =
        ref.watch(archiveFilterProvider(_filterKey)).dateStatus ==
        'UNCONFIRMED';

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
                    ? _ArchiveEmpty(isUnconfirmed: unconfirmed, l10n: l10n)
                    : null,
                builder: (page) {
                  if (page.results.isEmpty) {
                    return _ArchiveEmpty(
                      isUnconfirmed: unconfirmed,
                      l10n: l10n,
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
                          extra: widget.minorUuid,
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
                  // UNCONFIRMED cannot combine with year/month.
                  dateStatus: query.dateStatus == 'UNCONFIRMED'
                      ? null
                      : query.dateStatus,
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
                (v) {
                  final unconfirmed = v == 'UNCONFIRMED';
                  return ArchiveQuery(
                    year: unconfirmed ? null : query.year,
                    month: unconfirmed ? null : query.month,
                    documentType: query.documentType,
                    healthcareFacilityId: query.healthcareFacilityId,
                    dateStatus: v.isEmpty ? null : v,
                  );
                },
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, size: 18),
        ],
      ),
    );
  }
}

/// Empty archive state with supporting copy and an upload CTA (only for the
/// unfiltered/default state; UNCONFIRMED gets its own message and no CTA).
class _ArchiveEmpty extends StatelessWidget {
  const _ArchiveEmpty({required this.isUnconfirmed, required this.l10n});

  final bool isUnconfirmed;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.archive_outlined,
              size: 48,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              isUnconfirmed ? l10n.noUnconfirmedArchive : l10n.noArchive,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (!isUnconfirmed) ...[
              const SizedBox(height: 8),
              Text(
                l10n.archiveEmptySubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => context.push(Routes.documentsNew),
                icon: const Icon(Icons.upload_file_outlined),
                label: Text(l10n.uploadDocument),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

extension _Cap on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}
