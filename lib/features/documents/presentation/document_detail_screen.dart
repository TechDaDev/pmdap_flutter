import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/security/private_media_cache.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/status_labels.dart';
import '../../documents/application/documents_providers.dart';

/// Medical document detail.
///
/// Polls the detail endpoint every 3s ONLY while processing is active, and
/// stops at terminal/actionable states. Private files are fetched through the
/// authenticated download endpoint, cached in the temp dir for viewing, then
/// cleaned up.
class DocumentDetailScreen extends ConsumerStatefulWidget {
  const DocumentDetailScreen({super.key, required this.uuid, this.minorUuid});

  final String uuid;
  final String? minorUuid;

  @override
  ConsumerState<DocumentDetailScreen> createState() =>
      _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends ConsumerState<DocumentDetailScreen>
    with WidgetsBindingObserver {
  Future<MedicalDocumentDetail>? _future;
  Timer? _timer;
  AppLifecycleState _lifecycle = AppLifecycleState.resumed;

  bool get _isMinor => widget.minorUuid != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycle = state;
    if (state == AppLifecycleState.resumed) {
      _schedulePollingIfNeeded();
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  Future<MedicalDocumentDetail> _load() {
    if (_isMinor) {
      return ref
          .read(minorDocumentsApiProvider)
          .detail(widget.minorUuid!, widget.uuid);
    }
    return ref.read(documentsApiProvider).detail(widget.uuid);
  }

  void _reload() {
    setState(() => _future = _load());
  }

  void _schedulePollingIfNeeded() {
    final current = _future;
    if (current == null) return;
    current.then((doc) {
      if (!mounted) return;
      if (doc.processingStatus.isActive &&
          _lifecycle == AppLifecycleState.resumed) {
        _timer?.cancel();
        _timer = Timer(const Duration(seconds: 3), () {
          if (mounted) _reload();
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _viewFile(MedicalDocumentDetail doc) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final api = ref.read(documentsApiProvider);
    final minorApi = ref.read(minorDocumentsApiProvider);
    File? cached;
    try {
      messenger.showSnackBar(SnackBar(content: Text(l10n.loading)));
      final bytes = _isMinor
          ? await minorApi.fetchFile(widget.minorUuid!, widget.uuid)
          : await api.fetchFile(widget.uuid);
      final name = doc.file?.originalFilename.isNotEmpty == true
          ? doc.file!.originalFilename
          : 'document.${_ext(doc.file?.mimeType ?? 'pdf')}';
      cached = await PrivateMediaCache.cacheBytes(bytes, name);
      final result = await OpenFilex.open(cached.path);
      if (result.type != ResultType.done) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.openFileFailed)));
      }
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.openFileFailed)));
    } finally {
      if (cached != null) {
        // Best-effort cleanup of the private temp copy.
        unawaited(PrivateMediaCache.cleanup(cached));
      }
    }
  }

  String _ext(String mime) {
    if (mime.contains('pdf')) return 'pdf';
    if (mime.contains('png')) return 'png';
    return 'jpg';
  }

  Future<void> _delete(MedicalDocumentDetail doc) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteDocument),
        content: Text(l10n.deleteDocumentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      if (_isMinor) {
        await ref
            .read(minorDocumentsApiProvider)
            .delete(widget.minorUuid!, widget.uuid);
      } else {
        await ref.read(documentsApiProvider).delete(widget.uuid);
      }
      ref.invalidate(documentsProvider);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleted)));
      navigator.maybePop();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.documentType),
        actions: [
          IconButton(
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
            tooltip: l10n.retry,
          ),
        ],
      ),
      body: FutureBuilder<MedicalDocumentDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error is ApiException
                    ? (snapshot.error! as ApiException).message
                    : l10n.errorGeneric,
              ),
            );
          }
          final doc = snapshot.data!;
          _schedulePollingIfNeeded();
          final labels = StatusLabels(l10n);
          final mime = doc.file?.mimeType ?? '';
          final isPdf = mime.contains('pdf');
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  labels.processing(doc.processingStatus),
                  const SizedBox(width: 8),
                  if (doc.processingStatus.isActive)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  const Spacer(),
                  Text(
                    isPdf ? 'PDF' : (mime.contains('png') ? 'PNG' : 'Image'),
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    _Row(l10n.title, doc.title),
                    _Row(l10n.documentType, doc.documentType.api),
                    _Row(l10n.description, doc.description),
                    _Row(l10n.reportDate, formatApiDate(doc.documentDate)),
                    _Row(l10n.facility, doc.facilityName),
                    _Row(l10n.department, doc.department),
                    _Row(l10n.physician, doc.physicianName),
                    _Row(l10n.location, doc.locationText),
                    _Row(
                      l10n.dateVerifiedLabel,
                      doc.dateVerified
                          ? l10n.statusVerified
                          : l10n.dateUnconfirmed,
                    ),
                  ],
                ),
              ),
              if (doc.file != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _viewFile(doc),
                  icon: Icon(
                    isPdf
                        ? Icons.picture_as_pdf_outlined
                        : Icons.image_outlined,
                  ),
                  label: Text(l10n.viewFile),
                ),
              ],
              if (doc.processingStatus.needsDateAction ||
                  doc.processingStatus == ProcessingStatus.dateDetected) ...[
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => context.push(
                    Routes.documentDate(widget.uuid),
                    extra: widget.minorUuid,
                  ),
                  icon: const Icon(Icons.event_available),
                  label: Text(l10n.confirmDate),
                ),
              ],
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => _delete(doc),
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
                label: Text(
                  l10n.deleteDocument,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(value.isEmpty ? '—' : value, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
