import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/facility.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/presentation.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../facilities/presentation/facilities_screen.dart';
import '../application/documents_providers.dart';
import '../data/documents_api.dart';
import '../scanner/document_scanner.dart';

/// Upload a medical document.
///
/// Required: a source (scan or existing file) + document type.
/// All other metadata is optional and lives under collapsed "Advanced details".
/// Pass `minorUuid` via route `extra` for guardian uploads.
class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen({super.key, this.minorUuid});

  final String? minorUuid;

  @override
  ConsumerState<DocumentUploadScreen> createState() =>
      _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _facilityNameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _physicianController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();

  MedicalDocumentType? _docType;
  DateTime? _documentDate;
  HealthcareFacility? _facility;

  // Source: scanner result OR picked file (mutually exclusive).
  DocumentScanResult? _scan;
  String? _filePath;
  String? _fileName;
  int? _fileSize;

  bool _scanning = false;
  bool _submitting = false;
  String? _errorMessage;

  /// Mirrors backend MEDICAL_FILE_MAX_BYTES (25 MB) for cheap client-side
  /// prevalidation; the server remains authoritative.
  static const int _maxUploadBytes = 25 * 1024 * 1024;

  bool get _hasSource => _scan != null || _filePath != null;

  String? get _uploadPath =>
      _scan?.pdfPath ??
      (_scan != null && _scan!.pagePaths.isNotEmpty
          ? _scan!.pagePaths.first
          : _filePath);

  String get _uploadName {
    if (_scan != null) return _scan!.pdfPath != null ? 'scan.pdf' : 'scan.jpg';
    return _fileName ?? 'document';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _facilityNameController.dispose();
    _departmentController.dispose();
    _physicianController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _scanning = true;
      _errorMessage = null;
    });
    try {
      final result = await scanDocument();
      if (!mounted) return;
      if (result.isEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.scanCancelled)));
        return;
      }
      setState(() {
        _scan = result;
        _filePath = null;
        _fileName = null;
        _fileSize = null;
      });
    } on ScannerUnavailableException {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.scannerUnavailable)));
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.scannerUnavailable)));
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.isEmpty) return;
    final f = result.files.first;
    setState(() {
      _filePath = f.path;
      _fileName = f.name;
      _fileSize = f.size;
      _scan = null;
    });
  }

  void _clearSource() {
    setState(() {
      _scan = null;
      _filePath = null;
      _fileName = null;
      _fileSize = null;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _documentDate ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _documentDate = picked;
        _dateController.text = formatApiDate(picked);
      });
    }
  }

  Future<void> _pickFacility() async {
    final selected = await Navigator.of(context).push<HealthcareFacility>(
      MaterialPageRoute(builder: (_) => const FacilitiesScreen()),
    );
    if (selected != null) {
      setState(() {
        _facility = selected;
        _facilityNameController.text = selected.name;
      });
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final path = _uploadPath;
    final type = _docType;
    if (path == null) {
      setState(() => _errorMessage = l10n.selectDocumentType);
      return;
    }
    if (type == null) {
      setState(() => _errorMessage = l10n.selectDocumentType);
      return;
    }
    // Client-side prevalidation of simple deterministic rules (server stays
    // authoritative): extension + known size ceiling. Avoids a wasted 15s
    // upload for a file that is obviously invalid.
    final lowerName = _uploadName.toLowerCase();
    final supported =
        lowerName.endsWith('.jpg') ||
        lowerName.endsWith('.jpeg') ||
        lowerName.endsWith('.png') ||
        lowerName.endsWith('.pdf');
    if (!supported) {
      setState(() => _errorMessage = l10n.uploadFileTypeUnsupported);
      return;
    }
    try {
      final bytes = File(path).lengthSync();
      if (bytes > _maxUploadBytes) {
        setState(() => _errorMessage = l10n.uploadFileTooLarge);
        return;
      }
    } catch (_) {
      // Unreadable file: fall through; the server will reject it safely.
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final input = DocumentUploadInput(
      documentType: type,
      filePath: path,
      filename: _uploadName,
      title: _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      healthcareFacilityId: _facility?.uuid,
      facilityName: _facilityNameController.text.trim().isEmpty
          ? null
          : _facilityNameController.text.trim(),
      locationText: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      department: _departmentController.text.trim().isEmpty
          ? null
          : _departmentController.text.trim(),
      physicianName: _physicianController.text.trim().isEmpty
          ? null
          : _physicianController.text.trim(),
      documentDate: _documentDate,
    );
    try {
      final doc = widget.minorUuid != null
          ? await ref
                .read(minorDocumentsApiProvider)
                .upload(widget.minorUuid!, input)
          : await ref.read(documentsApiProvider).upload(input);
      ref.invalidate(documentsProvider);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.uploadSuccess)));
      context.pushReplacement(
        Routes.documentDetail(doc.uuid),
        extra: widget.minorUuid,
      );
    } on ApiException catch (e) {
      if (kDebugMode) {
        debugPrint(
          'medical_upload error code=${e.code} status=${e.statusCode} '
          'msg=${e.message}',
        );
      }
      setState(() => _errorMessage = mapUploadError(e, l10n));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('medical_upload unexpected ${e.runtimeType}');
      }
      setState(() => _errorMessage = l10n.uploadFailed);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = StatusLabels(l10n);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addMedicalDocument)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SourceActionCard(
                icon: Icons.document_scanner_outlined,
                title: l10n.scanDocument,
                subtitle: l10n.scanDocumentSubtitle,
                buttonLabel: l10n.scanDocument,
                loading: _scanning,
                onTap: _scanning ? null : _startScan,
              ),
              const SizedBox(height: 12),
              _SourceActionCard(
                icon: Icons.upload_file_outlined,
                title: l10n.chooseFile,
                subtitle: l10n.chooseExistingFileSubtitle,
                buttonLabel: l10n.chooseFileButton,
                onTap: _scanning ? null : _pickFile,
              ),
              if (_scanning) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 10),
                    Text(l10n.startingScanner),
                  ],
                ),
              ],
              if (_scan != null) ...[
                const SizedBox(height: 16),
                _ScanSummary(
                  result: _scan!,
                  onRescan: _startScan,
                  onRemove: _clearSource,
                  l10n: l10n,
                ),
              ] else if (_filePath != null) ...[
                const SizedBox(height: 16),
                _FileSummary(
                  name: _fileName ?? l10n.chooseFile,
                  sizeBytes: _fileSize,
                  onChooseAnother: _pickFile,
                  onRemove: _clearSource,
                  l10n: l10n,
                ),
              ],
              const SizedBox(height: 24),
              DropdownButtonFormField<MedicalDocumentType>(
                initialValue: _docType,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: '${l10n.documentType} *',
                  hintText: l10n.selectDocumentType,
                ),
                items: [
                  for (final t in MedicalDocumentType.values)
                    if (t != MedicalDocumentType.unknown)
                      DropdownMenuItem(
                        value: t,
                        child: Text(labels.medicalDocumentTypeLabel(t)),
                      ),
                ],
                onChanged: (v) => setState(() => _docType = v),
              ),
              const SizedBox(height: 20),
              ExpansionTile(
                leading: const Icon(Icons.tune_rounded),
                title: Text(l10n.advancedDetails),
                subtitle: Text(
                  l10n.advancedDetailsSubtitle,
                  style: const TextStyle(fontSize: 12),
                ),
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                shape: const Border(),
                collapsedShape: const Border(),
                children: [
                  AppTextField(label: l10n.title, controller: _titleController),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: l10n.description,
                    controller: _descriptionController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: l10n.facility,
                    controller: _facilityNameController,
                    readOnly: true,
                    onTap: _pickFacility,
                    suffixIcon: const Icon(Icons.chevron_right),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: l10n.department,
                    controller: _departmentController,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: l10n.physician,
                    controller: _physicianController,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: l10n.location,
                    controller: _locationController,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: l10n.reportDate,
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                  ),
                ],
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                label: l10n.upload,
                onPressed: _hasSource && _docType != null && !_submitting
                    ? _submit
                    : null,
                loading: _submitting,
                icon: Icons.cloud_upload_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-width source action card (icon + title + subtitle + wide button).
class _SourceActionCard extends StatelessWidget {
  const _SourceActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
    this.loading = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: scheme.primary),
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: onTap,
                child: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanSummary extends StatelessWidget {
  const _ScanSummary({
    required this.result,
    required this.onRescan,
    required this.onRemove,
    required this.l10n,
  });

  final DocumentScanResult result;
  final VoidCallback onRescan;
  final VoidCallback onRemove;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final count = result.pageCount > 0
        ? result.pageCount
        : result.pagePaths.length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.scannedDocument,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '$count ${l10n.pagesLabel}',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
            if (result.pagePaths.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 76,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final p in result.pagePaths.take(8))
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(p),
                            width: 54,
                            height: 76,
                            fit: BoxFit.cover,
                            cacheWidth: 128,
                            errorBuilder: (_, _, _) => Container(
                              width: 54,
                              height: 76,
                              color: scheme.surfaceContainerHighest,
                              child: const Icon(Icons.description_outlined),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRescan,
                    child: Text(l10n.rescan),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRemove,
                    child: Text(l10n.remove),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FileSummary extends StatelessWidget {
  const _FileSummary({
    required this.name,
    required this.sizeBytes,
    required this.onChooseAnother,
    required this.onRemove,
    required this.l10n,
  });

  final String name;
  final int? sizeBytes;
  final VoidCallback onChooseAnother;
  final VoidCallback onRemove;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = fileSizeLabel(sizeBytes);
    final ext = name.contains('.')
        ? name.split('.').last.toUpperCase()
        : l10n.fileType;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.insert_drive_file_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        size.isEmpty ? ext : '$ext · $size',
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onChooseAnother,
                    child: Text(l10n.chooseAnother),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRemove,
                    child: Text(l10n.remove),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Maps a backend validation error to specific patient-facing text.
String mapUploadError(ApiException e, AppLocalizations l10n) {
  if (e.code != 'validation_error') return e.message;
  final fileMsgs = e.details['file'];
  if (fileMsgs is List && fileMsgs.isNotEmpty) {
    final m = fileMsgs.first.toString();
    if (m.contains('must be PDF, JPEG, or PNG')) {
      return l10n.uploadFileTypeUnsupported;
    }
    if (m.contains('size limit')) return l10n.uploadFileTooLarge;
    if (m.contains('dimensions')) return l10n.uploadImageTooLarge;
    if (m.contains('malformed') ||
        m.contains('empty') ||
        m.contains('trailing') ||
        m.contains('MIME') ||
        m.contains('extension')) {
      return l10n.uploadImageCorrupt;
    }
  }
  if (e.details.containsKey('document_type')) {
    return l10n.uploadInvalidDocumentType;
  }
  return l10n.uploadFailed;
}
