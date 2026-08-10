import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/async_state_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/pmdap_scaffold.dart';
import '../../../core/widgets/status_badge.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.documentsNew),
        icon: const Icon(Icons.upload_file),
        label: Text(l10n.uploadDocument),
      ),
      body: AsyncStateView(
        value: async,
        onRetry: () => ref.invalidate(documentsProvider),
        emptyBuilder: (page) => page.results.isEmpty
            ? EmptyState(
                icon: Icons.folder_open_outlined,
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
              return _DocTile(
                doc: doc,
                statusLabel: labels.processing(doc.processingStatus),
                tone: labels.processingTone(doc.processingStatus),
                onTap: () => context.push(Routes.documentDetail(doc.uuid)),
              );
            },
          );
        },
      ),
    );
  }
}

class _DocTile extends StatelessWidget {
  const _DocTile({
    required this.doc,
    required this.statusLabel,
    required this.tone,
    this.onTap,
  });

  final MedicalDocument doc;
  final String statusLabel;
  final StatusTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      onTap: onTap,
      leading: const CircleAvatar(child: Icon(Icons.description_outlined)),
      title: Text(doc.title.isEmpty ? statusLabel : doc.title),
      subtitle: Text(
        '${doc.documentType.api} · '
        '${doc.facilityName.isNotEmpty ? doc.facilityName : l10n.noData}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: StatusBadge.fromTone(label: statusLabel, tone: tone),
    );
  }
}
