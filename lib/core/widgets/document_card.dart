import 'package:flutter/material.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../core/models/archive.dart';
import '../../core/models/enums.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/presentation.dart';
import '../../core/utils/status_labels.dart';

/// Archive/search document list card. Never shows OCR/extracted text.
class DocumentCard extends StatelessWidget {
  const DocumentCard({super.key, required this.document, this.onTap});

  final ArchiveDocument document;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = StatusLabels(l10n);
    final theme = Theme.of(context);
    final hasDate = document.documentDate != null;
    final facility = facilityDisplayName(
      facilityName: document.facilityName.isNotEmpty
          ? document.facilityName
          : (document.healthcareFacility?.name ?? ''),
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
                          _title(l10n, labels),
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
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
                  if (hasDate)
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

  /// Blank title falls back to the localized document type first; only when
  /// the type is unknown do we fall back to the processing state label.
  String _title(AppLocalizations l10n, StatusLabels labels) {
    if (document.title.trim().isNotEmpty) return document.title;
    if (document.documentType != MedicalDocumentType.unknown) {
      return labels.medicalDocumentTypeLabel(document.documentType);
    }
    return labels.processingLabel(document.processingStatus);
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
      Icon(icon, size: 15, color: AppColors.textSecondary),
      const SizedBox(width: 5),
      Text(
        label,
        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
      ),
    ],
  );
}
