import 'package:flutter/material.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../core/models/medical_document.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/status_labels.dart';
import '../../../core/widgets/status_badge.dart';

/// Card for a [MedicalDocument] (document list / recent documents on home).
/// Never shows OCR/extracted text.
class MedicalDocumentCard extends StatelessWidget {
  const MedicalDocumentCard({super.key, required this.document, this.onTap});

  final MedicalDocument document;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final labels = StatusLabels(l10n);

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
                      Icons.description_outlined,
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
                  if (document.documentDate != null)
                    _Meta(
                      label: formatApiDate(document.documentDate),
                      icon: Icons.event,
                    )
                  else
                    _Meta(label: l10n.dateUnconfirmed, icon: Icons.event_busy),
                  const Spacer(),
                  StatusBadge.fromTone(
                    label: labels.processing(document.processingStatus),
                    tone: labels.processingTone(document.processingStatus),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
