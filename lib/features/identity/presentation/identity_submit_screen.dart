import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/buttons.dart';
import '../../documents/scanner/document_scanner.dart';
import '../data/extraction_models.dart';
import 'identity_extraction_review_screen.dart';

/// Scan / capture an identity document, then read it (advisory extraction),
/// then confirm the result on [IdentityExtractionReviewScreen].
///
/// No manual fields are shown before extraction.
class IdentitySubmitScreen extends ConsumerStatefulWidget {
  const IdentitySubmitScreen({super.key, this.replaceUuid});

  final String? replaceUuid;

  @override
  ConsumerState<IdentitySubmitScreen> createState() =>
      _IdentitySubmitScreenState();
}

class _IdentitySubmitScreenState extends ConsumerState<IdentitySubmitScreen> {
  IdentityDocumentType _docType = IdentityDocumentType.unifiedNationalCard;

  String? _frontPath;
  String? _backPath;

  bool _reading = false;
  String? _errorMessage;

  bool get _isNationalCard =>
      _docType == IdentityDocumentType.unifiedNationalCard;

  bool get _canRead => _isNationalCard
      ? _frontPath != null && _backPath != null
      : _frontPath != null;

  static bool _supportsImage(String? name) {
    if (name == null) return false;
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
  }

  Future<void> _scan({required bool front}) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _errorMessage = null);
    try {
      final result = await scanDocument();
      if (result.pagePaths.isEmpty) return;
      setState(() {
        if (front) {
          _frontPath = result.pagePaths.first;
        } else {
          _backPath = result.pagePaths.first;
        }
      });
    } on ScannerUnavailableException {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.scannerUnavailable)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.scanCancelled)));
    }
  }

  Future<void> _pickImage({required bool front}) async {
    final l10n = AppLocalizations.of(context);
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    if (!_supportsImage(xfile.name)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.unsupportedImageFormat)));
      return;
    }
    setState(() {
      if (front) {
        _frontPath = xfile.path;
      } else {
        _backPath = xfile.path;
      }
    });
  }

  Future<void> _readDocument() async {
    final l10n = AppLocalizations.of(context);
    if (!_canRead) return;
    setState(() {
      _reading = true;
      _errorMessage = null;
    });
    try {
      final api = ref.read(identityApiProvider);
      final job = await api.extract(
        documentType: _docType,
        frontPath: _frontPath!,
        backPath: _isNationalCard ? _backPath : null,
      );

      // Poll the async job (OCR worker). Bounded so a stuck job never blanks
      // the screen — images are preserved and the user can retry.
      ExtractionStatus? status;
      const pollInterval = Duration(seconds: 2);
      const maxPolls = 45; // ~90s budget
      for (var attempt = 0; attempt < maxPolls; attempt++) {
        if (!mounted) return;
        status = await api.extractStatus(job.jobId);
        if (status.isTerminal) break;
        await Future<void>.delayed(pollInterval);
      }
      if (!mounted) return;
      if (status == null || !status.isTerminal) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.documentReadingFailed)));
        return;
      }
      if (status.status == ExtractionJobStatus.failed ||
          status.result == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.documentReadingFailed)));
        return;
      }
      final result = status.result!;
      if (result.fields.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.documentNotRecognized)));
        return;
      }
      final submitted = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => IdentityExtractionReviewScreen(
            result: result,
            documentType: _docType,
            frontPath: _frontPath!,
            backPath: _isNationalCard ? _backPath : null,
            replaceUuid: widget.replaceUuid,
          ),
        ),
      );
      if (submitted == true && mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.documentReadingFailed)));
    } finally {
      if (mounted) setState(() => _reading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = StatusLabels(l10n);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.replaceUuid != null
              ? l10n.replaceIdentityDocument
              : l10n.addIdentityDocument,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<IdentityDocumentType>(
                initialValue: _docType,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.documentType),
                items: [
                  for (final t in IdentityDocumentType.values)
                    if (t == IdentityDocumentType.unifiedNationalCard ||
                        t == IdentityDocumentType.passport)
                      DropdownMenuItem(
                        value: t,
                        child: Text(labels.identityTypeLabel(t)),
                      ),
                ],
                onChanged: (v) => setState(() {
                  _docType = v ?? _docType;
                  _frontPath = null;
                  _backPath = null;
                }),
              ),
              const SizedBox(height: 18),
              if (_isNationalCard) ...[
                _CaptureCard(
                  label: l10n.frontImage,
                  path: _frontPath,
                  scanLabel: l10n.scanFront,
                  onScan: () => _scan(front: true),
                  onPick: () => _pickImage(front: true),
                ),
                const SizedBox(height: 12),
                _CaptureCard(
                  label: l10n.backImage,
                  path: _backPath,
                  scanLabel: l10n.scanBack,
                  onScan: () => _scan(front: false),
                  onPick: () => _pickImage(front: false),
                ),
              ] else ...[
                _CaptureCard(
                  label: l10n.docTypePassport,
                  path: _frontPath,
                  scanLabel: l10n.scanPassport,
                  onScan: () => _scan(front: true),
                  onPick: () => _pickImage(front: true),
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                label: _reading ? l10n.readingDocument : l10n.readDocument,
                onPressed: _reading || !_canRead ? null : _readDocument,
                loading: _reading,
                icon: Icons.document_scanner_outlined,
              ),
              const SizedBox(height: 10),
              Text(
                l10n.identityExtractionAdvisory,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaptureCard extends StatelessWidget {
  const _CaptureCard({
    required this.label,
    required this.scanLabel,
    required this.onScan,
    required this.onPick,
    this.path,
  });

  final String label;
  final String scanLabel;
  final VoidCallback onScan;
  final VoidCallback onPick;
  final String? path;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final hasImage = path != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (hasImage) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.file(
                    File(path!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: scheme.surfaceContainerHighest,
                      child: Center(child: Icon(Icons.broken_image_outlined)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onScan,
                      icon: const Icon(Icons.document_scanner_outlined),
                      label: Text(l10n.rescan),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onPick,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(l10n.replaceImage),
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: onScan,
                  icon: const Icon(Icons.document_scanner_outlined),
                  label: Text(scanLabel),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: onPick,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(l10n.chooseImage),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
