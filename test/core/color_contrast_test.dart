import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmdap_mobile/core/theme/app_theme.dart';

/// WCAG relative luminance for a color.
double _luminance(Color c) {
  // Color.r/.g/.b are 0..1 doubles in current Flutter.
  double chan(double s) {
    return s <= 0.03928
        ? s / 12.92
        : math.pow((s + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * chan(c.r) + 0.7152 * chan(c.g) + 0.0722 * chan(c.b);
}

double contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  const minNormal = 4.5;

  group('semantic secondary text contrast', () {
    test('light secondary-on-surface >= 4.5', () {
      final ratio = contrast(AppColors.textSecondary, AppColors.surface);
      expect(ratio, greaterThanOrEqualTo(minNormal));
    });

    test('dark secondary-on-surface >= 4.5', () {
      final ratio = contrast(
        AppColors.darkTextSecondary,
        AppColors.darkSurface,
      );
      expect(ratio, greaterThanOrEqualTo(minNormal));
    });

    test('dark secondary-on-elevated >= 4.5', () {
      final ratio = contrast(
        AppColors.darkTextSecondary,
        AppColors.darkElevated,
      );
      expect(ratio, greaterThanOrEqualTo(minNormal));
    });
  });

  group('flag badge contrast (neutral, readable)', () {
    test('light flag text-on-chip >= 4.5', () {
      final ratio = contrast(AppColors.textPrimary, AppColors.divider);
      expect(ratio, greaterThanOrEqualTo(minNormal));
    });

    test('dark flag text-on-chip >= 4.5', () {
      final ratio = contrast(AppColors.darkTextPrimary, AppColors.darkElevated);
      expect(ratio, greaterThanOrEqualTo(minNormal));
    });
  });

  group('theme exposes accessible secondary token', () {
    test('light scheme onSurfaceVariant is the accessible secondary', () {
      final scheme = AppTheme.light().colorScheme;
      expect(scheme.onSurfaceVariant, AppColors.textSecondary);
      expect(
        contrast(scheme.onSurfaceVariant, scheme.surface),
        greaterThanOrEqualTo(minNormal),
      );
    });

    test('dark scheme onSurfaceVariant is the accessible secondary', () {
      final scheme = AppTheme.dark().colorScheme;
      expect(scheme.onSurfaceVariant, AppColors.darkTextSecondary);
      expect(
        contrast(scheme.onSurfaceVariant, scheme.surface),
        greaterThanOrEqualTo(minNormal),
      );
    });

    test('metadata labels no longer use border outline as text', () {
      // outline is a border token (~1.2:1 as text); secondary must differ.
      expect(
        AppTheme.light().colorScheme.outline,
        isNot(AppColors.textSecondary),
      );
      expect(
        contrast(AppTheme.light().colorScheme.outline, AppColors.surface),
        lessThan(minNormal),
      );
    });
  });
}
