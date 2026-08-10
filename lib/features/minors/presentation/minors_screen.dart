import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/models/minor.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/pmdap_scaffold.dart';
import '../../../core/widgets/status_badge.dart';
import '../application/minors_providers.dart';

/// Guardian view of linked minor patients.
class MinorsScreen extends ConsumerWidget {
  const MinorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(minorsProvider);

    return PmdapScaffold(
      title: l10n.minorsTitle,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.minorsNew),
        icon: const Icon(Icons.person_add_alt),
        label: Text(l10n.addMinor),
      ),
      body: AsyncStateView(
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
              return ListTile(
                onTap: () => context.push(Routes.minorDetail(minor.uuid)),
                leading: CircleAvatar(child: Text(_initials(minor))),
                title: Text(minor.fullName),
                subtitle: Text(
                  '${l10n.minorAge}: ${minor.age} · ${formatApiDate(minor.dateOfBirth)}',
                ),
                trailing: StatusBadge.fromTone(
                  label: labels.identityState(minor.identityStatus),
                  tone: labels.identityTone(minor.identityStatus),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _initials(Minor minor) {
    final parts = minor.fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || minor.fullName.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}
