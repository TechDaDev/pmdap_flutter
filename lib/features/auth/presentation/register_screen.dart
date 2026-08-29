import 'package:flutter/material.dart' hide Page;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../../documents/scanner/document_scanner.dart';
import '../../identity/data/extraction_models.dart';
import '../application/registration_controller.dart';

/// SCAN-FIRST Iraqi patient registration.
///
/// Screen 1: account (email/password/confirm/phone/governorate) + the Iraqi
/// National Card front/back capture. Extraction is ADVISORY; the review step
/// shows every detected field with confidence, lets the user correct, and
/// requires an explicit confirmation before the atomic account creation.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

/// Iraqi governorate codes (stable backend enum). Labels resolve through the
/// l10n switch in [_RegisterScreenState.governorateLabel] so Arabic localizes
/// without dynamic lookup.
const List<String> _governorates = [
  'AL_ANBAR',
  'AL_QADISIYYAH',
  'BABIL',
  'BAGHDAD',
  'BASRA',
  'DHI_QAR',
  'DIYALA',
  'DUHOK',
  'ERBIL',
  'HALABJA',
  'KARBALA',
  'KIRKUK',
  'MAYSAN',
  'MUTHANNA',
  'NAJAF',
  'NINEVEH',
  'SALADIN',
  'SULAYMANIYAH',
  'WASIT',
];

/// Review fields in display order — used to scroll to the FIRST invalid one.
enum _ReviewFieldKey {
  name,
  fatherName,
  grandfatherName,
  motherName,
  sex,
  dateOfBirth,
  bloodGroup,
  nationalCardNumber,
  familyNumber,
  uniqueCardBodyNumber,
  confirmation,
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Account step.
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String _governorate = '';

  // Review step (kept in sync with the controller review state).
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _grandfatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _familyNumberController = TextEditingController();
  final _bodyNumberController = TextEditingController();

  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _capturing = false;
  bool _reviewInitialized = false;
  final _passwordFocus = FocusNode();

  // Email-verification step (M31B).
  final _otpController = TextEditingController();
  final _otpFocus = FocusNode();

  /// Stable per-field targets for scroll-to-first-error + inline messages.
  final Map<_ReviewFieldKey, GlobalKey> _reviewFieldKeys = {
    for (final k in _ReviewFieldKey.values) k: GlobalKey(),
  };
  Map<_ReviewFieldKey, String> _reviewErrors = const {};

  @override
  void initState() {
    super.initState();
    // Resume-safe: restore a persisted registration session (verification
    // survives app restart). Runs after the first frame so the splash/UI is
    // not blocked.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.tryResumeRegistration();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _otpController.dispose();
    _otpFocus.dispose();
    _nameController.dispose();
    _fatherNameController.dispose();
    _grandfatherNameController.dispose();
    _motherNameController.dispose();
    _cardNumberController.dispose();
    _familyNumberController.dispose();
    _bodyNumberController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  RegistrationController get _controller =>
      ref.read(registrationControllerProvider.notifier);

  AppLocalizations get l10n => AppLocalizations.of(context);

  String _governorateLabel(String code) {
    return switch (code) {
      'AL_ANBAR' => l10n.governorateAlAnbar,
      'AL_QADISIYYAH' => l10n.governorateAlQadisiyyah,
      'BABIL' => l10n.governorateBabil,
      'BAGHDAD' => l10n.governorateBaghdad,
      'BASRA' => l10n.governorateBasra,
      'DHI_QAR' => l10n.governorateDhiQar,
      'DIYALA' => l10n.governorateDiyala,
      'DUHOK' => l10n.governorateDuhok,
      'ERBIL' => l10n.governorateErbil,
      'HALABJA' => l10n.governorateHalabja,
      'KARBALA' => l10n.governorateKarbala,
      'KIRKUK' => l10n.governorateKirkuk,
      'MAYSAN' => l10n.governorateMaysan,
      'MUTHANNA' => l10n.governorateMuthanna,
      'NAJAF' => l10n.governorateNajaf,
      'NINEVEH' => l10n.governorateNineveh,
      'SALADIN' => l10n.governorateSaladin,
      'SULAYMANIYAH' => l10n.governorateSulaymaniyah,
      'WASIT' => l10n.governorateWasit,
      _ => code,
    };
  }

  bool _supportsImage(String? name) {
    if (name == null) return false;
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
  }

  /// Maps the poll-loop terminal error key to a localized scan-step message.
  String _scanErrorMessage(String key) {
    switch (key) {
      case 'session_invalid':
        return l10n.errorRegistrationSessionInvalid;
      case 'session_expired':
        return l10n.errorRegistrationExpired;
      case 'server_error':
        return l10n.serverError;
      case 'extraction_failed':
        return l10n.documentReadingFailed;
      default:
        return l10n.errorGeneric;
    }
  }

  Future<void> _scanSide({required bool front}) async {
    if (_capturing) return;
    setState(() => _capturing = true);
    try {
      final result = await scanDocument();
      if (result.cancelled) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.scanCancelled)));
        }
        return;
      }
      if (result.pagePaths.isNotEmpty) {
        _controller.setScannedPaths(
          front: front ? result.pagePaths.first : null,
          back: front ? null : result.pagePaths.first,
        );
      }
    } on ScannerUnavailableException {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.scannerUnavailable)));
      }
    } finally {
      if (mounted) setState(() => _capturing = false);
    }
  }

  Future<void> _pickImage({required bool front}) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    if (!_supportsImage(xfile.name)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.unsupportedImageFormat)));
      }
      return;
    }
    _controller.setScannedPaths(
      front: front ? xfile.path : null,
      back: front ? null : xfile.path,
    );
  }

  Future<void> _submitAccount() async {
    if (!_formKey.currentState!.validate()) return;
    final password = _passwordController.text;
    if (password != _confirmController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.confirmPasswordMismatch)));
      return;
    }
    if (_governorate.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.validationFailed)));
      return;
    }
    _controller.setCredentials(
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: password,
      governorate: _governorate,
    );
  }

  void _syncReviewControllers(RegistrationFlowState state) {
    _nameController.text = state.review.name;
    _fatherNameController.text = state.review.fatherName;
    _grandfatherNameController.text = state.review.grandfatherName;
    _motherNameController.text = state.review.motherName;
    _cardNumberController.text = state.review.nationalCardNumber;
    _familyNumberController.text = state.review.familyNumber;
    _bodyNumberController.text = state.review.uniqueCardBodyNumber;
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final state = ref.read(registrationControllerProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: state.review.dateOfBirth ?? DateTime(now.year - 30, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: l10n.dateOfBirth,
    );
    if (picked != null) {
      _controller.updateReview(state.review.copyWith(dateOfBirth: picked));
    }
  }

  /// Deterministic review validation. Mirrors the final-registration
  /// contract: Arabic-safe name components, canonical sex, canonical DOB
  /// (never the localized display string), non-empty identifiers. Blood
  /// group is NOT required (backend stores UNKNOWN when OCR misses it).
  /// Low OCR confidence never blocks — only structural validity does.
  Map<_ReviewFieldKey, String> _validateReview(
    RegistrationReviewValues review,
  ) {
    final errors = <_ReviewFieldKey, String>{};
    if (review.name.trim().isEmpty) {
      errors[_ReviewFieldKey.name] = l10n.requiredField;
    }
    if (review.fatherName.trim().isEmpty) {
      errors[_ReviewFieldKey.fatherName] = l10n.requiredField;
    }
    if (review.grandfatherName.trim().isEmpty) {
      errors[_ReviewFieldKey.grandfatherName] = l10n.requiredField;
    }
    if (review.sex != Sex.male && review.sex != Sex.female) {
      errors[_ReviewFieldKey.sex] = l10n.selectSex;
    }
    final dob = review.dateOfBirth;
    if (dob == null) {
      errors[_ReviewFieldKey.dateOfBirth] = l10n.requiredField;
    } else if (dob.isAfter(DateTime.now())) {
      errors[_ReviewFieldKey.dateOfBirth] = l10n.dobNotFuture;
    }
    if (review.nationalCardNumber.trim().isEmpty) {
      errors[_ReviewFieldKey.nationalCardNumber] = l10n.requiredField;
    }
    if (review.familyNumber.trim().isEmpty) {
      errors[_ReviewFieldKey.familyNumber] = l10n.requiredField;
    }
    if (review.uniqueCardBodyNumber.trim().isEmpty) {
      errors[_ReviewFieldKey.uniqueCardBodyNumber] = l10n.requiredField;
    }
    if (!review.confirmation) {
      errors[_ReviewFieldKey.confirmation] = l10n.confirmRequired;
    }
    return errors;
  }

  void _clearFieldError(_ReviewFieldKey key) {
    if (_reviewErrors.containsKey(key)) {
      setState(() {
        _reviewErrors = Map.of(_reviewErrors)..remove(key);
      });
    }
  }

  void _scrollToFirstError(Map<_ReviewFieldKey, String> errors) {
    for (final key in _ReviewFieldKey.values) {
      if (!errors.containsKey(key)) continue;
      final ctx = _reviewFieldKeys[key]?.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
          alignment: 0.2,
        );
        break;
      }
    }
  }

  Future<void> _submitReview() async {
    final state = ref.read(registrationControllerProvider);
    final review = state.review.copyWith(
      name: _nameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      grandfatherName: _grandfatherNameController.text.trim(),
      motherName: _motherNameController.text.trim(),
      nationalCardNumber: _cardNumberController.text.trim(),
      documentNumber: _cardNumberController.text.trim(),
      familyNumber: _familyNumberController.text.trim(),
      uniqueCardBodyNumber: _bodyNumberController.text.trim(),
    );
    final errors = _validateReview(review);
    if (errors.isNotEmpty) {
      setState(() => _reviewErrors = errors);
      _scrollToFirstError(errors);
      return;
    }
    setState(() => _reviewErrors = const {});
    _controller.updateReview(review);
    final ok = await _controller.submit();
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.registrationSuccess)));
      context.go(Routes.login);
    } else {
      final err = ref.read(registrationControllerProvider).submitError;
      // Backend password errors are already shown inline on Step 1 (with the
      // field focused); a snackbar would just duplicate the message.
      final isPasswordError = err?.details.containsKey('password') ?? false;
      if (!isPasswordError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_submitErrorMessage(err))));
      }
    }
  }

  /// Maps a backend final-registration error to a safe, localized message.
  /// Specific codes (email exists, expired/consumed session, card conflict)
  /// get a useful message; generic 5xx/unknown falls back to the last resort.
  String _submitErrorMessage(ApiException? e) {
    if (e == null) return l10n.errorGeneric;
    switch (e.code) {
      case 'validation_error':
        if (e.details.containsKey('email')) return l10n.errorEmailExists;
        if (e.details.containsKey('registration_identity')) {
          return l10n.errorCardAlreadyRegistered;
        }
        // Show the backend's specific field message (e.g. an adult-ownership
        // DOB rejection) instead of an unhelpful generic validation hint.
        final fieldMsg = e.firstFieldMessage;
        return fieldMsg ?? l10n.validationFailed;
      case 'registration_job_expired':
        return l10n.errorRegistrationExpired;
      case 'registration_job_conflict':
        return l10n.errorRegistrationAlreadyCompleted;
      case 'registration_job_not_found':
        return l10n.errorRegistrationSessionInvalid;
      case 'registration_storage_failed':
        return l10n.errorGeneric;
      case 'connection_timeout':
      case 'send_timeout':
      case 'receive_timeout':
      case 'request_cancelled':
      case 'network_error':
        return l10n.networkError;
      default:
        if (e.isThrottled) return l10n.throttled;
        if (e.statusCode != null && e.statusCode! >= 500) {
          return l10n.serverError;
        }
        return l10n.errorGeneric;
    }
  }

  /// Wizard back navigation: Step 1 exits to Login, Step 2 (verify) returns to
  /// Step 1, Step 3 returns to Step 1, Step 4 returns to Step 3. Never traps
  /// the registration route in the navigation stack.
  void _handleBack() {
    final step = ref.read(registrationControllerProvider).step;
    switch (step) {
      case RegistrationStep.account:
        _controller.reset();
        context.go(Routes.login);
      case RegistrationStep.verifyEmail:
        _controller.backToAccount();
      case RegistrationStep.scan:
        _controller.backToAccount();
      case RegistrationStep.review:
        _controller.backToScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationControllerProvider);
    if (state.step != RegistrationStep.review) {
      // Leaving the review step lets the next visit re-sync from scratch.
      _reviewInitialized = false;
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.registerTitle),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: l10n.back,
            onPressed: _handleBack,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: switch (state.step) {
                RegistrationStep.account => _accountStep(state),
                RegistrationStep.verifyEmail => _verifyEmailStep(state),
                RegistrationStep.scan => _scanStep(state),
                RegistrationStep.review => _reviewStep(state),
              },
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // STEP 1 — Account details only
  // ---------------------------------------------------------------------
  Widget _accountStep(RegistrationFlowState state) {
    final theme = Theme.of(context);
    // Returning from a rejected final registration (backend password error):
    // put focus on Password so the fix is one edit away.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.passwordError != null && mounted) {
        _passwordFocus.requestFocus();
      }
    });
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.accountStepTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          AppTextField(
            label: l10n.email,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                (v == null || !v.contains('@')) ? l10n.validationFailed : null,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: l10n.phone,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (_) => null,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: l10n.password,
            controller: _passwordController,
            focusNode: _passwordFocus,
            obscureText: _obscure,
            errorText: state.passwordError,
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
            validator: (v) =>
                (v == null || v.length < 8) ? l10n.validationFailed : null,
            onChanged: (_) => _controller.clearPasswordError(),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: l10n.confirmPassword,
            controller: _confirmController,
            obscureText: _obscureConfirm,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            validator: (_) => null,
          ),
          const SizedBox(height: 12),
          _GovernorateField(
            label: l10n.governorate,
            value: _governorate,
            labelOf: _governorateLabel,
            onChanged: (v) => setState(() => _governorate = v ?? ''),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: l10n.continueAction,
            onPressed: _submitAccount,
            icon: Icons.arrow_forward,
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {
                _controller.reset();
                context.go(Routes.login);
              },
              child: Text(l10n.signInPrompt),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // STEP 2 — Email verification (M31B). Required before identity OCR.
  // ---------------------------------------------------------------------
  Widget _verifyEmailStep(RegistrationFlowState state) {
    final theme = Theme.of(context);
    final masked = state.maskedEmail.isNotEmpty
        ? state.maskedEmail
        : l10n.yourEmail;
    final countdown = state.resendCountdown;
    final errorKey = state.verifyError;
    final otpDigits = _otpController.text.trim();
    final verifyEnabled = otpDigits.length == 6 && !state.verifyBusy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.verifyEmailTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          l10n.verifyEmailSubtitle(masked),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _otpController,
          focusNode: _otpFocus,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(letterSpacing: 12),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofillHints: const [AutofillHints.oneTimeCode],
          onChanged: (_) {
            if (errorKey != null) _controller.clearVerifyError();
            setState(() {});
          },
          decoration: InputDecoration(labelText: l10n.otpCode, counterText: ''),
          onFieldSubmitted: (_) {
            if (verifyEnabled) {
              _controller.verifyEmailCode(_otpController.text.trim());
            }
          },
        ),
        const SizedBox(height: 16),
        if (errorKey != null) ...[
          Text(
            _verifyErrorMessage(errorKey),
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.error),
          ),
          const SizedBox(height: 12),
        ],
        PrimaryButton(
          label: state.verifyBusy ? l10n.verifying : l10n.verifyEmailAction,
          onPressed: verifyEnabled
              ? () => _controller.verifyEmailCode(otpDigits)
              : null,
          icon: Icons.verified_outlined,
        ),
        const SizedBox(height: 12),
        Center(
          child: countdown > 0
              ? Text(l10n.resendIn(countdown), style: theme.textTheme.bodySmall)
              : TextButton(
                  onPressed: state.verifyBusy
                      ? null
                      : _controller.resendEmailVerification,
                  child: Text(l10n.resendCode),
                ),
        ),
        // Abandon this session and restart (e.g. to use a different email).
        const SizedBox(height: 4),
        Center(
          child: TextButton(
            onPressed: state.verifyBusy ? null : _controller.startOver,
            child: Text(l10n.startOver),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _controller.backToAccount,
            child: Text(l10n.back),
          ),
        ),
      ],
    );
  }

  /// Maps the controller's verification error key to a localized message.
  String _verifyErrorMessage(String key) {
    switch (key) {
      case 'invalid_code':
        return l10n.codeInvalid;
      case 'code_expired':
        return l10n.codeExpired;
      case 'code_locked':
        return l10n.emailLocked;
      case 'throttled':
        return l10n.throttled;
      case 'session_expired':
        return l10n.errorRegistrationExpired;
      case 'network':
        return l10n.networkError;
      case 'server_error':
        return l10n.serverError;
      case 'delivery_failed':
        return l10n.verificationCodeNotSent;
      default:
        return l10n.verificationFailed;
    }
  }

  // ---------------------------------------------------------------------
  // STEP 3 — Verify identity (National Card image controls live here ONLY)
  // ---------------------------------------------------------------------
  Widget _scanStep(RegistrationFlowState state) {
    final theme = Theme.of(context);
    final alreadyRead =
        state.jobId != null &&
        state.extractionResult != null &&
        state.extractionStatus == ExtractionJobStatus.success;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.verifyIdentityTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          l10n.verifyIdentityDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        if (alreadyRead) ...[
          Row(
            children: [
              Icon(Icons.check_circle, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.identityAlreadyRead,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: l10n.continueToReview,
            onPressed: _controller.goToReview,
            icon: Icons.arrow_forward,
          ),
        ] else ...[
          _SideCapture(
            label: l10n.scanFront,
            path: state.frontPath,
            onScan: _capturing ? null : () => _scanSide(front: true),
            onPick: _capturing ? null : () => _pickImage(front: true),
          ),
          const SizedBox(height: 12),
          _SideCapture(
            label: l10n.scanBack,
            path: state.backPath,
            onScan: _capturing ? null : () => _scanSide(front: false),
            onPick: _capturing ? null : () => _pickImage(front: false),
          ),
          const SizedBox(height: 20),
          if (state.reading) ...[
            LinearProgressIndicator(
              value: state.uploadProgress != null && state.uploadProgress! < 100
                  ? state.uploadProgress! / 100
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              state.uploadProgress != null && state.uploadProgress! < 100
                  ? l10n.uploadingCardProgress(state.uploadProgress!)
                  : l10n.readingDocument,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            if (state.uploadProgress == 100) ...[
              const SizedBox(height: 4),
              Text(
                l10n.stillReading,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ] else ...[
            PrimaryButton(
              label: l10n.readDocument,
              onPressed: state.frontPath != null && state.backPath != null
                  ? _controller.startExtraction
                  : null,
              icon: Icons.document_scanner_outlined,
            ),
          ],
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _scanErrorMessage(state.errorMessage!),
              style: TextStyle(color: theme.colorScheme.error),
            ),
            const SizedBox(height: 8),
            SecondaryButton(
              label: l10n.retry,
              onPressed: _controller.retryScan,
            ),
          ],
        ],
        const SizedBox(height: 8),
        TextButton(
          onPressed: _controller.backToAccount,
          child: Text(l10n.back),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // STEP 3 — Review + confirm
  // ---------------------------------------------------------------------
  Widget _reviewStep(RegistrationFlowState state) {
    final theme = Theme.of(context);
    final fields = state.extractionResult?.fields ?? const {};
    ExtractedIdentityField? f(String key) => fields[key];

    _ConfidenceBucket bucket(String key) {
      final field = f(key);
      if (field == null || field.value == null || field.value!.trim().isEmpty) {
        return _ConfidenceBucket.needsReview;
      }
      if (field.mrzAgree || field.confidence >= 0.90) {
        return _ConfidenceBucket.detected;
      }
      if (field.confidence >= 0.70) return _ConfidenceBucket.pleaseCheck;
      return _ConfidenceBucket.needsReview;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_reviewInitialized && mounted) {
        _reviewInitialized = true;
        _syncReviewControllers(ref.read(registrationControllerProvider));
      }
    });

    final draft = state.draft;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.reviewStepTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          l10n.scanFirstExplanation,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        // --- Personal information ---
        Text(l10n.personalInformation, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        _ReviewField(
          key: _reviewFieldKeys[_ReviewFieldKey.name],
          label: l10n.name,
          controller: _nameController,
          direction: TextDirection.rtl,
          bucket: bucket('name'),
          hasValue: state.review.name.isNotEmpty,
          errorText: _reviewErrors[_ReviewFieldKey.name],
          onValueChanged: () => _clearFieldError(_ReviewFieldKey.name),
        ),
        const SizedBox(height: 12),
        _ReviewField(
          key: _reviewFieldKeys[_ReviewFieldKey.fatherName],
          label: l10n.fathersName,
          controller: _fatherNameController,
          direction: TextDirection.rtl,
          bucket: bucket('father_name'),
          hasValue: state.review.fatherName.isNotEmpty,
          errorText: _reviewErrors[_ReviewFieldKey.fatherName],
          onValueChanged: () => _clearFieldError(_ReviewFieldKey.fatherName),
        ),
        const SizedBox(height: 12),
        _ReviewField(
          key: _reviewFieldKeys[_ReviewFieldKey.grandfatherName],
          label: l10n.grandfathersName,
          controller: _grandfatherNameController,
          direction: TextDirection.rtl,
          bucket: bucket('grandfather_name'),
          hasValue: state.review.grandfatherName.isNotEmpty,
          errorText: _reviewErrors[_ReviewFieldKey.grandfatherName],
          onValueChanged: () =>
              _clearFieldError(_ReviewFieldKey.grandfatherName),
        ),
        const SizedBox(height: 12),
        _ReviewField(
          key: _reviewFieldKeys[_ReviewFieldKey.motherName],
          label: l10n.mothersName,
          controller: _motherNameController,
          direction: TextDirection.rtl,
          bucket: bucket('mother_name'),
          hasValue: state.review.motherName.isNotEmpty,
          onValueChanged: () => _clearFieldError(_ReviewFieldKey.motherName),
        ),
        const SizedBox(height: 12),
        _SexField(
          key: _reviewFieldKeys[_ReviewFieldKey.sex],
          label: l10n.sex,
          value: state.review.sex,
          bucket: bucket('sex'),
          hasValue:
              state.review.sex != Sex.unspecified &&
              state.review.sex != Sex.unknown,
          errorText: _reviewErrors[_ReviewFieldKey.sex],
          onChanged: (s) {
            _clearFieldError(_ReviewFieldKey.sex);
            _controller.updateReview(state.review.copyWith(sex: s));
          },
        ),
        const SizedBox(height: 12),
        _DateField(
          key: _reviewFieldKeys[_ReviewFieldKey.dateOfBirth],
          label: l10n.dateOfBirth,
          value: state.review.dateOfBirth,
          bucket: bucket('date_of_birth'),
          hasValue: state.review.dateOfBirth != null,
          errorText: _reviewErrors[_ReviewFieldKey.dateOfBirth],
          onTap: _pickDob,
        ),
        const SizedBox(height: 12),
        _BloodGroupField(
          key: _reviewFieldKeys[_ReviewFieldKey.bloodGroup],
          label: l10n.bloodGroup,
          value: state.review.bloodGroup,
          bucket: bucket('blood_group'),
          hasValue: state.review.bloodGroup != BloodGroup.unknown,
          errorText: _reviewErrors[_ReviewFieldKey.bloodGroup],
          onChanged: (g) {
            _clearFieldError(_ReviewFieldKey.bloodGroup);
            _controller.updateReview(state.review.copyWith(bloodGroup: g));
          },
        ),
        const SizedBox(height: 20),
        // --- Account information ---
        Text(l10n.accountInformation, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        _InfoRow(label: l10n.email, value: draft?.email ?? ''),
        _InfoRow(label: l10n.phone, value: draft?.phone ?? ''),
        _InfoRow(
          label: l10n.governorate,
          value: _governorateLabel(draft?.governorate ?? ''),
        ),
        const SizedBox(height: 20),
        // --- Identity information ---
        Text(l10n.cardInformation, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        _ReviewField(
          key: _reviewFieldKeys[_ReviewFieldKey.nationalCardNumber],
          label: l10n.nationalCardNumber,
          controller: _cardNumberController,
          direction: TextDirection.ltr,
          bucket: bucket('national_card_number'),
          hasValue: state.review.nationalCardNumber.isNotEmpty,
          errorText: _reviewErrors[_ReviewFieldKey.nationalCardNumber],
          onValueChanged: () =>
              _clearFieldError(_ReviewFieldKey.nationalCardNumber),
        ),
        const SizedBox(height: 12),
        _ReviewField(
          key: _reviewFieldKeys[_ReviewFieldKey.familyNumber],
          label: l10n.familyNumber,
          controller: _familyNumberController,
          direction: TextDirection.ltr,
          bucket: bucket('family_number'),
          hasValue: state.review.familyNumber.isNotEmpty,
          errorText: _reviewErrors[_ReviewFieldKey.familyNumber],
          onValueChanged: () => _clearFieldError(_ReviewFieldKey.familyNumber),
        ),
        const SizedBox(height: 12),
        _ReviewField(
          key: _reviewFieldKeys[_ReviewFieldKey.uniqueCardBodyNumber],
          label: l10n.uniqueCardBodyNumber,
          controller: _bodyNumberController,
          direction: TextDirection.ltr,
          bucket: bucket('unique_card_body_number'),
          hasValue: state.review.uniqueCardBodyNumber.isNotEmpty,
          errorText: _reviewErrors[_ReviewFieldKey.uniqueCardBodyNumber],
          onValueChanged: () =>
              _clearFieldError(_ReviewFieldKey.uniqueCardBodyNumber),
        ),
        const SizedBox(height: 20),
        // --- Explicit acknowledgement ---
        KeyedSubtree(
          key: _reviewFieldKeys[_ReviewFieldKey.confirmation],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                value: state.review.confirmation,
                onChanged: state.submitting
                    ? null
                    : (v) {
                        _clearFieldError(_ReviewFieldKey.confirmation);
                        _controller.updateReview(
                          state.review.copyWith(confirmation: v ?? false),
                        );
                      },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(l10n.confirmCardMatches),
              ),
              if (_reviewErrors[_ReviewFieldKey.confirmation] != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    _reviewErrors[_ReviewFieldKey.confirmation]!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        PrimaryButton(
          label: l10n.createAccount,
          onPressed: state.submitting ? null : _submitReview,
          loading: state.submitting,
          icon: Icons.person_add_alt_1_outlined,
        ),
        const SizedBox(height: 8),
        SecondaryButton(
          label: l10n.editAccountDetails,
          onPressed: state.submitting ? null : _controller.backToAccount,
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: state.submitting ? null : _controller.backToScan,
          child: Text(l10n.back),
        ),
      ],
    );
  }
}

enum _ConfidenceBucket { detected, pleaseCheck, needsReview }

class _ConfidenceBadge extends StatelessWidget {
  const _ConfidenceBadge({required this.bucket});

  final _ConfidenceBucket bucket;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (text, color, icon) = switch (bucket) {
      _ConfidenceBucket.detected => (
        l10n.confidenceDetected,
        scheme.primaryContainer,
        Icons.check_circle_outline,
      ),
      _ConfidenceBucket.pleaseCheck => (
        l10n.confidencePleaseCheck,
        scheme.tertiaryContainer,
        Icons.help_outline,
      ),
      _ConfidenceBucket.needsReview => (
        l10n.confidenceNeedsReview,
        scheme.errorContainer,
        Icons.error_outline,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(text, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _ReviewField extends StatelessWidget {
  const _ReviewField({
    super.key,
    required this.label,
    required this.controller,
    required this.bucket,
    required this.hasValue,
    this.errorText,
    this.onValueChanged,
    this.direction,
  });

  final String label;
  final TextEditingController controller;
  final _ConfidenceBucket bucket;
  final bool hasValue;
  final String? errorText;
  final VoidCallback? onValueChanged;
  final TextDirection? direction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labelText = bucket == _ConfidenceBucket.needsReview && !hasValue
        ? '$label — ${l10n.couldNotReadThisField}'
        : label;
    final field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                labelText,
                style: Theme.of(context).textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _ConfidenceBadge(bucket: bucket),
          ],
        ),
        const SizedBox(height: 6),
        AppTextField(
          label: label,
          controller: controller,
          errorText: errorText,
          onChanged: (_) => onValueChanged?.call(),
          maxLines: 1,
        ),
      ],
    );
    if (direction == null) return field;
    return Directionality(textDirection: direction!, child: field);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _SexField extends StatelessWidget {
  const _SexField({
    super.key,
    required this.label,
    required this.value,
    required this.bucket,
    required this.hasValue,
    required this.onChanged,
    this.errorText,
  });

  final String label;
  final Sex value;
  final _ConfidenceBucket bucket;
  final bool hasValue;
  final ValueChanged<Sex> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final labelText = bucket == _ConfidenceBucket.needsReview && !hasValue
        ? '$label — ${l10n.couldNotReadThisField}'
        : label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                labelText,
                style: theme.textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _ConfidenceBadge(bucket: bucket),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<Sex>(
          initialValue: value,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            errorText: errorText,
          ),
          items: const [
            DropdownMenuItem(value: Sex.male, child: Text('Male')),
            DropdownMenuItem(value: Sex.female, child: Text('Female')),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}

class _BloodGroupField extends StatelessWidget {
  const _BloodGroupField({
    super.key,
    required this.label,
    required this.value,
    required this.bucket,
    required this.hasValue,
    required this.onChanged,
    this.errorText,
  });

  final String label;
  final BloodGroup value;
  final _ConfidenceBucket bucket;
  final bool hasValue;
  final ValueChanged<BloodGroup> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final labelText = bucket == _ConfidenceBucket.needsReview && !hasValue
        ? '$label — ${l10n.couldNotReadThisField}'
        : label;
    final values = BloodGroup.values.where((g) => g != BloodGroup.unknown);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                labelText,
                style: theme.textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _ConfidenceBadge(bucket: bucket),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<BloodGroup>(
          initialValue: value,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            errorText: errorText,
          ),
          items: [
            for (final g in values)
              DropdownMenuItem(value: g, child: Text(g.api)),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    super.key,
    required this.label,
    required this.value,
    required this.bucket,
    required this.hasValue,
    required this.onTap,
    this.errorText,
  });

  final String label;
  final DateTime? value;
  final _ConfidenceBucket bucket;
  final bool hasValue;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final labelText = bucket == _ConfidenceBucket.needsReview && !hasValue
        ? '$label — ${l10n.couldNotReadThisField}'
        : label;
    final text = value == null
        ? l10n.couldNotReadThisField
        : formatDisplayDate(value, (pattern) {
            final locale = Localizations.localeOf(context).toLanguageTag();
            try {
              return DateFormat.yMMMd(locale).format(value!);
            } catch (_) {
              return formatApiDate(value);
            }
          });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                labelText,
                style: theme.textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _ConfidenceBadge(bucket: bucket),
          ],
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              errorText: errorText,
            ),
            child: Text(text),
          ),
        ),
      ],
    );
  }
}

class _GovernorateField extends StatelessWidget {
  const _GovernorateField({
    required this.label,
    required this.value,
    required this.labelOf,
    required this.onChanged,
  });

  final String label;
  final String value;
  final String Function(String) labelOf;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value.isEmpty ? null : value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: [
        for (final code in _governorates)
          DropdownMenuItem(value: code, child: Text(labelOf(code))),
      ],
      onChanged: onChanged,
    );
  }
}

class _SideCapture extends StatelessWidget {
  const _SideCapture({
    required this.label,
    required this.path,
    required this.onScan,
    required this.onPick,
  });

  final String label;
  final String? path;
  final VoidCallback? onScan;
  final VoidCallback? onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final captured = path != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: captured
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  captured ? label : '$label — ${l10n.couldNotReadThisField}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              if (captured) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPick,
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: Text(
                    l10n.chooseExistingImage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onScan,
                  icon: const Icon(Icons.document_scanner_outlined, size: 18),
                  label: Text(
                    l10n.scan,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
