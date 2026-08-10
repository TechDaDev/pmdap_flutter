import 'package:flutter/material.dart';
import 'package:pmdap_mobile/core/theme/app_theme.dart';

/// Status badge: always icon + text + color. Never color-only.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  factory StatusBadge.info({required String label}) => StatusBadge(
    label: label,
    icon: Icons.info_outline_rounded,
    backgroundColor: AppColors.infoBg,
    foregroundColor: AppColors.info,
  );

  factory StatusBadge.success({required String label}) => StatusBadge(
    label: label,
    icon: Icons.check_circle_outline_rounded,
    backgroundColor: AppColors.successBg,
    foregroundColor: AppColors.success,
  );

  factory StatusBadge.warning({required String label}) => StatusBadge(
    label: label,
    icon: Icons.schedule_rounded,
    backgroundColor: AppColors.warningBg,
    foregroundColor: AppColors.warning,
  );

  factory StatusBadge.error({required String label}) => StatusBadge(
    label: label,
    icon: Icons.error_outline_rounded,
    backgroundColor: AppColors.errorBg,
    foregroundColor: AppColors.error,
  );

  factory StatusBadge.neutral({required String label}) => StatusBadge(
    label: label,
    backgroundColor: AppColors.divider,
    foregroundColor: AppColors.textSecondary,
  );

  factory StatusBadge.fromTone({
    required String label,
    required StatusTone tone,
  }) {
    switch (tone) {
      case StatusTone.success:
        return StatusBadge.success(label: label);
      case StatusTone.warning:
        return StatusBadge.warning(label: label);
      case StatusTone.error:
        return StatusBadge.error(label: label);
      case StatusTone.info:
        return StatusBadge.info(label: label);
      case StatusTone.neutral:
        return StatusBadge.neutral(label: label);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.divider;
    final fg = foregroundColor ?? AppColors.textSecondary;

    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadii.badge),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: fg,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Semantic tone (legacy; prefer direct StatusBadge factories).
enum StatusTone { success, warning, error, info, neutral }
