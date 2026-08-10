import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/minors_providers.dart';
import '../data/minors_api.dart';

/// Add a minor (guardian). Multipart, requires `Idempotency-Key` header.
class MinorCreateScreen extends ConsumerStatefulWidget {
  const MinorCreateScreen({super.key});

  @override
  ConsumerState<MinorCreateScreen> createState() => _MinorCreateScreenState();
}

class _MinorCreateScreenState extends ConsumerState<MinorCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _nationalityController = TextEditingController(text: 'IQ');
  final _documentNumberController = TextEditingController();
  final _nationalNumberController = TextEditingController();
  final _familyNumberController = TextEditingController();

  DateTime? _dob;
  Sex _sex = Sex.unspecified;
  BloodGroup _bloodGroup = BloodGroup.unknown;
  Relationship _relationship = Relationship.father;
  IdentityDocumentType _docType = IdentityDocumentType.birthDocument;
  DateTime? _issueDate;
  DateTime? _expiryDate;

  String? _frontPath;
  String? _frontName;
  String? _backPath;
  String? _backName;
  String? _evidencePath;
  String? _evidenceName;

  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nationalityController.dispose();
    _documentNumberController.dispose();
    _nationalNumberController.dispose();
    _familyNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool front}) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    setState(() {
      if (front) {
        _frontPath = xfile.path;
        _frontName = xfile.name;
      } else {
        _backPath = xfile.path;
        _backName = xfile.name;
      }
    });
  }

  Future<void> _pickEvidence() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    setState(() {
      _evidencePath = file.path;
      _evidenceName = file.name;
    });
  }

  Future<void> _pickDate({required bool issue}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: issue ? DateTime(now.year - 5, 1, 1) : now,
      firstDate: DateTime(1990),
      lastDate: now.add(const Duration(days: 365 * 20)),
    );
    if (picked != null) {
      setState(() => issue ? _issueDate = picked : _expiryDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    if (_frontPath == null || _evidencePath == null) {
      setState(() => _errorMessage = l10n.validationFailed);
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final submission = MinorCreateSubmission(
      fullName: _fullNameController.text.trim(),
      dateOfBirth: _dob,
      sex: _sex,
      nationality: _nationalityController.text.trim().toUpperCase(),
      bloodGroup: _bloodGroup,
      relationship: _relationship,
      documentType: _docType,
      documentNumber: _documentNumberController.text.trim(),
      nationalNumber: _nationalNumberController.text.trim(),
      familyNumber: _familyNumberController.text.trim(),
      issuingCountry: _country,
      issueDate: _issueDate,
      expiryDate: _expiryDate,
      frontPath: _frontPath!,
      frontFilename: _frontName ?? 'front.jpg',
      backPath: _backPath,
      backFilename: _backName,
      evidencePath: _evidencePath!,
      evidenceFilename: _evidenceName ?? 'evidence',
    );
    try {
      await ref
          .read(minorsApiProvider)
          .create(submission, idempotencyKey: _newIdempotencyKey());
      ref.invalidate(minorsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.minorCreated)));
      Navigator.of(context).maybePop();
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      setState(() => _errorMessage = l10n.minorCreateFailed);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String get _country => _nationalityController.text.trim().toUpperCase();

  String _newIdempotencyKey() {
    // Backend requires an Idempotency-Key header; a fresh v4 UUID per attempt.
    return '${DateTime.now().microsecondsSinceEpoch}-${_frontPath.hashCode.abs()}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = StatusLabels(l10n);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addMinor)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: l10n.fullName,
                  controller: _fullNameController,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.dateOfBirth,
                  controller: TextEditingController(text: formatApiDate(_dob)),
                  readOnly: true,
                  onTap: () => _pickDate(issue: true),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<Sex>(
                  initialValue: _sex,
                  decoration: InputDecoration(labelText: l10n.sex),
                  items: [
                    for (final s in [Sex.male, Sex.female, Sex.unspecified])
                      DropdownMenuItem(
                        value: s,
                        child: Text(_sexLabel(l10n, s)),
                      ),
                  ],
                  onChanged: (v) => setState(() => _sex = v ?? Sex.unspecified),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.nationality,
                  controller: _nationalityController,
                  maxLength: 2,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<BloodGroup>(
                  initialValue: _bloodGroup,
                  decoration: InputDecoration(labelText: l10n.bloodGroup),
                  items: [
                    const DropdownMenuItem(
                      value: BloodGroup.unknown,
                      child: Text('—'),
                    ),
                    for (final b in BloodGroup.values)
                      if (b != BloodGroup.unknown)
                        DropdownMenuItem(value: b, child: Text(b.api)),
                  ],
                  onChanged: (v) =>
                      setState(() => _bloodGroup = v ?? BloodGroup.unknown),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<Relationship>(
                  initialValue: _relationship,
                  decoration: InputDecoration(labelText: l10n.relationship),
                  items: [
                    for (final r in Relationship.values)
                      if (r != Relationship.unknown)
                        DropdownMenuItem(
                          value: r,
                          child: Text(labels.relationship(r)),
                        ),
                  ],
                  onChanged: (v) =>
                      setState(() => _relationship = v ?? _relationship),
                ),
                const Divider(height: 32),
                DropdownButtonFormField<IdentityDocumentType>(
                  initialValue: _docType,
                  decoration: InputDecoration(labelText: l10n.documentType),
                  items: [
                    for (final t in IdentityDocumentType.values)
                      if (t != IdentityDocumentType.unknown)
                        DropdownMenuItem(
                          value: t,
                          child: Text(labels.identityDocumentType(t)),
                        ),
                  ],
                  onChanged: (v) => setState(() => _docType = v ?? _docType),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.documentNumber,
                  controller: _documentNumberController,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.nationalNumber,
                  controller: _nationalNumberController,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.familyNumber,
                  controller: _familyNumberController,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.issueDate,
                  controller: TextEditingController(
                    text: formatApiDate(_issueDate),
                  ),
                  readOnly: true,
                  onTap: () => _pickDate(issue: true),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.expiryDate,
                  controller: TextEditingController(
                    text: formatApiDate(_expiryDate),
                  ),
                  readOnly: true,
                  onTap: () => _pickDate(issue: false),
                ),
                const Divider(height: 32),
                _FileTile(
                  label: l10n.frontImage,
                  actionLabel: l10n.chooseExistingImage,
                  path: _frontPath,
                  onPick: () => _pickImage(front: true),
                ),
                const SizedBox(height: 12),
                _FileTile(
                  label: l10n.backImage,
                  actionLabel: l10n.chooseExistingImage,
                  path: _backPath,
                  optional: true,
                  onPick: () => _pickImage(front: false),
                ),
                const SizedBox(height: 12),
                _FileTile(
                  label: l10n.evidenceFile,
                  actionLabel: l10n.chooseFile,
                  path: _evidencePath,
                  onPick: _pickEvidence,
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
                  label: l10n.submit,
                  onPressed: _submitting ? null : _submit,
                  loading: _submitting,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _sexLabel(AppLocalizations l10n, Sex s) {
    switch (s) {
      case Sex.male:
        return l10n.male;
      case Sex.female:
        return l10n.female;
      case Sex.unspecified:
        return l10n.unspecified;
      case Sex.unknown:
        return l10n.unknownStatus;
    }
  }
}

class _FileTile extends StatelessWidget {
  const _FileTile({
    required this.label,
    required this.actionLabel,
    required this.onPick,
    this.path,
    this.optional = false,
  });

  final String label;
  final String actionLabel;
  final VoidCallback onPick;
  final String? path;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final hasFile = path != null;
    return Card(
      child: ListTile(
        leading: Icon(hasFile ? Icons.insert_drive_file : Icons.add),
        title: Text(label),
        trailing: hasFile
            ? IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: onPick,
                tooltip: 'Change',
              )
            : OutlinedButton(onPressed: onPick, child: Text(actionLabel)),
      ),
    );
  }
}
