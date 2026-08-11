import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/identity_providers.dart';
import '../data/identity_api.dart';

/// Pre-camera identity submission. The action is clearly labeled
/// "Choose existing image" — NO camera capture yet.
class IdentitySubmitScreen extends ConsumerStatefulWidget {
  const IdentitySubmitScreen({super.key, this.replaceUuid});

  final String? replaceUuid;

  @override
  ConsumerState<IdentitySubmitScreen> createState() =>
      _IdentitySubmitScreenState();
}

class _IdentitySubmitScreenState extends ConsumerState<IdentitySubmitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _documentNumberController = TextEditingController();
  final _nationalNumberController = TextEditingController();
  final _familyNumberController = TextEditingController();
  final _countryController = TextEditingController(text: 'IQ');

  IdentityDocumentType _docType = IdentityDocumentType.unifiedNationalCard;
  DateTime? _issueDate;
  DateTime? _expiryDate;

  String? _frontPath;
  String? _frontName;
  String? _backPath;
  String? _backName;

  bool _submitting = false;
  String? _errorMessage;

  bool get _isNationalCard =>
      _docType == IdentityDocumentType.unifiedNationalCard;
  bool get _isPassport => _docType == IdentityDocumentType.passport;

  @override
  void dispose() {
    _documentNumberController.dispose();
    _nationalNumberController.dispose();
    _familyNumberController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  static bool _supportsImage(String? name) {
    if (name == null) return false;
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
  }

  Future<void> _pickImage({required bool front}) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    if (!_supportsImage(xfile.name)) {
      setState(
        () =>
            _errorMessage = AppLocalizations.of(context).unsupportedImageFormat,
      );
      return;
    }
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

  Future<void> _pickDate({required bool issue}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: issue
          ? (_issueDate ?? DateTime(today.year - 2, today.month, today.day))
          : (_expiryDate ?? DateTime(today.year + 5, today.month, today.day)),
      // issue_date cannot be in the future; expiry must be >= today and after
      // the issue date.
      firstDate: issue ? DateTime(1900) : (_issueDate ?? today),
      lastDate: issue ? today : DateTime(2100, 12, 31),
    );
    if (picked != null) {
      setState(() => issue ? _issueDate = picked : _expiryDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    if (_frontPath == null) {
      setState(() => _errorMessage = l10n.selectImageRequired);
      return;
    }
    // National Card and adult submissions require a back image.
    if (_isNationalCard && _backPath == null) {
      setState(() => _errorMessage = l10n.backImageRequired);
      return;
    }
    if (_isNationalCard &&
        (_nationalNumberController.text.trim().isEmpty ||
            _familyNumberController.text.trim().isEmpty)) {
      setState(() => _errorMessage = l10n.nationalNumberRequired);
      return;
    }
    if (_isPassport && (_issueDate == null || _expiryDate == null)) {
      setState(() => _errorMessage = l10n.validationFailed);
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final submission = IdentitySubmission(
      documentType: _docType,
      documentNumber: _documentNumberController.text.trim(),
      nationalNumber: _nationalNumberController.text.trim(),
      familyNumber: _familyNumberController.text.trim(),
      issuingCountry: _isNationalCard
          ? 'IQ'
          : _countryController.text.trim().toUpperCase(),
      issueDate: _issueDate,
      expiryDate: _expiryDate,
      frontPath: _frontPath!,
      frontFilename: _frontName ?? 'front.jpg',
      backPath: _backPath,
      backFilename: _backName,
    );
    try {
      final api = ref.read(identityApiProvider);
      if (widget.replaceUuid != null) {
        await api.replace(widget.replaceUuid!, submission);
      } else {
        await api.submit(submission);
      }
      ref.invalidate(identityDocumentsProvider);
      if (widget.replaceUuid != null) {
        ref.invalidate(identityDocumentDetailProvider(widget.replaceUuid!));
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.identitySubmitted)));
      Navigator.of(context).maybePop();
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      setState(() => _errorMessage = l10n.errorGeneric);
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<IdentityDocumentType>(
                  initialValue: _docType,
                  decoration: InputDecoration(labelText: l10n.documentType),
                  items: [
                    for (final t in IdentityDocumentType.values)
                      if (t != IdentityDocumentType.unknown)
                        DropdownMenuItem(
                          value: t,
                          child: Text(labels.identityTypeLabel(t)),
                        ),
                  ],
                  onChanged: (v) => setState(() => _docType = v ?? _docType),
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
                  const SizedBox(height: 14),
                  AppTextField(
                    label: l10n.familyNumber,
                    controller: _familyNumberController,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.validationFailed
                        : null,
                  ),
                ],
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.issuingCountry,
                  controller: _countryController,
                  maxLength: 2,
                  readOnly: _isNationalCard,
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (_isNationalCard) {
                      return s.toUpperCase() == 'IQ'
                          ? null
                          : l10n.validationFailed;
                    }
                    return RegExp(r'^[A-Za-z]{2}$').hasMatch(s)
                        ? null
                        : l10n.validationFailed;
                  },
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.issueDate,
                  controller: TextEditingController(
                    text: formatApiDate(_issueDate),
                  ),
                  readOnly: true,
                  onTap: () => _pickDate(issue: true),
                  validator: (_) => _isPassport && _issueDate == null
                      ? l10n.validationFailed
                      : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.expiryDate,
                  controller: TextEditingController(
                    text: formatApiDate(_expiryDate),
                  ),
                  readOnly: true,
                  onTap: () => _pickDate(issue: false),
                  validator: (_) => _isPassport && _expiryDate == null
                      ? l10n.validationFailed
                      : null,
                ),
                const SizedBox(height: 20),
                _ImagePickerTile(
                  label: l10n.frontImage,
                  actionLabel: l10n.chooseExistingImage,
                  path: _frontPath,
                  onPick: () => _pickImage(front: true),
                ),
                const SizedBox(height: 12),
                _ImagePickerTile(
                  label: l10n.backImage,
                  actionLabel: l10n.chooseExistingImage,
                  path: _backPath,
                  optional: !_isNationalCard,
                  onPick: () => _pickImage(front: false),
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
                  label: l10n.submitIdentity,
                  onPressed: _submitting ? null : _submit,
                  loading: _submitting,
                  icon: Icons.upload_file,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePickerTile extends StatelessWidget {
  const _ImagePickerTile({
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
    final hasImage = path != null;
    return Card(
      child: ListTile(
        leading: Icon(
          hasImage ? Icons.image : Icons.add_photo_alternate_outlined,
        ),
        title: Text(label),
        subtitle: Text(hasImage ? path! : (optional ? '' : '')),
        trailing: hasImage
            ? IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onPick,
                tooltip: 'Change',
              )
            : OutlinedButton(onPressed: onPick, child: Text(actionLabel)),
      ),
    );
  }
}
