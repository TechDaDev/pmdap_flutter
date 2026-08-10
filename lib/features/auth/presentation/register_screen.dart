import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/session_controller.dart';
import '../data/auth_api.dart';

/// Registration — uses the real backend schema. The backend creates
/// User + PatientProfile + Digital ID and is the authority on role/status.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _nationalityController = TextEditingController();

  DateTime? _dob;
  Sex _sex = Sex.unspecified;
  BloodGroup _bloodGroup = BloodGroup.unknown;
  bool _obscure = true;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 30, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: AppLocalizations.of(context).dateOfBirth,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    try {
      await ref
          .read(sessionControllerProvider.notifier)
          .register(
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
            patient: PatientRegistrationInput(
              fullName: _fullNameController.text.trim(),
              dateOfBirth: _dob,
              sex: _sex,
              nationality: _nationalityController.text.trim().toUpperCase(),
              bloodGroup: _bloodGroup,
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.registrationSuccess)));
      context.go(Routes.login);
    } on ApiException catch (e) {
      setState(() => _errorMessage = _messageFor(e));
    } catch (_) {
      setState(() => _errorMessage = l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _messageFor(ApiException e) {
    final l10n = AppLocalizations.of(context);
    if (e.isThrottled) return l10n.throttled;
    if (e.isNetwork || e.isTimeout) return l10n.networkError;
    if (e.code == 'validation_error') {
      return e.firstFieldMessage ?? l10n.validationFailed;
    }
    return e.message;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.registerSubtitle,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      label: l10n.fullName,
                      controller: _fullNameController,
                      prefixIcon: const Icon(Icons.person_outline),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: l10n.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.mail_outline),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: l10n.phone,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: l10n.dateOfBirth,
                      controller: TextEditingController(
                        text: formatApiDate(_dob),
                      ),
                      readOnly: true,
                      onTap: _pickDob,
                      prefixIcon: const Icon(Icons.event_outlined),
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
                      textInputAction: TextInputAction.next,
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
                        for (final b in [
                          BloodGroup.aPos,
                          BloodGroup.aNeg,
                          BloodGroup.bPos,
                          BloodGroup.bNeg,
                          BloodGroup.abPos,
                          BloodGroup.abNeg,
                          BloodGroup.oPos,
                          BloodGroup.oNeg,
                        ])
                          DropdownMenuItem(value: b, child: Text(b.api)),
                      ],
                      onChanged: (v) =>
                          setState(() => _bloodGroup = v ?? BloodGroup.unknown),
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: l10n.password,
                      controller: _passwordController,
                      obscureText: _obscure,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: l10n.createAccount,
                      onPressed: _submitting ? null : _submit,
                      loading: _submitting,
                    ),
                  ],
                ),
              ),
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
