import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/pmdap_scaffold.dart';
import '../application/documents_providers.dart';

/// Adult medical documents list.
class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(documentsProvider);

    return PmdapScaffold(
      title: l10n.documentsTitle,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Routes.documentsNew),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.upload_file_rounded),
      ),
      body: AsyncStateView(
        value: async,
        onRetry: () => ref.invalidate(documentsProvider),
        emptyBuilder: (page) => page.results.isEmpty
            ? EmptyState(
                icon: Icons.folder_open_rounded,
                message: l10n.noDocuments,
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
                onTap: () => context.push(Routes.documentDetail(doc.uuid)),
                leading: const CircleAvatar(
                  child: Icon(Icons.description_outlined),
                ),
                title: Text(
                  doc.title.isEmpty
                      ? labels.processingLabel(doc.processingStatus)
                      : doc.title,
                ),
                subtitle: Text(
                  doc.facilityName.isNotEmpty ? doc.facilityName : '',
                ),
                trailing: labels.processing(doc.processingStatus),
              );
            },
          );
        },
      ),
    );
  }
}
