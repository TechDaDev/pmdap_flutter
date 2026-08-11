import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../core/models/facility.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../facilities/application/facilities_providers.dart';

/// Read-only searchable facility selector. Read-only: no create/edit.
/// Tapping a facility pops with the selection.
class FacilitiesScreen extends ConsumerStatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  ConsumerState<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends ConsumerState<FacilitiesScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(facilitiesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.facilitiesTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.searchFacility,
                border: const OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: AsyncStateView(
              value: async,
              onRetry: () => ref.invalidate(facilitiesProvider),
              emptyBuilder: (page) => page.results.isEmpty
                  ? EmptyState(
                      icon: Icons.local_hospital_outlined,
                      message: l10n.noFacilities,
                    )
                  : null,
              builder: (page) {
                final labels = StatusLabels(l10n);
                final all = _collectAll(page);
                final filtered = all.where((f) {
                  if (_query.isEmpty) return true;
                  return f.name.toLowerCase().contains(_query) ||
                      f.city?.name.toLowerCase().contains(_query) == true ||
                      f.region?.name.toLowerCase().contains(_query) == true;
                }).toList();
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off,
                    message: l10n.noFacilities,
                  );
                }
                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final f = filtered[i];
                    final place = [
                      f.city?.name ?? '',
                      f.region?.name ?? '',
                      f.country?.name ?? '',
                    ].where((s) => s.isNotEmpty).join(', ');
                    return ListTile(
                      leading: CircleAvatar(
                        child: const Icon(Icons.local_hospital_outlined),
                      ),
                      title: Text(f.name),
                      subtitle: Text(
                        place.isEmpty
                            ? labels.facilityTypeLabel(f.facilityType)
                            : place,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => Navigator.of(context).pop(f),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<HealthcareFacility> _collectAll(dynamic page) {
    final list = <HealthcareFacility>[];
    list.addAll((page.results as List<HealthcareFacility>?) ?? const []);
    return list;
  }
}
