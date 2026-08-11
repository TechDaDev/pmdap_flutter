import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/pmdap_scaffold.dart';
import '../application/identity_providers.dart';

class IdentityDocumentsScreen extends ConsumerWidget {
  const IdentityDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(identityDocumentsProvider);

    return PmdapScaffold(
      title: l10n.identityTitle,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.identityNew),
        icon: const Icon(Icons.badge_outlined),
        label: Text(l10n.addIdentityDocument),
      ),
      body: AsyncStateView(
        value: async,
        onRetry: () => ref.invalidate(identityDocumentsProvider),
        emptyBuilder: (page) => page.results.isEmpty
            ? EmptyState(
                icon: Icons.badge_outlined,
                message: l10n.noIdentityDocuments,
              )
            : null,
        builder: (page) {
          final labels = StatusLabels(l10n);
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: page.results.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final doc = page.results[i];
              return ListTile(
                onTap: () => context.push(Routes.identityDetail(doc.uuid)),
                leading: const CircleAvatar(child: Icon(Icons.badge_outlined)),
                title: Text(labels.identityTypeLabel(doc.documentType)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.issuingCountry.isNotEmpty
                          ? doc.issuingCountry
                          : l10n.noData,
                    ),
                    const SizedBox(height: 4),
                    labels.lifecycle(doc.status),
                  ],
                ),
                trailing: labels.verification(doc.verificationStatus),
              );
            },
          );
        },
      ),
    );
  }
}
