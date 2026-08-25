import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_text_field.dart';
import '../application/session_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
          .login(email: _email.text.trim(), password: _password.text);
    } on ApiException catch (e) {
      setState(() => _errorMessage = _message(e, l10n));
    } catch (_) {
      setState(() => _errorMessage = l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _message(ApiException e, AppLocalizations l10n) {
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
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.huge),
                    Image.asset('assets/icon/pmdap_logo.png', height: 96),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      l10n.welcomeBack,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.loginSubtitleSecure,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    Card(
                      elevation: 1,
                      shadowColor: Colors.black.withAlpha(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            AppTextField(
                              label: l10n.email,
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(
                                Icons.mail_outline_rounded,
                              ),
                              autofillHints: const [AutofillHints.email],
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? l10n.validationFailed
                                  : null,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            AppTextField(
                              label: l10n.password,
                              controller: _password,
                              obscureText: _obscure,
                              textInputAction: TextInputAction.done,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                tooltip: _obscure ? 'Show' : 'Hide',
                              ),
                              autofillHints: const [AutofillHints.password],
                              validator: (v) => (v == null || v.isEmpty)
                                  ? l10n.validationFailed
                                  : null,
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Semantics(
                      button: true,
                      child: FilledButton(
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(l10n.signIn),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          l10n.noAccountYet,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(Routes.register),
                          child: Text(l10n.createAccount),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.push(Routes.claims),
                      child: Text(
                        l10n.claimExistingAccount,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(Routes.accountActivation),
                      child: Text(
                        l10n.activateClaimedAccount,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            l10n.secureFooter,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
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
