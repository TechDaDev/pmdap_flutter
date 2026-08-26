import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/medical_document.dart';
import '../../../l10n/app_localizations.dart';
import '../../medical_context/application/patient_context_controller.dart';
import '../../medical_context/domain/patient_context.dart';

/// In-app private medical document viewer.
///
/// Fetches the file through the authenticated PMDAP API (never a public URL,
/// never an external app, no token in any URL). Images render zoomable/pannable;
/// PDFs render via [pdfrx] with page navigation. View-only — no editing,
/// download, or share.
class DocumentViewerScreen extends ConsumerStatefulWidget {
  const DocumentViewerScreen({super.key, required this.uuid, this.minorUuid});

  final String uuid;
  final String? minorUuid;

  @override
  ConsumerState<DocumentViewerScreen> createState() =>
      _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends ConsumerState<DocumentViewerScreen> {
  Uint8List? _bytes;
  MedicalDocumentDetail? _detail;
  Object? _error;

  PatientContext get _patientContext {
    final selected = ref.read(patientContextProvider);
    final minorUuid = widget.minorUuid ?? selected.minorUuid;
    return minorUuid == null
        ? const PatientContext.self()
        : PatientContext.minor(
            relationshipUuid: selected.relationshipUuid ?? '',
            minorUuid: minorUuid,
            safeDisplayName: selected.safeDisplayName ?? '',
          );
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final repository = ref.read(medicalRecordsRepositoryProvider);
    final detailFuture = repository.getDocument(_patientContext, widget.uuid);
    final bytesFuture = repository.fetchFile(_patientContext, widget.uuid);
    detailFuture.then(
      (detail) {
        if (mounted) setState(() => _detail = detail);
      },
      onError: (_) {
        // Detail is only for the header; bytes are what matters.
      },
    );
    bytesFuture.then(
      (bytes) {
        if (mounted) {
          setState(() {
            _bytes = bytes;
            _error = null;
          });
        }
      },
      onError: (Object e) {
        if (mounted) setState(() => _error = e);
      },
    );
  }

  String? get _mime => _detail?.file?.mimeType ?? _bytesMime;

  String? get _bytesMime {
    final bytes = _bytes;
    if (bytes == null) return null;
    if (bytes.length >= 4 &&
        bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46) {
      return 'application/pdf';
    }
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    if (bytes.length >= 3 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return 'image/jpeg';
    }
    return null;
  }

  bool get _isPdf =>
      (_mime?.contains('pdf') ?? false) || _mime == 'application/pdf';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _detail?.title.isNotEmpty == true
              ? _detail!.title
              : l10n.documentViewer,
        ),
      ),
      body: _buildBody(context, theme, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    if (_error != null && _bytes == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(l10n.documentViewerError, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _error = null;
                    _bytes = null;
                  });
                  _load();
                },
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }
    final bytes = _bytes;
    if (bytes == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_isPdf) {
      return _PdfView(bytes: bytes, l10n: l10n);
    }
    return _ImageView(bytes: bytes);
  }
}

class _ImageView extends StatelessWidget {
  const _ImageView({required this.bytes});

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 5,
      minScale: 0.8,
      child: Center(
        child: Image.memory(
          bytes,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}

class _PdfView extends StatelessWidget {
  const _PdfView({required this.bytes, required this.l10n});

  final Uint8List bytes;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return PdfViewer.data(
      bytes,
      sourceName: 'private-document-${bytes.length}',
      params: const PdfViewerParams(maxScale: 4.0),
    );
  }
}
