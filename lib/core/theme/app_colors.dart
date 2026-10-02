import 'package:flutter/material.dart';

/// Color tokens of the design system.
///
/// Widgets must read colors from the ambient [ThemeData] (`colorScheme`,
/// `textTheme`, ...) or from these tokens — never from a raw
/// `Color(0xFF...)` literal. Add new tokens here when a feature needs them,
/// not inline in the widget.
abstract final class AppColors {
  // Brand
  static const Color brandPrimary = Color(0xFF2F5BEA);
  static const Color brandPrimaryDark = Color(0xFF9DB2FF);
  static const Color brandSecondary = Color(0xFF00A5A5);

  // Neutrals
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF7F8FA);
  static const Color neutral800 = Color(0xFF1F2430);
  static const Color neutral900 = Color(0xFF12151C);

  // Semantic
  static const Color errorLight = Color(0xFFC0342B);
  static const Color errorDark = Color(0xFFFF6B5E);

  /// Background of the application scaffold.
  static const Color canvasLight = neutral50;
  static const Color canvasDark = neutral900;

  static ColorScheme get lightScheme =>
      ColorScheme.fromSeed(
        seedColor: brandPrimary,
        brightness: Brightness.light,
      ).copyWith(
        primary: brandPrimary,
        secondary: brandSecondary,
        error: errorLight,
        surface: neutral0,
        onSurface: neutral900,
      );

  static ColorScheme get darkScheme =>
      ColorScheme.fromSeed(
        seedColor: brandPrimaryDark,
        brightness: Brightness.dark,
      ).copyWith(
        primary: brandPrimaryDark,
        secondary: brandSecondary,
        error: errorDark,
        surface: neutral800,
        onSurface: neutral50,
      );
}
