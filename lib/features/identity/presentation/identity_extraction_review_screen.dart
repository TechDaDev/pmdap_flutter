import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../application/identity_providers.dart';
import '../data/extraction_models.dart';
import '../data/identity_api.dart';

/// Human confirmation of advisory extraction results before the real submit.
///
/// Values shown are SUGGESTIONS — the user must verify/correct them. The MRZ
/// chip says "MRZ verified", never "Identity verified".
class IdentityExtractionReviewScreen extends ConsumerStatefulWidget {
  const IdentityExtractionReviewScreen({
    super.key,
    required this.result,
    required this.documentType,
    required this.frontPath,
    required this.backPath,
    this.replaceUuid,
  });

  final IdentityExtractionResult result;
  final IdentityDocumentType documentType;
  final String frontPath;
  final String? backPath;
  final String? replaceUuid;

  @override
  ConsumerState<IdentityExtractionReviewScreen> createState() =>
      _IdentityExtractionReviewScreenState();
}

enum _ConfidenceBucket { detected, pleaseCheck, needsReview }

class _ReviewField {
  _ReviewField({
    required this.key,
    required this.label,
    required this.controller,
    this.bucket = _ConfidenceBucket.needsReview,
    this.hasValue = false,
  });

  final String key;
  final String label;
  final TextEditingController controller;
  final _ConfidenceBucket bucket;
  final bool hasValue;
}

class _IdentityExtractionReviewScreenState
    extends ConsumerState<IdentityExtractionReviewScreen> {
  List<_ReviewField> _fields = const [];
  bool _initialized = false;
  bool _submitting = false;
  String? _errorMessage;

  IdentityDocumentType get _type => widget.documentType;
  bool get _isNationalCard => _type == IdentityDocumentType.unifiedNationalCard;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _fields = _buildFields();
  }

  static _ConfidenceBucket _bucketOf(ExtractedIdentityField? f) {
    if (f == null || f.value == null || f.value!.trim().isEmpty) {
      return _ConfidenceBucket.needsReview;
    }
    if (f.confidence >= 0.90) return _ConfidenceBucket.detected;
    if (f.confidence >= 0.70) return _ConfidenceBucket.pleaseCheck;
    return _ConfidenceBucket.needsReview;
  }

  List<_ReviewField> _buildFields() {
    final fields = widget.result.fields;
    ExtractedIdentityField? f(String key) => fields[key];
    TextEditingController c(String key) =>
        TextEditingController(text: (f(key)?.value ?? '').trim());

    if (_isNationalCard) {
      return [
        _ReviewField(
          key: 'document_number',
          label: AppLocalizations.of(context).documentNumber,
          controller: c('document_number'),
          bucket: _bucketOf(f('document_number')),
          hasValue: f('document_number')?.value?.trim().isNotEmpty ?? false,
        ),
        _ReviewField(
          key: 'national_number',
          label: AppLocalizations.of(context).nationalNumber,
          controller: c('national_number'),
          bucket: _bucketOf(f('national_number')),
          hasValue: f('national_number')?.value?.trim().isNotEmpty ?? false,
        ),
        _ReviewField(
          key: 'family_number',
          label: AppLocalizations.of(context).familyNumber,
          controller: c('family_number'),
          bucket: _bucketOf(f('family_number')),
          hasValue: f('family_number')?.value?.trim().isNotEmpty ?? false,
        ),
        _ReviewField(
          key: 'issuing_country',
          label: AppLocalizations.of(context).issuingCountry,
          controller: TextEditingController(text: 'IQ'),
          bucket: _ConfidenceBucket.detected,
          hasValue: true,
        ),
      ];
    }
    return [
      _ReviewField(
        key: 'document_number',
        label: AppLocalizations.of(context).passportNumber,
        controller: c('document_number'),
        bucket: _bucketOf(f('document_number')),
        hasValue: f('document_number')?.value?.trim().isNotEmpty ?? false,
      ),
      _ReviewField(
        key: 'issuing_country',
        label: AppLocalizations.of(context).issuingCountry,
        controller: TextEditingController(
          text: (f('issuing_country')?.value ?? '').trim().toUpperCase(),
        ),
        bucket: _bucketOf(f('issuing_country')),
        hasValue: f('issuing_country')?.value?.trim().isNotEmpty ?? false,
      ),
      _ReviewField(
        key: 'issue_date',
        label: AppLocalizations.of(context).issueDate,
        controller: c('issue_date'),
        bucket: _bucketOf(f('issue_date')),
        hasValue: f('issue_date')?.value?.trim().isNotEmpty ?? false,
      ),
      _ReviewField(
        key: 'expiry_date',
        label: AppLocalizations.of(context).expiryDate,
        controller: c('expiry_date'),
        bucket: _bucketOf(f('expiry_date')),
        hasValue: f('expiry_date')?.value?.trim().isNotEmpty ?? false,
      ),
    ];
  }

  @override
  void dispose() {
    for (final f in _fields) {
      f.controller.dispose();
    }
    super.dispose();
  }

  String? _requiredError(_ReviewField field) {
    final v = field.controller.text.trim();
    if (v.isEmpty) return l10n.validationFailed;
    if (field.key == 'issuing_country') {
      return RegExp(r'^[A-Za-z]{2}$').hasMatch(v)
          ? null
          : l10n.validationFailed;
    }
    return null;
  }

  AppLocalizations get l10n => AppLocalizations.of(context);

  DateTime? _tryParseDate(String v) {
    final d = parseApiDate(v);
    if (d != null) return d;
    // tolerate "YYYY-MM-DD" already
    return DateTime.tryParse(v);
  }

  Future<void> _submit() async {
    for (final f in _fields) {
      if (_requiredError(f) != null) {
        setState(() => _errorMessage = l10n.validationFailed);
        return;
      }
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    final byKey = {for (final f in _fields) f.key: f.controller.text.trim()};
    final issueText = byKey['issue_date'] ?? '';
    final expiryText = byKey['expiry_date'] ?? '';
    final DateTime? issueDate = _isNationalCard
        ? null
        : _tryParseDate(issueText);
    final DateTime? expiryDate = _isNationalCard
        ? null
        : _tryParseDate(expiryText);
    if (!_isNationalCard && (issueDate == null || expiryDate == null)) {
      setState(() {
        _errorMessage = l10n.validationFailed;
        _submitting = false;
      });
      return;
    }

    final submission = IdentitySubmission(
      documentType: _type,
      documentNumber: byKey['document_number'] ?? '',
      nationalNumber: _isNationalCard ? (byKey['national_number'] ?? '') : '',
      familyNumber: _isNationalCard ? (byKey['family_number'] ?? '') : '',
      issuingCountry: (byKey['issuing_country'] ?? 'IQ').toUpperCase(),
      issueDate: issueDate,
      expiryDate: expiryDate,
      frontPath: widget.frontPath,
      frontFilename: 'front.jpg',
      backPath: widget.backPath,
      backFilename: 'back.jpg',
    );

    try {
      final api = ref.read(identityApiProvider);
      if (widget.replaceUuid != null) {
        await api.replace(widget.replaceUuid!, submission);
        ref.invalidate(identityDocumentDetailProvider(widget.replaceUuid!));
      } else {
        await api.submit(submission);
      }
      ref.invalidate(identityDocumentsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.identitySubmitted)));
      Navigator.of(context).pop(true);
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final informational = _informationalRows(theme);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewDocumentInformation)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.reviewDocumentSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              if (widget.result.mrzVerified) ...[
                _MrzVerifiedChip(),
                const SizedBox(height: 16),
              ],
              if (informational.isNotEmpty) ...[
                ...informational,
                const SizedBox(height: 16),
              ],
              Card(
                color: scheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: scheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.identityExtractionAdvisory,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              for (final f in _fields) ...[
                _ReviewFieldWidget(field: f, errorText: _requiredError(f)),
                const SizedBox(height: 14),
              ],
              if (_errorMessage != null) ...[
                Text(_errorMessage!, style: TextStyle(color: scheme.error)),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              PrimaryButton(
                label: l10n.submitForVerification,
                onPressed: _submitting ? null : _submit,
                loading: _submitting,
                icon: Icons.verified_user_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Informational, read-only passport rows (never submitted).
  List<Widget> _informationalRows(ThemeData theme) {
    if (_isNationalCard) return const [];
    final fields = widget.result.fields;
    final rows = <Widget>[];
    void row(String label, String? value) {
      final v = (value ?? '').trim();
      if (v.isEmpty) return;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(v, style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
        ),
      );
    }

    row(l10n.dateOfBirth, fields['date_of_birth']?.value);
    row(l10n.sex, fields['sex']?.value);
    row(l10n.nationality, fields['nationality']?.value);
    return rows;
  }
}

class _MrzVerifiedChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.fact_check_outlined,
            size: 18,
            color: scheme.onTertiaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context).mrzVerified,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: scheme.onTertiaryContainer),
          ),
        ],
      ),
    );
  }
}

class _ReviewFieldWidget extends StatelessWidget {
  const _ReviewFieldWidget({required this.field, this.errorText});

  final _ReviewField field;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final label =
        field.bucket == _ConfidenceBucket.needsReview && !field.hasValue
        ? '${field.label} — ${l10n.couldNotReadThisField}'
        : field.label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.labelLarge),
            ),
            _ConfidenceBadge(bucket: field.bucket),
          ],
        ),
        const SizedBox(height: 6),
        AppTextField(
          label: field.label,
          controller: field.controller,
          validator: (_) => errorText,
          onChanged: (_) {},
        ),
      ],
    );
  }
}

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
