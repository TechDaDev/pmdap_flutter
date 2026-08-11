import 'package:flutter/material.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../core/models/medical_document.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/presentation.dart';
import '../../../core/utils/status_labels.dart';

/// Card for document list (recent on home, documents page). Shares the same
/// type icon / facility / date / status mapping as [DocumentCard].
class MedicalDocumentCard extends StatelessWidget {
  const MedicalDocumentCard({super.key, required this.document, this.onTap});

  final MedicalDocument document;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = StatusLabels(l10n);
    final theme = Theme.of(context);
    final facility = facilityDisplayName(
      healthcareFacility: document.healthcareFacility,
      facilityName: document.facilityName,
      locationText: document.locationText,
    );
    final subtitle = [
      if (facility.isNotEmpty) facility,
      if (document.department.isNotEmpty) document.department,
    ].join(' · ');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      documentTypeIcon(document.documentType),
                      color: AppColors.primaryNavy,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.title.trim().isNotEmpty
                              ? document.title
                              : labels.medicalDocumentTypeLabel(
                                  document.documentType,
                                ),
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  if (document.documentDate != null)
                    _Meta(
                      label: localizedDate(l10n, document.documentDate),
                      icon: Icons.calendar_month_outlined,
                    )
                  else
                    _Meta(label: l10n.dateUnconfirmed, icon: Icons.event_busy),
                  const Spacer(),
                  labels.processing(document.processingStatus),
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
  Widget build(BuildContext ctx) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 15, color: Theme.of(ctx).colorScheme.onSurfaceVariant),
      const SizedBox(width: 5),
      Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(ctx).colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );
}
