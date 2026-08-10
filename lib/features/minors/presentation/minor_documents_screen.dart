import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_badge.dart';

/// Minor-scoped medical documents (guardian flow).
class MinorDocumentsScreen extends ConsumerStatefulWidget {
  const MinorDocumentsScreen({super.key, required this.minorUuid});

  final String minorUuid;

  @override
  ConsumerState<MinorDocumentsScreen> createState() =>
      _MinorDocumentsScreenState();
}

class _MinorDocumentsScreenState extends ConsumerState<MinorDocumentsScreen> {
  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<dynamic> _load() =>
      ref.read(minorDocumentsApiProvider).list(widget.minorUuid);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.minorDocuments)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.push(Routes.documentsNew, extra: widget.minorUuid),
        icon: const Icon(Icons.upload_file),
        label: Text(l10n.uploadDocument),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.errorGeneric));
          }
          final page = snapshot.data as dynamic;
          final results =
              (page.results as List<MedicalDocument>?) ??
              const <MedicalDocument>[];
          if (results.isEmpty) {
            return EmptyState(
              icon: Icons.folder_open_outlined,
              message: l10n.noDocuments,
            );
          }
          final labels = StatusLabels(l10n);
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: results.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final doc = results[i];
              return ListTile(
                onTap: () => context.push(
                  Routes.documentDetail(doc.uuid),
                  extra: widget.minorUuid,
                ),
                leading: const CircleAvatar(
                  child: Icon(Icons.description_outlined),
                ),
                title: Text(
                  doc.title.isEmpty ? doc.documentType.api : doc.title,
                ),
                subtitle: Text(labels.processing(doc.processingStatus)),
                trailing: StatusBadge.fromTone(
                  label: labels.processing(doc.processingStatus),
                  tone: labels.processingTone(doc.processingStatus),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
