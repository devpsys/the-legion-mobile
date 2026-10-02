import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/theme/app_colors.dart';
import 'package:the_legion_mobile/core/theme/app_radii.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';

/// Relative luminance contrast ratio between two opaque colours (WCAG 2.x).
double _contrast(Color a, Color b) {
  double channel(double component) => component <= 0.03928
      ? component / 12.92
      : math.pow((component + 0.055) / 1.055, 2.4).toDouble();

  double luminance(Color color) =>
      0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);

  final first = luminance(a);
  final second = luminance(b);
  final lighter = first > second ? first : second;
  final darker = first > second ? second : first;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('colour schemes', () {
    test(
      'light scheme separates outline (icons) from outlineVariant (hairlines)',
      () {
        final scheme = AppColors.lightScheme;

        expect(
          scheme.outline,
          AppColors.textMutedLight,
          reason: 'outline is the medium-contrast icon/accent role',
        );
        expect(
          scheme.outlineVariant,
          AppColors.strokeLight,
          reason: 'outlineVariant is the hairline border role',
        );
        expect(scheme.outline, isNot(scheme.outlineVariant));
      },
    );

    test('dark scheme separates outline from outlineVariant', () {
      final scheme = AppColors.darkScheme;

      expect(scheme.outline, AppColors.textMutedDark);
      expect(scheme.outlineVariant, AppColors.strokeDark);
      expect(scheme.outline, isNot(scheme.outlineVariant));
    });

    test('muted text and icons meet WCAG AA on the canvas', () {
      // Muted metadata, footer legal text and the `outline` icon role.
      expect(
        _contrast(AppColors.textMutedLight, AppColors.canvasLight),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(AppColors.textMutedDark, AppColors.canvasDark),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('primary text meets WCAG AA on the canvas', () {
      expect(
        _contrast(AppColors.textPrimaryLight, AppColors.canvasLight),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(AppColors.textPrimaryDark, AppColors.canvasDark),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('action labels meet WCAG AA on the action colour', () {
      expect(
        _contrast(AppColors.cardLight, AppColors.navy),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(AppColors.onGoldDark, AppColors.honeyGold),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('the hairline stroke is decoration, not text', () {
      // It is intentionally low contrast: it only separates surfaces.
      expect(
        _contrast(AppColors.strokeLight, AppColors.canvasLight),
        lessThan(2.0),
      );
    });
  });

  group('theme', () {
    test('dark mode inverts the primary action to honey gold', () {
      expect(AppColors.darkScheme.primary, AppColors.honeyGold);
      expect(AppColors.darkScheme.onPrimary, AppColors.onGoldDark);
      expect(AppColors.lightScheme.primary, AppColors.navy);
      expect(AppColors.lightScheme.onPrimary, AppColors.cardLight);
    });

    test('cards use the 20px radius and no elevation', () {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        expect(theme.cardTheme.elevation, 0);
        final shape = theme.cardTheme.shape! as RoundedRectangleBorder;
        expect(shape.borderRadius, AppRadii.cardRadius);
        expect(AppRadii.card, 20);
      }
    });

    test('controls honour the 44px touch target', () {
      final theme = AppTheme.light;
      final filled = theme.filledButtonTheme.style?.minimumSize;
      expect(filled?.resolve({}), const Size.fromHeight(44));
    });
  });
}
