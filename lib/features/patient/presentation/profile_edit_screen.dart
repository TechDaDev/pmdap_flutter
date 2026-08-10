import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../patient/application/patient_providers.dart';

/// Edit the backend-approved editable profile fields only.
/// Immutable verified fields (Digital ID, identity state) are never editable.
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _nationalityController = TextEditingController();
  DateTime? _dob;
  Sex _sex = Sex.unspecified;
  BloodGroup _bloodGroup = BloodGroup.unknown;
  bool _saving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(patientProfileProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfile)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGeneric)),
        data: (profile) {
          if (_fullNameController.text.isEmpty) {
            _fullNameController.text = profile.fullName;
            _nationalityController.text = profile.nationality;
            _dob = profile.dateOfBirth;
            _sex = profile.sex;
            _bloodGroup = profile.bloodGroup;
          }
          return SingleChildScrollView(
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
                    controller: TextEditingController(
                      text: formatApiDate(_dob),
                    ),
                    readOnly: true,
                    onTap: _pickDob,
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
                    onChanged: (v) =>
                        setState(() => _sex = v ?? Sex.unspecified),
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
                      for (final b in BloodGroup.values)
                        DropdownMenuItem(
                          value: b,
                          child: Text(b == BloodGroup.unknown ? '—' : b.api),
                        ),
                    ],
                    onChanged: (v) =>
                        setState(() => _bloodGroup = v ?? BloodGroup.unknown),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: l10n.saveChanges,
                    onPressed: _saving ? null : _save,
                    loading: _saving,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 30, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      await ref
          .read(patientApiProvider)
          .update(
            fullName: _fullNameController.text.trim(),
            dateOfBirth: _dob,
            sex: _sex,
            nationality: _nationalityController.text.trim().toUpperCase(),
            bloodGroup: _bloodGroup,
          );
      ref.invalidate(patientProfileProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.saveChanges)));
        Navigator.of(context).maybePop();
      }
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      setState(() => _errorMessage = l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
