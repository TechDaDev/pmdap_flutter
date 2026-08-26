import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/utils/uuid.dart';
import '../../../core/widgets/app_text_field.dart';
import '../application/minors_providers.dart';
import '../data/minors_api.dart';
import '../data/minor_identity_review.dart';
import '../../identity/data/extraction_models.dart';

typedef MinorImagePicker = Future<XFile?> Function();

final minorImagePickerProvider = Provider<MinorImagePicker>(
  (ref) =>
      () => ImagePicker().pickImage(source: ImageSource.gallery),
);

class MinorCreateScreen extends ConsumerStatefulWidget {
  const MinorCreateScreen({super.key});

  @override
  ConsumerState<MinorCreateScreen> createState() => _MinorCreateScreenState();
}

class _MinorCreateScreenState extends ConsumerState<MinorCreateScreen> {
  final _identityForm = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _fatherName = TextEditingController();
  final _grandfatherName = TextEditingController();
  final _motherName = TextEditingController();
  final _nationality = TextEditingController(text: 'IQ');
  final _documentNumber = TextEditingController();
  final _nationalNumber = TextEditingController();
  final _cardBodyNumber = TextEditingController();
  final _familyNumber = TextEditingController();
  final _issuingCountry = TextEditingController(text: 'IQ');
  final _idempotency = IdempotencyKeyManager();

  int _step = 0;
  DateTime? _dob;
  DateTime? _issueDate;
  DateTime? _expiryDate;
  Sex _sex = Sex.unspecified;
  BloodGroup _bloodGroup = BloodGroup.unknown;
  Relationship _relationship = Relationship.father;
  IdentityDocumentType _documentType = IdentityDocumentType.birthDocument;
  EvidenceType? _evidenceType;
  String? _frontPath;
  String? _frontName;
  String? _backPath;
  String? _backName;
  String? _evidencePath;
  String? _evidenceName;
  bool _extracting = false;
  bool _submitting = false;
  String? _notice;
  String? _error;
  String? _extractionJobId;

  bool get _isCard => _documentType == IdentityDocumentType.unifiedNationalCard;
  bool get _isLegalGuardian => _relationship == Relationship.legalGuardian;

  @override
  void initState() {
    super.initState();
    for (final controller in [
      _firstName,
      _fatherName,
      _grandfatherName,
      _motherName,
      _nationality,
      _documentNumber,
      _nationalNumber,
      _issuingCountry,
    ]) {
      controller.addListener(_idempotency.noteContentChanged);
    }
  }

  @override
  void dispose() {
    _firstName.dispose();
    _fatherName.dispose();
    _grandfatherName.dispose();
    _motherName.dispose();
    _nationality.dispose();
    _documentNumber.dispose();
    _nationalNumber.dispose();
    _cardBodyNumber.dispose();
    _familyNumber.dispose();
    _issuingCountry.dispose();
    super.dispose();
  }

  bool _supported(String name) {
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
  }

  void _clearCardExtraction() {
    _extractionJobId = null;
    for (final controller in [
      _firstName,
      _fatherName,
      _grandfatherName,
      _motherName,
      _nationalNumber,
      _cardBodyNumber,
      _familyNumber,
    ]) {
      controller.clear();
    }
    _notice = null;
  }

  Future<void> _pickImage(bool front) async {
    final file = await ref.read(minorImagePickerProvider)();
    if (file == null || !mounted) return;
    if (!_supported(file.name)) {
      setState(
        () => _error = AppLocalizations.of(context).unsupportedImageFormat,
      );
      return;
    }
    _idempotency.noteContentChanged();
    setState(() {
      _error = null;
      if (_isCard) _clearCardExtraction();
      if (front) {
        _frontPath = file.path;
        _frontName = file.name;
      } else {
        _backPath = file.path;
        _backName = file.name;
      }
    });
  }

  Future<void> _pickEvidence() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.isEmpty || !mounted) return;
    final file = result.files.first;
    if (file.path == null || !_supported(file.name)) {
      setState(
        () => _error = AppLocalizations.of(context).unsupportedImageFormat,
      );
      return;
    }
    _idempotency.noteContentChanged();
    setState(() {
      _evidencePath = file.path;
      _evidenceName = file.name;
      _error = null;
    });
  }

  Future<DateTime?> _pickDate({
    required DateTime initial,
    required DateTime first,
    required DateTime last,
  }) => showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: first,
    lastDate: last,
  );

  Future<void> _pickDob() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final value = await _pickDate(
      initial: _dob ?? DateTime(today.year - 10, today.month, today.day),
      first: DateTime(today.year - 18, today.month, today.day + 1),
      last: today,
    );
    if (value != null) {
      _idempotency.noteContentChanged();
      setState(() => _dob = value);
    }
  }

  Future<void> _pickIssueDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final value = await _pickDate(
      initial: _issueDate ?? today,
      first: DateTime(1990),
      last: today,
    );
    if (value != null) {
      _idempotency.noteContentChanged();
      setState(() => _issueDate = value);
    }
  }

  Future<void> _pickExpiryDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final value = await _pickDate(
      initial: _expiryDate ?? DateTime(today.year + 5),
      first: _issueDate ?? today,
      last: DateTime(2100, 12, 31),
    );
    if (value != null) {
      _idempotency.noteContentChanged();
      setState(() => _expiryDate = value);
    }
  }

  Future<void> _extract() async {
    final l10n = AppLocalizations.of(context);
    if (_frontPath == null || (_isCard && _backPath == null)) {
      setState(
        () => _error = _frontPath == null
            ? l10n.frontImageRequired
            : l10n.backImageRequired,
      );
      return;
    }
    setState(() {
      _extracting = true;
      _error = null;
      _notice = null;
    });
    try {
      final api = ref.read(identityApiProvider);
      final job = await api.extract(
        documentType: _documentType,
        frontPath: _frontPath!,
        backPath: _backPath,
      );
      ExtractionStatus? status;
      for (var attempt = 0; attempt < 30; attempt++) {
        status = await api.extractStatus(job.jobId);
        if (status.isTerminal) break;
        await Future<void>.delayed(const Duration(seconds: 2));
      }
      if (status?.status != ExtractionJobStatus.success ||
          status?.result == null) {
        throw const ApiException(
          code: 'identity_extraction_failed',
          message: 'Could not extract identity details.',
        );
      }
      _applyExtraction(status!.result!);
      setState(() {
        _extractionJobId = job.jobId;
        _notice = l10n.extractionReady;
      });
    } on ApiException catch (error) {
      setState(() => _error = error.message);
    } catch (_) {
      setState(() => _error = l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _extracting = false);
    }
  }

  void _applyExtraction(IdentityExtractionResult result) {
    String value(ExtractedIdentityField? field) => field?.value?.trim() ?? '';
    final review = MinorIdentityReview.fromExtraction(result);
    final document = value(result.documentNumber);
    final dob = parseApiDate(value(result.dateOfBirth));
    final sex = Sex.fromApi(value(result.sex).toUpperCase());
    final blood = BloodGroup.fromApi(value(result.bloodGroup).toUpperCase());
    final country = value(result.issuingCountry).toUpperCase();
    if (_isCard) {
      _firstName.text = review.firstName;
      _fatherName.text = review.fatherName;
      _grandfatherName.text = review.grandfatherName;
      _motherName.text = review.motherName;
      _nationalNumber.text = review.nationalNumber;
      _cardBodyNumber.text = review.cardBodyNumber;
      _familyNumber.text = review.familyNumber;
    } else {
      final name = value(result.name);
      if (name.isNotEmpty) _firstName.text = name;
      if (document.isNotEmpty) _documentNumber.text = document;
    }
    if (dob != null) _dob = dob;
    if (sex != Sex.unknown) _sex = sex;
    if (blood != BloodGroup.unknown) _bloodGroup = blood;
    if (country.length == 2) _issuingCountry.text = country;
    _idempotency.noteContentChanged();
  }

  bool _validateIdentity() {
    final l10n = AppLocalizations.of(context);
    if (!(_identityForm.currentState?.validate() ?? false)) return false;
    if (_isCard &&
        (_extractionJobId == null ||
            [
              _firstName,
              _fatherName,
              _grandfatherName,
              _nationalNumber,
              _cardBodyNumber,
              _familyNumber,
            ].any((controller) => controller.text.trim().isEmpty))) {
      setState(() => _error = l10n.validationFailed);
      return false;
    }
    final dobError = _validateDob(_dob);
    if (dobError != null) {
      setState(() => _error = dobError);
      return false;
    }
    if (_frontPath == null) {
      setState(() => _error = l10n.frontImageRequired);
      return false;
    }
    if (_isCard && _backPath == null) {
      setState(() => _error = l10n.backImageRequired);
      return false;
    }
    return true;
  }

  String? _validateDob(DateTime? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null) return l10n.validationFailed;
    final today = DateUtils.dateOnly(DateTime.now());
    if (value.isAfter(today)) return l10n.dobNotFuture;
    var age = today.year - value.year;
    if (today.month < value.month ||
        (today.month == value.month && today.day < value.day)) {
      age--;
    }
    return age >= 18 ? l10n.dobUnder18 : null;
  }

  void _continue() {
    if (_step == 0 && !_validateIdentity()) return;
    if (_step == 2 &&
        _isLegalGuardian &&
        (_evidenceType == null || _evidencePath == null)) {
      setState(
        () =>
            _error = AppLocalizations.of(context).legalGuardianEvidenceRequired,
      );
      return;
    }
    setState(() {
      _error = null;
      _step++;
    });
  }

  Future<void> _submit() async {
    if (_submitting || !_validateIdentity()) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _submitting = true;
      _error = null;
    });
    final submission = MinorCreateSubmission(
      firstName: _firstName.text.trim(),
      fatherName: _fatherName.text.trim(),
      grandfatherName: _grandfatherName.text.trim(),
      motherName: _motherName.text.trim(),
      dateOfBirth: _dob,
      sex: _sex,
      nationality: _nationality.text.trim().toUpperCase(),
      bloodGroup: _bloodGroup,
      relationship: _relationship,
      documentType: _documentType,
      documentNumber: _documentNumber.text.trim(),
      nationalNumber: _nationalNumber.text.trim(),
      extractionJobId: _isCard ? _extractionJobId : null,
      issuingCountry: _isCard
          ? 'IQ'
          : _issuingCountry.text.trim().toUpperCase(),
      issueDate: _issueDate,
      expiryDate: _expiryDate,
      frontPath: _isCard ? null : _frontPath,
      frontFilename: _isCard ? null : (_frontName ?? 'front.jpg'),
      backPath: _isCard ? null : _backPath,
      backFilename: _isCard ? null : _backName,
      evidenceType: _evidenceType,
      evidencePath: _evidencePath,
      evidenceFilename: _evidenceName,
    );
    try {
      await ref
          .read(minorsApiProvider)
          .create(submission, idempotencyKey: _idempotency.keyForSubmission());
      _idempotency.reset();
      ref.invalidate(guardianRelationshipsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.guardianRequestSent)));
      Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (error.statusCode == 409) {
        ref.invalidate(guardianRelationshipsProvider);
      }
      setState(
        () => _error = error.statusCode == 409
            ? l10n.relationshipAlreadyExists
            : error.message,
      );
    } catch (_) {
      setState(() => _error = l10n.minorCreateFailed);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addMinor)),
      body: SafeArea(
        child: Stepper(
          currentStep: _step,
          onStepContinue: _step == 3 ? _submit : _continue,
          onStepCancel: _step == 0 ? null : () => setState(() => _step--),
          controlsBuilder: (context, details) => Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SizedBox(
                  width: 144,
                  child: FilledButton(
                    onPressed: _submitting ? null : details.onStepContinue,
                    child: Text(_step == 3 ? l10n.submit : l10n.next),
                  ),
                ),
                if (_step > 0) ...[
                  SizedBox(
                    width: 96,
                    child: TextButton(
                      onPressed: _submitting ? null : details.onStepCancel,
                      child: Text(l10n.back),
                    ),
                  ),
                ],
              ],
            ),
          ),
          steps: [
            Step(
              title: Text(l10n.childIdentityStep),
              isActive: _step >= 0,
              state: _step > 0 ? StepState.complete : StepState.indexed,
              content: _identityStep(l10n),
            ),
            Step(
              title: Text(l10n.reviewChildDetails),
              isActive: _step >= 1,
              state: _step > 1 ? StepState.complete : StepState.indexed,
              content: _reviewStep(l10n),
            ),
            Step(
              title: Text(l10n.relationshipStep),
              isActive: _step >= 2,
              state: _step > 2 ? StepState.complete : StepState.indexed,
              content: _relationshipStep(l10n),
            ),
            Step(
              title: Text(l10n.submitRequestStep),
              isActive: _step >= 3,
              content: _submitStep(l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _identityStep(AppLocalizations l10n) {
    return Form(
      key: _identityForm,
      child: Column(
        children: [
          DropdownButtonFormField<IdentityDocumentType>(
            isExpanded: true,
            initialValue: _documentType,
            decoration: InputDecoration(labelText: l10n.documentType),
            items:
                [
                      IdentityDocumentType.birthDocument,
                      IdentityDocumentType.unifiedNationalCard,
                    ]
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(StatusLabels(l10n).identityTypeLabel(type)),
                      ),
                    )
                    .toList(),
            onChanged: (value) => setState(() {
              if (_documentType != value) _clearCardExtraction();
              _documentType = value ?? _documentType;
              _idempotency.noteContentChanged();
            }),
          ),
          const SizedBox(height: 12),
          _FileTile(
            label: l10n.frontImage,
            filename: _frontName,
            onTap: () => _pickImage(true),
          ),
          if (_isCard) ...[
            const SizedBox(height: 8),
            _FileTile(
              label: l10n.backImage,
              filename: _backName,
              onTap: () => _pickImage(false),
            ),
          ],
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _extracting ? null : _extract,
            icon: _extracting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.document_scanner_outlined),
            label: Text(
              _extracting
                  ? l10n.extractingCardDetails
                  : _extractionJobId == null
                  ? l10n.extractCardDetails
                  : l10n.rescan,
            ),
          ),
          const Divider(height: 28),
          if (_isCard) ...[
            _LockedIdentityField(label: l10n.firstName, value: _firstName.text),
            const SizedBox(height: 10),
            _LockedIdentityField(
              label: l10n.fathersName,
              value: _fatherName.text,
            ),
            const SizedBox(height: 10),
            _LockedIdentityField(
              label: l10n.grandfathersName,
              value: _grandfatherName.text,
            ),
            const SizedBox(height: 10),
            _LockedIdentityField(
              label: l10n.mothersName,
              value: _motherName.text,
            ),
          ] else
            AppTextField(
              label: l10n.fullName,
              controller: _firstName,
              validator: _required,
            ),
          const SizedBox(height: 10),
          AppTextField(
            label: l10n.dateOfBirth,
            controller: TextEditingController(text: formatApiDate(_dob)),
            readOnly: true,
            onTap: _pickDob,
            validator: (_) => _validateDob(_dob),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<Sex>(
            isExpanded: true,
            key: ValueKey(_sex),
            initialValue: _sex,
            decoration: InputDecoration(labelText: l10n.sex),
            items: [Sex.male, Sex.female, Sex.unspecified]
                .map(
                  (sex) => DropdownMenuItem(
                    value: sex,
                    child: Text(_sexLabel(l10n, sex)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              _idempotency.noteContentChanged();
              setState(() => _sex = value ?? _sex);
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<BloodGroup>(
            isExpanded: true,
            key: ValueKey(_bloodGroup),
            initialValue: _bloodGroup,
            decoration: InputDecoration(labelText: l10n.bloodGroup),
            items: BloodGroup.values
                .map(
                  (group) => DropdownMenuItem(
                    value: group,
                    child: Text(group == BloodGroup.unknown ? '—' : group.api),
                  ),
                )
                .toList(),
            onChanged: (value) {
              _idempotency.noteContentChanged();
              setState(() => _bloodGroup = value ?? _bloodGroup);
            },
          ),
          const SizedBox(height: 10),
          AppTextField(
            label: l10n.nationality,
            controller: _nationality,
            maxLength: 2,
            validator: _country,
          ),
          const SizedBox(height: 10),
          if (_isCard) ...[
            _LockedIdentityField(
              label: l10n.nationalNumber,
              value: _nationalNumber.text,
              forceLtr: true,
            ),
            const SizedBox(height: 10),
            _LockedIdentityField(
              label: l10n.cardBodyNumber,
              value: _cardBodyNumber.text,
              forceLtr: true,
            ),
            const SizedBox(height: 10),
            _LockedIdentityField(
              label: l10n.familyNumber,
              value: _familyNumber.text,
              forceLtr: true,
            ),
          ] else ...[
            AppTextField(
              label: l10n.documentNumber,
              controller: _documentNumber,
              validator: _required,
            ),
            const SizedBox(height: 10),
            AppTextField(
              label: l10n.documentIssuingCountry,
              controller: _issuingCountry,
              maxLength: 2,
              validator: _country,
            ),
            const SizedBox(height: 10),
            _DateButton(
              label: l10n.issueDate,
              value: _issueDate,
              onTap: _pickIssueDate,
            ),
            const SizedBox(height: 10),
            _DateButton(
              label: l10n.expiryDate,
              value: _expiryDate,
              onTap: _pickExpiryDate,
            ),
          ],
          if (_notice != null) ...[
            const SizedBox(height: 10),
            Text(
              _notice!,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
          _errorView(),
        ],
      ),
    );
  }

  Widget _reviewStep(AppLocalizations l10n) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (_isCard) ...[
        _ReviewRow(l10n.firstName, _firstName.text),
        _ReviewRow(l10n.fathersName, _fatherName.text),
        _ReviewRow(l10n.grandfathersName, _grandfatherName.text),
        _ReviewRow(l10n.mothersName, _motherName.text),
      ] else
        _ReviewRow(l10n.fullName, _firstName.text),
      _ReviewRow(l10n.dateOfBirth, formatApiDate(_dob)),
      _ReviewRow(l10n.sex, _sexLabel(l10n, _sex)),
      _ReviewRow(
        l10n.bloodGroup,
        _bloodGroup == BloodGroup.unknown ? '—' : _bloodGroup.api,
      ),
      _ReviewRow(
        l10n.documentType,
        StatusLabels(l10n).identityTypeLabel(_documentType),
      ),
      if (_isCard) ...[
        _ReviewRow(l10n.nationalNumber, _nationalNumber.text, forceLtr: true),
        _ReviewRow(l10n.cardBodyNumber, _cardBodyNumber.text, forceLtr: true),
        _ReviewRow(l10n.familyNumber, _familyNumber.text, forceLtr: true),
      ] else
        _ReviewRow(l10n.documentNumber, _documentNumber.text, forceLtr: true),
      _ReviewRow(l10n.nationality, _nationality.text.toUpperCase()),
      _errorView(),
    ],
  );

  Widget _relationshipStep(AppLocalizations l10n) {
    final labels = StatusLabels(l10n);
    return Column(
      children: [
        DropdownButtonFormField<Relationship>(
          isExpanded: true,
          initialValue: _relationship,
          decoration: InputDecoration(labelText: l10n.relationship),
          items: Relationship.values
              .where((item) => item != Relationship.unknown)
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(labels.relationshipLabel(item)),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() {
            _relationship = value ?? _relationship;
            _idempotency.noteContentChanged();
          }),
        ),
        if (_isLegalGuardian) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<EvidenceType>(
            isExpanded: true,
            initialValue: _evidenceType,
            decoration: InputDecoration(labelText: l10n.evidenceType),
            items: EvidenceType.values
                .where((item) => item != EvidenceType.unknown)
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(_evidenceLabel(l10n, item)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              _idempotency.noteContentChanged();
              setState(() => _evidenceType = value);
            },
          ),
          const SizedBox(height: 8),
          _FileTile(
            label: l10n.evidenceFile,
            filename: _evidenceName,
            onTap: _pickEvidence,
          ),
        ],
        _errorView(),
      ],
    );
  }

  Widget _submitStep(AppLocalizations l10n) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Icon(Icons.fact_check_outlined, size: 52),
      const SizedBox(height: 12),
      Text(l10n.myChildrenEmptyBody, textAlign: TextAlign.center),
      _errorView(),
    ],
  );

  Widget _errorView() => _error == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        );

  String? _required(String? value) => value == null || value.trim().isEmpty
      ? AppLocalizations.of(context).validationFailed
      : null;

  String? _country(String? value) =>
      RegExp(r'^[A-Za-z]{2}$').hasMatch(value?.trim() ?? '')
      ? null
      : AppLocalizations.of(context).validationFailed;

  String _sexLabel(AppLocalizations l10n, Sex value) => switch (value) {
    Sex.male => l10n.male,
    Sex.female => l10n.female,
    Sex.unspecified => l10n.unspecified,
    Sex.unknown => l10n.unknownStatus,
  };

  String _evidenceLabel(AppLocalizations l10n, EvidenceType value) =>
      switch (value) {
        EvidenceType.legalGuardianshipDocument =>
          l10n.legalGuardianshipDocument,
        EvidenceType.courtDocument => l10n.courtDocument,
        EvidenceType.otherOfficialEvidence => l10n.otherOfficialEvidence,
        EvidenceType.unknown => l10n.unknownStatus,
      };
}

class _LockedIdentityField extends StatelessWidget {
  const _LockedIdentityField({
    required this.label,
    required this.value,
    this.forceLtr = false,
  });

  final String label;
  final String value;
  final bool forceLtr;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    value: value,
    textField: true,
    readOnly: true,
    child: ExcludeSemantics(
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.lock_outline),
        ),
        child: Directionality(
          textDirection: forceLtr
              ? TextDirection.ltr
              : Directionality.of(context),
          child: Text(value.isEmpty ? '—' : value),
        ),
      ),
    ),
  );
}

class _FileTile extends StatelessWidget {
  const _FileTile({
    required this.label,
    required this.filename,
    required this.onTap,
  });
  final String label;
  final String? filename;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: ListTile(
      onTap: onTap,
      leading: const Icon(Icons.add_photo_alternate_outlined),
      title: Text(label),
      subtitle: filename == null ? null : Text(filename!),
      trailing: const Icon(Icons.chevron_right_rounded),
    ),
  );
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: const Icon(Icons.calendar_today_outlined),
    label: Text('$label: ${formatApiDate(value)}'),
  );
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow(this.label, this.value, {this.forceLtr = false});
  final String label;
  final String value;
  final bool forceLtr;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    subtitle: Directionality(
      textDirection: forceLtr ? TextDirection.ltr : Directionality.of(context),
      child: Text(value.isEmpty ? '—' : value),
    ),
  );
}
