import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_text_field.dart';
import '../application/session_controller.dart';

enum _ChangeStep { currentPassword, code, password, success }

/// Authenticated password change: current password → email OTP → new password.
///
/// The OTP goes only to the account's verified email. On success the backend
/// revokes every other session and returns a fresh token pair, which the
/// session controller applies so this device stays signed in.
class PasswordChangeScreen extends ConsumerStatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  ConsumerState<PasswordChangeScreen> createState() =>
      _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends ConsumerState<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassword = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  _ChangeStep _step = _ChangeStep.currentPassword;
  String? _capability;
  String? _error;
  bool _submitting = false;
  bool _obscureCurrent = true;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  int _cooldown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _capability = null;
    _currentPassword.dispose();
    _code.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  void _startCooldown(int seconds) {
    _timer?.cancel();
    setState(() => _cooldown = seconds);
    if (seconds <= 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_cooldown <= 1) {
        timer.cancel();
        setState(() => _cooldown = 0);
      } else {
        setState(() => _cooldown--);
      }
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await action();
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = _message(error));
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context).errorGeneric);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _requestCode() async {
    if (!_formKey.currentState!.validate()) return;
    await _run(() async {
      final seconds = await ref
          .read(passwordChangeApiProvider)
          .request(currentPassword: _currentPassword.text);
      if (!mounted) return;
      setState(() => _step = _ChangeStep.code);
      _startCooldown(seconds);
    });
  }

  Future<void> _resendCode() async {
    if (_cooldown > 0) return;
    await _run(() async {
      final seconds = await ref
          .read(passwordChangeApiProvider)
          .request(currentPassword: _currentPassword.text);
      if (mounted) _startCooldown(seconds);
    });
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return;
    await _run(() async {
      final result = await ref
          .read(passwordChangeApiProvider)
          .verify(code: _code.text.trim());
      if (!mounted) return;
      _code.clear();
      setState(() {
        _capability = result.capability;
        _step = _ChangeStep.password;
      });
    });
  }

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate()) return;
    final capability = _capability;
    if (capability == null) {
      setState(
        () => _error = AppLocalizations.of(context).changeCapabilityInvalid,
      );
      return;
    }
    await _run(() async {
      final pair = await ref
          .read(passwordChangeApiProvider)
          .confirm(capability: capability, newPassword: _password.text);
      if (!mounted) return;
      // The backend revoked all other sessions; apply the fresh token pair so
      // this device stays signed in.
      await ref
          .read(sessionControllerProvider.notifier)
          .applyFreshSession(pair);
      if (!mounted) return;
      _timer?.cancel();
      _currentPassword.clear();
      _code.clear();
      _password.clear();
      _confirmation.clear();
      setState(() {
        _capability = null;
        _step = _ChangeStep.success;
      });
    });
  }

  void _startOver() {
    _timer?.cancel();
    _code.clear();
    _password.clear();
    _confirmation.clear();
    setState(() {
      _capability = null;
      _error = null;
      _cooldown = 0;
      _step = _ChangeStep.currentPassword;
    });
  }

  String _message(ApiException error) {
    final l10n = AppLocalizations.of(context);
    if (error.isNetwork || error.isTimeout) {
      return l10n.changePasswordNetworkError;
    }
    if (error.isThrottled) return l10n.throttled;
    if (error.code == 'password_change_wrong_current_password') {
      return l10n.wrongCurrentPassword;
    }
    if (error.code == 'password_change_email_unverified') {
      return l10n.emailUnverified;
    }
    if (error.code == 'password_change_otp_invalid') {
      return l10n.changeCodeInvalid;
    }
    if (error.code == 'password_change_capability_invalid') {
      return l10n.changeCapabilityInvalid;
    }
    if (error.code == 'validation_error') return l10n.passwordRejected;
    return l10n.errorGeneric;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.changePassword),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        _title(l10n),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _subtitle(l10n),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    if (_step != _ChangeStep.success) _fields(l10n),
                    if (_error != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                    if (_step != _ChangeStep.success)
                      FilledButton(
                        onPressed: _submitting ? null : _primaryAction(),
                        child: _submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(_primaryLabel(l10n)),
                      ),
                    if (_step == _ChangeStep.code) ...[
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: _submitting || _cooldown > 0
                            ? null
                            : _resendCode,
                        child: Text(
                          _cooldown > 0
                              ? l10n.resendCodeIn(_cooldown)
                              : l10n.resendCode,
                        ),
                      ),
                    ],
                    if (_step == _ChangeStep.password && _error != null)
                      TextButton(
                        onPressed: _startOver,
                        child: Text(l10n.startOver),
                      ),
                    if (_step == _ChangeStep.success)
                      FilledButton(
                        onPressed: () => context.go(Routes.profile),
                        child: Text(l10n.done),
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

  Widget _fields(AppLocalizations l10n) => switch (_step) {
    _ChangeStep.currentPassword => AppTextField(
      label: l10n.currentPassword,
      controller: _currentPassword,
      obscureText: _obscureCurrent,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      prefixIcon: const Icon(Icons.lock_outline_rounded),
      suffixIcon: IconButton(
        tooltip: _obscureCurrent ? l10n.showPassword : l10n.hidePassword,
        onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
        icon: Icon(
          _obscureCurrent
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? l10n.validationFailed : null,
    ),
    _ChangeStep.code => AppTextField(
      label: l10n.verificationCode,
      controller: _code,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.oneTimeCode],
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
      prefixIcon: const Icon(Icons.password_rounded),
      validator: (value) =>
          value == null || value.length != 6 ? l10n.enterSixDigitCode : null,
    ),
    _ChangeStep.password => Column(
      children: [
        AppTextField(
          label: l10n.newPassword,
          controller: _password,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            tooltip: _obscurePassword ? l10n.showPassword : l10n.hidePassword,
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? l10n.validationFailed : null,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: l10n.confirmNewPassword,
          controller: _confirmation,
          obscureText: _obscureConfirmation,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          prefixIcon: const Icon(Icons.lock_reset_rounded),
          suffixIcon: IconButton(
            tooltip: _obscureConfirmation
                ? l10n.showPassword
                : l10n.hidePassword,
            onPressed: () =>
                setState(() => _obscureConfirmation = !_obscureConfirmation),
            icon: Icon(
              _obscureConfirmation
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
          validator: (value) =>
              value != _password.text ? l10n.passwordsDoNotMatch : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.passwordPolicyServer, textAlign: TextAlign.center),
      ],
    ),
    _ChangeStep.success => const SizedBox.shrink(),
  };

  String _title(AppLocalizations l10n) => switch (_step) {
    _ChangeStep.currentPassword => l10n.changePassword,
    _ChangeStep.code => l10n.checkYourEmail,
    _ChangeStep.password => l10n.chooseNewPassword,
    _ChangeStep.success => l10n.changePasswordComplete,
  };

  String _subtitle(AppLocalizations l10n) => switch (_step) {
    _ChangeStep.currentPassword => l10n.changePasswordCurrentHelp,
    _ChangeStep.code => l10n.changePasswordCodeHelp,
    _ChangeStep.password => l10n.changePasswordNewHelp,
    _ChangeStep.success => l10n.changePasswordSuccessHelp,
  };

  VoidCallback _primaryAction() => switch (_step) {
    _ChangeStep.currentPassword => _requestCode,
    _ChangeStep.code => _verifyCode,
    _ChangeStep.password => _confirm,
    _ChangeStep.success => () {},
  };

  String _primaryLabel(AppLocalizations l10n) => switch (_step) {
    _ChangeStep.currentPassword => l10n.sendCode,
    _ChangeStep.code => l10n.verifyCode,
    _ChangeStep.password => l10n.changePassword,
    _ChangeStep.success => l10n.done,
  };
}
