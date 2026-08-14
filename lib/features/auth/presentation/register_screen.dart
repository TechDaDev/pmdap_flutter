import 'package:flutter/material.dart' hide Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../app/router.dart';
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
  final _cardNumberController = TextEditingController();
  final _familyNumberController = TextEditingController();
  final _bodyNumberController = TextEditingController();

  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _capturing = false;
  bool _reviewInitialized = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameController.dispose();
    _fatherNameController.dispose();
    _grandfatherNameController.dispose();
    _cardNumberController.dispose();
    _familyNumberController.dispose();
    _bodyNumberController.dispose();
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

  Future<void> _submitReview() async {
    final state = ref.read(registrationControllerProvider);
    final review = state.review.copyWith(
      name: _nameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      grandfatherName: _grandfatherNameController.text.trim(),
      nationalCardNumber: _cardNumberController.text.trim(),
      documentNumber: _cardNumberController.text.trim(),
      familyNumber: _familyNumberController.text.trim(),
      uniqueCardBodyNumber: _bodyNumberController.text.trim(),
    );
    if (!review.confirmation ||
        review.name.isEmpty ||
        review.fatherName.isEmpty ||
        review.grandfatherName.isEmpty ||
        review.nationalCardNumber.isEmpty ||
        review.familyNumber.isEmpty ||
        review.dateOfBirth == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.validationFailed)));
      return;
    }
    _controller.updateReview(review);
    final ok = await _controller.submit();
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.registrationSuccess)));
      context.go(Routes.login);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationControllerProvider);
    if (state.step != RegistrationStep.review) {
      // Leaving the review step lets the next visit re-sync from scratch.
      _reviewInitialized = false;
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: switch (state.step) {
              RegistrationStep.account => _accountStep(state),
              RegistrationStep.scan => _scanStep(state),
              RegistrationStep.review => _reviewStep(state),
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // STEP 1 — Account + National Card capture
  // ---------------------------------------------------------------------
  Widget _accountStep(RegistrationFlowState state) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.accountStepTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            l10n.scanFirstExplanation,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
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
            obscureText: _obscure,
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
            validator: (v) =>
                (v == null || v.length < 8) ? l10n.validationFailed : null,
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
          Text(l10n.nationalCard, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
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
          PrimaryButton(
            label: l10n.continueAction,
            onPressed: _submitAccount,
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // STEP 2 — Read the card (single upload + poll)
  // ---------------------------------------------------------------------
  Widget _scanStep(RegistrationFlowState state) {
    final theme = Theme.of(context);
    final canRead = state.frontPath != null && state.backPath != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.scanStepTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          l10n.scanFirstExplanation,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
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
        ] else ...[
          PrimaryButton(
            label: l10n.readDocument,
            onPressed: canRead ? _controller.startExtraction : null,
            icon: Icons.document_scanner_outlined,
          ),
        ],
        if (state.errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            state.errorMessage == 'extraction_failed'
                ? l10n.documentReadingFailed
                : l10n.errorGeneric,
            style: TextStyle(color: theme.colorScheme.error),
          ),
          const SizedBox(height: 8),
          SecondaryButton(label: l10n.retry, onPressed: _controller.retryScan),
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
          label: l10n.name,
          controller: _nameController,
          direction: TextDirection.rtl,
          bucket: bucket('name'),
          hasValue: state.review.name.isNotEmpty,
        ),
        const SizedBox(height: 12),
        _ReviewField(
          label: l10n.fathersName,
          controller: _fatherNameController,
          direction: TextDirection.rtl,
          bucket: bucket('father_name'),
          hasValue: state.review.fatherName.isNotEmpty,
        ),
        const SizedBox(height: 12),
        _ReviewField(
          label: l10n.grandfathersName,
          controller: _grandfatherNameController,
          direction: TextDirection.rtl,
          bucket: bucket('grandfather_name'),
          hasValue: state.review.grandfatherName.isNotEmpty,
        ),
        const SizedBox(height: 12),
        _SexField(
          label: l10n.sex,
          value: state.review.sex,
          bucket: bucket('sex'),
          hasValue:
              state.review.sex != Sex.unspecified &&
              state.review.sex != Sex.unknown,
          onChanged: (s) =>
              _controller.updateReview(state.review.copyWith(sex: s)),
        ),
        const SizedBox(height: 12),
        _DateField(
          label: l10n.dateOfBirth,
          value: state.review.dateOfBirth,
          bucket: bucket('date_of_birth'),
          hasValue: state.review.dateOfBirth != null,
          onTap: _pickDob,
        ),
        const SizedBox(height: 12),
        _BloodGroupField(
          label: l10n.bloodGroup,
          value: state.review.bloodGroup,
          bucket: bucket('blood_group'),
          hasValue: state.review.bloodGroup != BloodGroup.unknown,
          onChanged: (g) =>
              _controller.updateReview(state.review.copyWith(bloodGroup: g)),
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
          label: l10n.nationalCardNumber,
          controller: _cardNumberController,
          direction: TextDirection.ltr,
          bucket: bucket('national_card_number'),
          hasValue: state.review.nationalCardNumber.isNotEmpty,
        ),
        const SizedBox(height: 12),
        _ReviewField(
          label: l10n.familyNumber,
          controller: _familyNumberController,
          direction: TextDirection.ltr,
          bucket: bucket('family_number'),
          hasValue: state.review.familyNumber.isNotEmpty,
        ),
        const SizedBox(height: 12),
        _ReviewField(
          label: l10n.uniqueCardBodyNumber,
          controller: _bodyNumberController,
          direction: TextDirection.ltr,
          bucket: bucket('unique_card_body_number'),
          hasValue: state.review.uniqueCardBodyNumber.isNotEmpty,
        ),
        const SizedBox(height: 20),
        // --- Explicit acknowledgement ---
        CheckboxListTile(
          value: state.review.confirmation,
          onChanged: state.submitting
              ? null
              : (v) => _controller.updateReview(
                  state.review.copyWith(confirmation: v ?? false),
                ),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(l10n.confirmCardMatches),
        ),
        const SizedBox(height: 8),
        PrimaryButton(
          label: l10n.createAccount,
          onPressed: state.submitting ? null : _submitReview,
          loading: state.submitting,
          icon: Icons.person_add_alt_1_outlined,
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
    required this.label,
    required this.controller,
    required this.bucket,
    required this.hasValue,
    this.direction,
  });

  final String label;
  final TextEditingController controller;
  final _ConfidenceBucket bucket;
  final bool hasValue;
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
          onChanged: (_) {},
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
    required this.label,
    required this.value,
    required this.bucket,
    required this.hasValue,
    required this.onChanged,
  });

  final String label;
  final Sex value;
  final _ConfidenceBucket bucket;
  final bool hasValue;
  final ValueChanged<Sex> onChanged;

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
    required this.label,
    required this.value,
    required this.bucket,
    required this.hasValue,
    required this.onChanged,
  });

  final String label;
  final BloodGroup value;
  final _ConfidenceBucket bucket;
  final bool hasValue;
  final ValueChanged<BloodGroup> onChanged;

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
    required this.label,
    required this.value,
    required this.bucket,
    required this.hasValue,
    required this.onTap,
  });

  final String label;
  final DateTime? value;
  final _ConfidenceBucket bucket;
  final bool hasValue;
  final VoidCallback onTap;

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
