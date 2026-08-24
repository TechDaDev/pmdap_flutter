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
    final sourceTag = _sourceTag(l10n, theme);

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
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: hasDate
                            ? _Meta(
                                label: localizedDate(
                                  l10n,
                                  document.documentDate,
                                ),
                                icon: Icons.calendar_month_outlined,
                              )
                            : _Meta(
                                label: l10n.dateUnconfirmed,
                                icon: Icons.event_busy,
                              ),
                      ),
                    ),
                  ),
                  if (sourceTag != null) ...[
                    const SizedBox(width: 8),
                    sourceTag,
                  ],
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerEnd,
                      child: labels.processing(document.processingStatus),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Compact, neutral source-format pill. Label comes from the ACTUAL stored
  /// file media type (application/pdf -> PDF, image/* -> Image), never from
  /// document_type or page_count. Unknown -> hidden, no clinical meaning.
  Widget? _sourceTag(AppLocalizations l10n, ThemeData theme) {
    final mime = document.file?.mimeType ?? '';
    final Widget child;
    if (mime == 'application/pdf') {
      child = _SourceTag(
        label: l10n.pdfTag,
        icon: Icons.picture_as_pdf_outlined,
        theme: theme,
      );
    } else if (mime.startsWith('image/')) {
      child = _SourceTag(
        label: l10n.imageTag,
        icon: Icons.image_outlined,
        theme: theme,
      );
    } else {
      return null;
    }
    return child;
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

/// Compact neutral source-format pill (PDF / Image). Not status-colored and
/// carries no clinical meaning; readable in both light and dark themes.
class _SourceTag extends StatelessWidget {
  const _SourceTag({
    required this.label,
    required this.icon,
    required this.theme,
  });

  final String label;
  final IconData icon;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
