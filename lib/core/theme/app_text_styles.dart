import 'package:flutter/material.dart';

/// Typography scale of the design system.
///
/// Widgets must consume `Theme.of(context).textTheme` (see
/// `context.textStyles` in `core/extensions`) instead of building their own
/// [TextStyle].
abstract final class AppTextStyles {
  static const double displaySize = 32;
  static const double headlineSize = 26;
  static const double titleSize = 20;
  static const double subtitleSize = 16;
  static const double bodySize = 15;
  static const double captionSize = 13;
  static const double labelSize = 14;

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  /// Builds the themed [TextTheme] for the given [colorScheme].
  static TextTheme textTheme(ColorScheme colorScheme) {
    final base = Typography.material2021(colorScheme: colorScheme).black.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontSize: displaySize,
        fontWeight: bold,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: headlineSize,
        fontWeight: semiBold,
        letterSpacing: -0.3,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: titleSize,
        fontWeight: semiBold,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: subtitleSize,
        fontWeight: medium,
      ),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: bodySize, height: 1.45),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: bodySize, height: 1.45),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: captionSize,
        color: colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: labelSize,
        fontWeight: medium,
        letterSpacing: 0.1,
      ),
    );
  }
}
