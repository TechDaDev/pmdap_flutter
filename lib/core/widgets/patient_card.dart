import 'package:flutter/material.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../core/models/enums.dart';
import '../../core/models/minor.dart';
import '../../core/models/patient.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/status_labels.dart';
import 'status_badge.dart';

/// Patient card (profile summary) and minor card (guardian).
class PatientCard extends StatelessWidget {
  const PatientCard({
    super.key,
    this.fullName,
    this.digitalId,
    this.dateOfBirth,
    this.identityStatus,
    this.onTap,
    this.subtitle,
  });

  PatientCard.fromProfile({
    super.key,
    required PatientProfile profile,
    this.onTap,
  }) : fullName = profile.fullName,
       digitalId = profile.digitalId,
       dateOfBirth = profile.dateOfBirth,
       identityStatus = profile.identityStatus,
       subtitle = null;

  PatientCard.fromMinor({super.key, required Minor minor, this.onTap})
    : fullName = minor.fullName,
      digitalId = minor.digitalId,
      dateOfBirth = minor.dateOfBirth,
      identityStatus = minor.identityStatus,
      subtitle = null;

  final String? fullName;
  final String? digitalId;
  final DateTime? dateOfBirth;
  final IdentityStatus? identityStatus;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final labels = StatusLabels(l10n);
    final status = identityStatus ?? IdentityStatus.unknown;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  _initials(fullName ?? '?'),
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fullName ?? '—', style: theme.textTheme.titleMedium),
                    if (digitalId != null && digitalId!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${l10n.digitalId}: $digitalId',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    if (dateOfBirth != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${l10n.dateOfBirth}: ${formatApiDate(dateOfBirth)}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: theme.textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              StatusBadge.fromTone(
                label: labels.identityState(status),
                tone: labels.identityTone(status),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}
