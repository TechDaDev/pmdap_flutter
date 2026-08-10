import 'package:flutter/material.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../core/models/archive.dart';
import '../../core/models/enums.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/status_labels.dart';
import 'status_badge.dart';

/// Archive/search list card. Never shows OCR/extracted text.
class DocumentCard extends StatelessWidget {
  const DocumentCard({super.key, required this.document, this.onTap});

  final ArchiveDocument document;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final labels = StatusLabels(l10n);
    final dateVerified = document.dateVerified;
    final hasDate = document.documentDate != null;

    final subtitleParts = <String>[
      if (document.facilityName.isNotEmpty) document.facilityName,
      if (document.department.isNotEmpty) document.department,
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _typeIcon(document.documentType),
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.title.isEmpty
                              ? labels.processing(document.processingStatus)
                              : document.title,
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitleParts.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitleParts.join(' · '),
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (hasDate)
                    _Meta(
                      label: formatApiDate(document.documentDate),
                      icon: Icons.event,
                    )
                  else
                    _Meta(label: l10n.dateUnconfirmed, icon: Icons.event_busy),
                  const SizedBox(width: 16),
                  _Meta(
                    label: labels.processing(document.processingStatus),
                    icon: Icons.autorenew,
                  ),
                  const Spacer(),
                  StatusBadge.fromTone(
                    label: dateVerified
                        ? l10n.dateVerifiedLabel
                        : l10n.dateUnconfirmed,
                    tone: dateVerified
                        ? StatusTone.success
                        : StatusTone.warning,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(MedicalDocumentType type) {
    switch (type) {
      case MedicalDocumentType.laboratory:
        return Icons.science_outlined;
      case MedicalDocumentType.radiology:
        return Icons.medical_information_outlined;
      case MedicalDocumentType.prescription:
        return Icons.medication_outlined;
      case MedicalDocumentType.vaccination:
        return Icons.vaccines_outlined;
      default:
        return Icons.description_outlined;
    }
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
