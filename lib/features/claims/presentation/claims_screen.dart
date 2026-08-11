import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../data/claims_api.dart';

/// Public account-claim entry point (patient app). Basic submission screen.
class ClaimsScreen extends ConsumerStatefulWidget {
  const ClaimsScreen({super.key});

  @override
  ConsumerState<ClaimsScreen> createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends ConsumerState<ClaimsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _digitalIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _idNumberController = TextEditingController();

  DateTime? _dob;
  String? _frontPath;
  String? _frontName;
  String? _backPath;
  String? _backName;

  bool _submitting = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _digitalIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _fullNameController.dispose();
    _idNumberController.dispose();
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

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 30, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    if (_frontPath == null || _backPath == null || _dob == null) {
      setState(() => _errorMessage = l10n.validationFailed);
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
      _successMessage = null;
    });
    final submission = ClaimSubmission(
      digitalId: _digitalIdController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      fullName: _fullNameController.text.trim(),
      dateOfBirth: _dob,
      identityDocumentType: 'UNIFIED_NATIONAL_CARD',
      identityDocumentNumber: _idNumberController.text.trim(),
      frontPath: _frontPath!,
      frontFilename: _frontName ?? 'front.jpg',
      backPath: _backPath!,
      backFilename: _backName ?? 'back.jpg',
    );
    try {
      await ref.read(claimsApiProvider).submit(submission);
      // Privacy-preserving receipt: never claim a patient was found/matched.
      setState(() => _successMessage = l10n.claimSubmittedReview);
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      setState(() => _errorMessage = l10n.claimFailed);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.claimTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.claimSubtitle, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 20),
                AppTextField(
                  label: l10n.claimDigitalId,
                  controller: _digitalIdController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.validationFailed
                      : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.claimEmail,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s)
                        ? null
                        : l10n.validationFailed;
                  },
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.claimPhone,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    // Backend E.164-style: ^\+?[1-9]\d{7,14}$
                    final s = v?.trim() ?? '';
                    return RegExp(r'^\+?[1-9]\d{7,14}$').hasMatch(s)
                        ? null
                        : l10n.validationFailed;
                  },
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.claimFullName,
                  controller: _fullNameController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.validationFailed
                      : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.claimDob,
                  controller: TextEditingController(text: formatApiDate(_dob)),
                  readOnly: true,
                  onTap: _pickDob,
                  validator: (_) => _dob == null ? l10n.validationFailed : null,
                ),
                const SizedBox(height: 14),
                // Identity type is fixed: only a Unified National Card claim.
                AppTextField(
                  label: l10n.claimIdType,
                  controller: TextEditingController(
                    text: l10n.claimTypeNationalCard,
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.claimIdNumber,
                  controller: _idNumberController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.validationFailed
                      : null,
                ),
                const SizedBox(height: 20),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.add_photo_alternate_outlined),
                    title: Text(l10n.frontImage),
                    subtitle: Text(_frontPath ?? ''),
                    trailing: _frontPath != null
                        ? IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () => _pickImage(front: true),
                          )
                        : OutlinedButton(
                            onPressed: () => _pickImage(front: true),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 40),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            child: Text(l10n.chooseExistingImage),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.add_photo_alternate_outlined),
                    title: Text(l10n.backImage),
                    subtitle: Text(_backPath ?? ''),
                    trailing: _backPath != null
                        ? IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () => _pickImage(front: false),
                          )
                        : OutlinedButton(
                            onPressed: () => _pickImage(front: false),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 40),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            child: Text(l10n.chooseExistingImage),
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
                if (_successMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _successMessage!,
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ],
                const SizedBox(height: 24),
                PrimaryButton(
                  label: l10n.claimSubmit,
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
}
