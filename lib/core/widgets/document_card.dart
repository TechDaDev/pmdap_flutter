import 'package:flutter/material.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../core/models/archive.dart';
import '../../core/models/enums.dart';
import '../../core/theme/app_theme.dart';
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
    final subtitle = [
      if (document.facilityName.isNotEmpty) document.facilityName,
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
                      _typeIcon(document.documentType),
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
                          document.title.isEmpty
                              ? labels.processingLabel(
                                  document.processingStatus,
                                )
                              : document.title,
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
                      label: _fmtDay(document.documentDate!),
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

  String _fmtDay(DateTime d) {
    final m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${m[d.month - 1]} ${d.year}';
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
