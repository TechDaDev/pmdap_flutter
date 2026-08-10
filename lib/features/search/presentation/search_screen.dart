import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/models/enums.dart';
import '../../../core/widgets/document_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/pmdap_scaffold.dart';
import '../application/search_providers.dart';
import '../data/search_api.dart';

/// Lexical search (not semantic, not AI). Never logs or persists the query.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.minorUuid});

  final String? minorUuid;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  MedicalDocumentType? _type;
  String? _dateStatus;

  @override
  void initState() {
    super.initState();
    ref.read(searchScopeProvider.notifier).state = widget.minorUuid == null
        ? const SearchScope.adult()
        : SearchScope.minor(widget.minorUuid!);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchQueryProvider.notifier).state = SearchQuery(
        q: value,
        documentType: _type,
        dateStatus: _dateStatus,
      );
    });
  }

  void _applyFilters() {
    ref.read(searchQueryProvider.notifier).state = SearchQuery(
      q: _controller.text,
      documentType: _type,
      dateStatus: _dateStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final resultsAsync = ref.watch(searchResultsProvider);
    final current = ref.watch(searchQueryProvider);

    return PmdapScaffold(
      title: l10n.searchTitle,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.searchHint,
                border: const OutlineInputBorder(),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          _onChanged('');
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _TypeChip(
                  label: l10n.allTypes,
                  selected: _type == null,
                  onTap: () {
                    setState(() => _type = null);
                    _applyFilters();
                  },
                ),
                for (final t in MedicalDocumentType.values)
                  if (t != MedicalDocumentType.unknown)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: _TypeChip(
                        label: t.api
                            .split('_')
                            .map((w) => w.toLowerCase().capitalize())
                            .join(' '),
                        selected: _type == t,
                        onTap: () {
                          setState(() => _type = t);
                          _applyFilters();
                        },
                      ),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: resultsAsync.when(
              data: (page) {
                if (page.results.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off,
                    message: current.q?.trim().isEmpty == true
                        ? l10n.searchHint
                        : l10n.noResults,
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
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l10n.errorGeneric)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      visualDensity: VisualDensity.compact,
    );
  }
}

extension _Cap on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}
