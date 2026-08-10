import 'package:flutter/material.dart';

/// Colored status badge. Never conveys state by color alone — always paired
/// with a text label (and optional icon) so it is screen-reader friendly.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, this.color, this.icon});

  final String label;
  final Color? color;
  final IconData? icon;

  factory StatusBadge.fromTone({
    required String label,
    required StatusTone tone,
    IconData? icon,
  }) {
    return StatusBadge(
      label: label,
      color: tone.color,
      icon: icon ?? tone.icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = color ?? scheme.secondaryContainer;
    final fg = ThemeData.estimateBrightnessForColor(bg) == Brightness.dark
        ? scheme.onSecondaryContainer
        : scheme.onSurface;
    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 4),
            ],
            Text(label, style: TextStyle(fontSize: 12, color: fg)),
          ],
        ),
      ),
    );
  }
}

/// Semantic tone mapping (no color-only status).
enum StatusTone {
  success,
  warning,
  error,
  info,
  neutral;

  Color get color {
    switch (this) {
      case success:
        return const Color(0xFFDCF2DC);
      case warning:
        return const Color(0xFFFFF0D1);
      case error:
        return const Color(0xFFFBDCDA);
      case info:
        return const Color(0xFFDCE9FB);
      case neutral:
        return const Color(0xFFE7E7E7);
    }
  }

  IconData get icon {
    switch (this) {
      case success:
        return Icons.check_circle_outline;
      case warning:
        return Icons.schedule;
      case error:
        return Icons.error_outline;
      case info:
        return Icons.info_outline;
      case neutral:
        return Icons.help_outline;
    }
  }
}
