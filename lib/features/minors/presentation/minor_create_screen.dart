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
import '../../../core/utils/uuid.dart';
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
  final _issuingCountryController = TextEditingController(text: 'IQ');

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
  EvidenceType? _evidenceType;
  String? _evidencePath;
  String? _evidenceName;

  final _idempotency = IdempotencyKeyManager();
  bool _submitting = false;
  String? _errorMessage;

  bool get _isNationalCard =>
      _docType == IdentityDocumentType.unifiedNationalCard;
  bool get _isLegalGuardian => _relationship == Relationship.legalGuardian;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nationalityController.dispose();
    _documentNumberController.dispose();
    _nationalNumberController.dispose();
    _familyNumberController.dispose();
    _issuingCountryController.dispose();
    super.dispose();
  }

  static bool _supportsImage(String? name) {
    if (name == null) return false;
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
  }

  /// Identity images and guardian evidence are validated by the backend with
  /// the same secure validator (JPEG/PNG only). Reject others client-side.
  bool _applyPicked({String? path, String? name, required int kind}) {
    if (!_supportsImage(name)) {
      setState(
        () =>
            _errorMessage = AppLocalizations.of(context).unsupportedImageFormat,
      );
      return false;
    }
    _idempotency.noteContentChanged();
    setState(() {
      switch (kind) {
        case 0:
          _frontPath = path;
          _frontName = name;
        case 1:
          _backPath = path;
          _backName = name;
        default:
          _evidencePath = path;
          _evidenceName = name;
      }
    });
    return true;
  }

  Future<void> _pickImage({required bool front}) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    final ok = _applyPicked(
      path: xfile.path,
      name: xfile.name,
      kind: front ? 0 : 1,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).unsupportedImageFormat),
        ),
      );
    }
  }

  Future<void> _pickEvidence() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final ok = _applyPicked(path: file.path, name: file.name, kind: 2);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).unsupportedImageFormat),
        ),
      );
    }
  }

  /// Date of birth — past only and under 18 (exact calendar age).
  Future<void> _pickDob() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(today.year - 10, today.month, today.day),
      firstDate: DateTime(1990),
      lastDate: today,
    );
    if (picked != null) {
      _idempotency.noteContentChanged();
      setState(() => _dob = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _pickIssueDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(today.year - 5, today.month, today.day),
      firstDate: DateTime(1990),
      lastDate: today,
    );
    if (picked != null) {
      _idempotency.noteContentChanged();
      setState(() => _issueDate = picked);
    }
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(today.year + 5, today.month, today.day),
      firstDate: _issueDate ?? today,
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked != null) {
      _idempotency.noteContentChanged();
      setState(() => _expiryDate = picked);
    }
  }

  static int _calendarAge(DateTime dob, DateTime today) {
    var age = today.year - dob.year;
    final beforeBirthday =
        today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day);
    if (beforeBirthday) age--;
    return age;
  }

  String? _validateDob(DateTime? dob) {
    final l10n = AppLocalizations.of(context);
    if (dob == null) return l10n.validationFailed;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (dob.isAfter(today)) return l10n.dobNotFuture;
    if (_calendarAge(dob, today) >= 18) return l10n.dobUnder18;
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);

    if (_frontPath == null) {
      setState(() => _errorMessage = l10n.frontImageRequired);
      return;
    }
    // Back image is required for a National Card (minor), optional otherwise.
    if (_isNationalCard && _backPath == null) {
      setState(() => _errorMessage = l10n.backImageRequired);
      return;
    }
    // Evidence (type + file) is required only for a legal guardian.
    if (_isLegalGuardian && (_evidencePath == null || _evidenceType == null)) {
      setState(() => _errorMessage = l10n.legalGuardianEvidenceRequired);
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
      issuingCountry: _isNationalCard
          ? 'IQ'
          : _issuingCountryController.text.trim().toUpperCase(),
      issueDate: _issueDate,
      expiryDate: _expiryDate,
      frontPath: _frontPath!,
      frontFilename: _frontName ?? 'front.jpg',
      backPath: _backPath,
      backFilename: _backName,
      evidenceType: _evidenceType,
      evidencePath: _evidencePath,
      evidenceFilename: _evidenceName,
    );
    try {
      await ref
          .read(minorsApiProvider)
          .create(submission, idempotencyKey: _idempotency.keyForSubmission());
      _idempotency.reset();
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
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.validationFailed
                      : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.dateOfBirth,
                  controller: TextEditingController(text: formatApiDate(_dob)),
                  readOnly: true,
                  onTap: _pickDob,
                  validator: (_) => _validateDob(_dob),
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
                  validator: (v) =>
                      !RegExp(r'^[A-Za-z]{2}$').hasMatch(v?.trim() ?? '')
                      ? l10n.validationFailed
                      : null,
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
                          child: Text(labels.relationshipLabel(r)),
                        ),
                  ],
                  onChanged: (v) => setState(() {
                    _relationship = v ?? _relationship;
                    _idempotency.noteContentChanged();
                  }),
                ),
                const Divider(height: 32),
                DropdownButtonFormField<IdentityDocumentType>(
                  initialValue: _docType,
                  decoration: InputDecoration(labelText: l10n.documentType),
                  items: [
                    // Backend accepts only primary minor identity documents.
                    for (final t in [
                      IdentityDocumentType.unifiedNationalCard,
                      IdentityDocumentType.birthDocument,
                    ])
                      DropdownMenuItem(
                        value: t,
                        child: Text(labels.identityTypeLabel(t)),
                      ),
                  ],
                  onChanged: (v) => setState(() {
                    _docType = v ?? _docType;
                    _idempotency.noteContentChanged();
                  }),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.documentNumber,
                  controller: _documentNumberController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.validationFailed
                      : null,
                ),
                if (_isNationalCard) ...[
                  const SizedBox(height: 14),
                  AppTextField(
                    label: l10n.nationalNumber,
                    controller: _nationalNumberController,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.nationalNumberRequired
                        : null,
                  ),
                ],
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.familyNumber,
                  controller: _familyNumberController,
                ),
                const SizedBox(height: 14),
                // Issuing country is a separate field from child nationality.
                AppTextField(
                  label: l10n.documentIssuingCountry,
                  controller: _issuingCountryController,
                  maxLength: 2,
                  readOnly: _isNationalCard,
                  validator: (v) {
                    if (_isNationalCard) {
                      return (v?.trim().toUpperCase() == 'IQ')
                          ? null
                          : l10n.validationFailed;
                    }
                    return !RegExp(r'^[A-Za-z]{2}$').hasMatch(v?.trim() ?? '')
                        ? l10n.validationFailed
                        : null;
                  },
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.issueDate,
                  controller: TextEditingController(
                    text: formatApiDate(_issueDate),
                  ),
                  readOnly: true,
                  onTap: _pickIssueDate,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.expiryDate,
                  controller: TextEditingController(
                    text: formatApiDate(_expiryDate),
                  ),
                  readOnly: true,
                  onTap: _pickExpiryDate,
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
                  onPick: () => _pickImage(front: false),
                ),
                if (_isLegalGuardian) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<EvidenceType>(
                    initialValue: _evidenceType,
                    decoration: InputDecoration(labelText: l10n.evidenceType),
                    items: [
                      for (final e in EvidenceType.values)
                        if (e != EvidenceType.unknown)
                          DropdownMenuItem(
                            value: e,
                            child: Text(_evidenceLabel(l10n, e)),
                          ),
                    ],
                    onChanged: (v) => setState(() {
                      _evidenceType = v;
                      _idempotency.noteContentChanged();
                    }),
                  ),
                  const SizedBox(height: 12),
                  _FileTile(
                    label: l10n.evidenceFile,
                    actionLabel: l10n.chooseFile,
                    path: _evidencePath,
                    onPick: _pickEvidence,
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

  String _evidenceLabel(AppLocalizations l10n, EvidenceType e) {
    switch (e) {
      case EvidenceType.legalGuardianshipDocument:
        return l10n.legalGuardianshipDocument;
      case EvidenceType.courtDocument:
        return l10n.courtDocument;
      case EvidenceType.otherOfficialEvidence:
        return l10n.otherOfficialEvidence;
      case EvidenceType.unknown:
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
  });

  final String label;
  final String actionLabel;
  final VoidCallback onPick;
  final String? path;

  @override
  Widget build(BuildContext context) {
    final hasFile = path != null;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasFile ? Icons.insert_drive_file : Icons.add,
                  color: scheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onPick,
                child: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
