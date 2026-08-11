import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';

/// Public claimed-account activation: token + new password → login.
///
/// The activation token is transient UI state and is never persisted or logged.
class AccountActivationScreen extends ConsumerStatefulWidget {
  const AccountActivationScreen({super.key});

  @override
  ConsumerState<AccountActivationScreen> createState() =>
      _AccountActivationScreenState();
}

class _AccountActivationScreenState
    extends ConsumerState<AccountActivationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _submitting = true;
      _errorMessage = null;
      _successMessage = null;
    });
    try {
      await ref
          .read(authApiProvider)
          .activateClaimedAccount(
            token: _tokenController.text.trim(),
            newPassword: _passwordController.text,
          );
      setState(() => _successMessage = l10n.accountActivated);
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      setState(() => _errorMessage = l10n.activationFailed);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountActivationTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: l10n.activationToken,
                  controller: _tokenController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.validationFailed
                      : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.newPassword,
                  controller: _passwordController,
                  obscureText: _obscure,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? l10n.validationFailed : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: l10n.confirmPassword,
                  controller: _confirmController,
                  obscureText: _obscure,
                  validator: (v) => (v != _passwordController.text)
                      ? l10n.passwordMismatch
                      : null,
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
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.go(Routes.login),
                    child: Text(l10n.loginTitle),
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
}
