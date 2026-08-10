import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/session_controller.dart';

/// Login screen — connects to the real `/auth/login/` endpoint.
/// Error handling: invalid credentials, pending/inactive account, network,
/// throttling. Never reveals whether another patient's account exists.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    try {
      await ref
          .read(sessionControllerProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      // Router redirect handles navigation once authenticated.
    } on ApiException catch (e) {
      setState(() => _errorMessage = _messageFor(e));
    } catch (_) {
      setState(() => _errorMessage = AppLocalizations.of(context).errorGeneric);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _messageFor(ApiException e) {
    final l10n = AppLocalizations.of(context);
    if (e.isThrottled) return l10n.throttled;
    if (e.isNetwork || e.isTimeout) return l10n.networkError;
    if (e.code == 'invalid_credentials' || e.code == 'authentication_failed') {
      return l10n.invalidCredentials;
    }
    if (e.code == 'account_unavailable') return l10n.accountUnavailable;
    return e.message;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
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
                    Icon(
                      Icons.health_and_safety_outlined,
                      size: 56,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.loginTitle,
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.loginSubtitle,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: l10n.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.mail_outline),
                      autofillHints: const [AutofillHints.email],
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.validationFailed
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: l10n.password,
                      controller: _passwordController,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        tooltip: _obscure ? 'Show password' : 'Hide password',
                      ),
                      autofillHints: const [AutofillHints.password],
                      onChanged: (_) => setState(() {}),
                      validator: (v) => (v == null || v.isEmpty)
                          ? l10n.validationFailed
                          : null,
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
                      label: l10n.signIn,
                      onPressed: _submitting ? null : _submit,
                      loading: _submitting,
                      icon: Icons.login,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.noAccountYet),
                        TextButton(
                          onPressed: () => context.go(Routes.register),
                          child: Text(l10n.createAccount),
                        ),
                      ],
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
}
