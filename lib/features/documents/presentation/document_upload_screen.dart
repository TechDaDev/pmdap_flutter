import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/facility.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../facilities/presentation/facilities_screen.dart';
import '../application/documents_providers.dart';
import '../data/documents_api.dart';

/// Upload a medical document using an EXISTING file only (no camera).
/// Pass `minorUuid` via route `extra` for guardian uploads.
class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen({super.key, this.minorUuid});

  final String? minorUuid;

  @override
  ConsumerState<DocumentUploadScreen> createState() =>
      _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _facilityNameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _physicianController = TextEditingController();
  final _locationController = TextEditingController();

  MedicalDocumentType _docType = MedicalDocumentType.laboratory;
  DateTime? _documentDate;
  HealthcareFacility? _facility;
  String? _filePath;
  String? _fileName;

  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _facilityNameController.dispose();
    _departmentController.dispose();
    _physicianController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.isEmpty) return;
    setState(() {
      _filePath = result.files.first.path;
      _fileName = result.files.first.name;
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
    if (picked != null) setState(() => _documentDate = picked);
  }

  Future<void> _pickFacility() async {
    final selected = await Navigator.of(context).push<HealthcareFacility>(
      MaterialPageRoute(builder: (_) => const FacilitiesScreen()),
    );
    if (selected != null) {
      setState(() => _facility = selected);
      _facilityNameController.text = selected.name;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    if (_filePath == null) {
      setState(() => _errorMessage = l10n.validationFailed);
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final input = DocumentUploadInput(
      documentType: _docType,
      filePath: _filePath!,
      filename: _fileName ?? 'document',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      healthcareFacilityId: _facility?.uuid,
      facilityName: _facilityNameController.text.trim(),
      locationText: _locationController.text.trim(),
      department: _departmentController.text.trim(),
      physicianName: _physicianController.text.trim(),
      documentDate: _documentDate,
    );
    try {
      if (widget.minorUuid != null) {
        await ref
            .read(minorDocumentsApiProvider)
            .upload(widget.minorUuid!, input);
      } else {
        await ref.read(documentsApiProvider).upload(input);
      }
      ref.invalidate(documentsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.uploadSuccess)));
      Navigator.of(context).maybePop();
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
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
      appBar: AppBar(title: Text(l10n.uploadDocument)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<MedicalDocumentType>(
                  initialValue: _docType,
                  decoration: InputDecoration(labelText: l10n.documentType),
                  items: [
                    for (final t in MedicalDocumentType.values)
                      if (t != MedicalDocumentType.unknown)
                        DropdownMenuItem(
                          value: t,
                          child: Text(_typeLabel(labels, t)),
                        ),
                  ],
                  onChanged: (v) => setState(() => _docType = v ?? _docType),
                ),
                const SizedBox(height: 14),
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
                  controller: TextEditingController(
                    text: formatApiDate(_documentDate),
                  ),
                  readOnly: true,
                  onTap: _pickDate,
                ),
                const SizedBox(height: 20),
                Card(
                  child: ListTile(
                    leading: Icon(
                      _filePath != null
                          ? Icons.insert_drive_file
                          : Icons.upload_file,
                    ),
                    title: Text(
                      _filePath != null
                          ? (_fileName ?? l10n.chooseFile)
                          : l10n.chooseFile,
                    ),
                    subtitle: Text(_filePath != null ? _filePath! : ''),
                    trailing: _filePath != null
                        ? IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _pickFile,
                            tooltip: 'Change',
                          )
                        : OutlinedButton(
                            onPressed: _pickFile,
                            child: Text(l10n.chooseFile),
                          ),
                  ),
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
                  onPressed: _submitting ? null : _submit,
                  loading: _submitting,
                  icon: Icons.cloud_upload_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _typeLabel(StatusLabels labels, MedicalDocumentType t) {
    // Human-readable from the stable API name.
    return t.api.split('_').map((w) => w.toLowerCase().capitalize()).join(' ');
  }
}

extension _Capitalize on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}
