import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography scale of the design system — "Institutional Sovereign".
///
/// Source: `ui-designs/institutional_sovereign/DESIGN.md` (`typography`).
///
/// * **Inter** for everything prose-like.
/// * **JetBrains Mono** for identifiers, reference codes, dates and currency —
///   see [codeLarge] / [codeMedium] / [codeSmall].
/// * Data tables must use `FontFeature.tabularFigures()` so columns align.
abstract final class AppTextStyles {
  // Font families bundled in `assets/fonts`.
  static const String fontFamily = 'Inter';
  static const String monoFontFamily = 'JetBrainsMono';

  static const List<String> fontFamilyFallback = <String>[
    'Roboto',
    '.SF UI Text',
    'Segoe UI',
  ];

  static const List<String> monoFontFamilyFallback = <String>[
    'Menlo',
    'Consolas',
    'monospace',
  ];

  // Scale sizes (from the spec).
  static const double headlineLargeSize = 30;
  static const double headlineMediumSize = 22;
  static const double headlineSmallSize = 18;
  static const double titleSize = 16;
  static const double bodyLargeSize = 16;
  static const double bodyMediumSize = 14;
  static const double bodySmallSize = 12;
  static const double labelMediumSize = 13;
  static const double labelSmallSize = 11;
  static const double codeLargeSize = 16;
  static const double codeMediumSize = 13;
  static const double codeSmallSize = 11;

  /// 18px — the digits of a one-time code.
  static const double codeDisplaySize = 18;

  // --- Line heights -------------------------------------------------------

  /// Relaxed leading for running prose (notices, announcements, sheets).
  static const double relaxedLineHeight = 1.45;

  /// Tight leading for dense rows and captions.
  static const double denseLineHeight = 1.3;

  /// Open leading for a formal document's running text — a letter is read
  /// once, slowly, and set like print.
  static const double documentLineHeight = 1.65;

  /// Spaced tracking for a reference code set as a word — `0.08em` at the mono
  /// sizes the designs print codes at.
  static const double trackingCode = 1.04;

  // --- Tracking -----------------------------------------------------------

  /// Letter spacing for spaced-caps section labels.
  static const double trackingCaps = 0.8;

  /// Letter spacing for the widest tracked labels (screen section headings).
  static const double trackingCapsWide = 1.2;

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  /// Line heights from the spec, in logical pixels.
  static const double _lh38 = 38;
  static const double _lh28 = 28;
  static const double _lh24 = 24;
  static const double _lh22 = 22;
  static const double _lh20 = 20;
  static const double _lh18 = 18;
  static const double _lh16 = 16;
  static const double _lh14 = 14;
  static const double _lh26 = 26;

  /// The themed [TextTheme] for [scheme].
  static TextTheme textTheme(ColorScheme scheme) {
    final base = Typography.material2021(colorScheme: scheme).black.apply(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    TextStyle? pick(TextStyle? style, double height) =>
        style?.copyWith(height: height / (style.fontSize ?? bodyMediumSize));

    return base.copyWith(
      // headline-lg — 30/38, w700, -0.02em
      displaySmall: pick(base.displaySmall, _lh38)?.copyWith(
        fontSize: headlineLargeSize,
        fontWeight: bold,
        letterSpacing: -0.6,
        height: _lh38 / headlineLargeSize,
      ),
      // headline-md — 22/28, w600, -0.015em
      headlineMedium: pick(base.headlineMedium, _lh28)?.copyWith(
        fontSize: headlineMediumSize,
        fontWeight: semiBold,
        letterSpacing: -0.33,
        height: _lh28 / headlineMediumSize,
      ),
      // headline-sm — 18/24, w600, -0.01em
      headlineSmall: pick(base.headlineSmall, _lh24)?.copyWith(
        fontSize: headlineSmallSize,
        fontWeight: semiBold,
        letterSpacing: -0.18,
        height: _lh24 / headlineSmallSize,
      ),
      // title-md — 16/22, w600
      titleLarge: pick(base.titleLarge, _lh22)?.copyWith(
        fontSize: titleSize,
        fontWeight: semiBold,
        height: _lh22 / titleSize,
      ),
      titleMedium: pick(base.titleMedium, _lh22)?.copyWith(
        fontSize: titleSize,
        fontWeight: semiBold,
        height: _lh22 / titleSize,
      ),
      // body-lg — 16/24, w400
      bodyLarge: pick(base.bodyLarge, _lh24)?.copyWith(
        fontSize: bodyLargeSize,
        fontWeight: regular,
        height: _lh24 / bodyLargeSize,
      ),
      // body-md — 14/20, w400
      bodyMedium: pick(base.bodyMedium, _lh20)?.copyWith(
        fontSize: bodyMediumSize,
        fontWeight: regular,
        height: _lh20 / bodyMediumSize,
      ),
      // body-sm — 12/16, w400
      bodySmall: pick(base.bodySmall, _lh16)?.copyWith(
        fontSize: bodySmallSize,
        fontWeight: regular,
        color: scheme.onSurfaceVariant,
        height: _lh16 / bodySmallSize,
      ),
      // label-md — 13/18, w600, 0.01em
      labelLarge: pick(base.labelLarge, _lh18)?.copyWith(
        fontSize: labelMediumSize,
        fontWeight: semiBold,
        letterSpacing: 0.13,
        height: _lh18 / labelMediumSize,
      ),
      // label-sm — 11/14, w600, 0.03em
      labelSmall: pick(base.labelSmall, _lh14)?.copyWith(
        fontSize: labelSmallSize,
        fontWeight: semiBold,
        letterSpacing: 0.33,
        height: _lh14 / labelSmallSize,
      ),
    );
  }

  // --- Monospaced utility styles -----------------------------------------
  // Colour is intentionally left unset so they inherit from the ambient text
  // style; use them with `DefaultTextStyle.merge` or `Text(style: ...)`.

  /// code-lg — 16/22, w500.
  static TextStyle get codeLarge => const TextStyle(
    fontFamily: monoFontFamily,
    fontFamilyFallback: monoFontFamilyFallback,
    fontSize: codeLargeSize,
    fontWeight: medium,
    height: _lh22 / codeLargeSize,
  );

  /// code-md — 13/18, w500.
  static TextStyle get codeMedium => const TextStyle(
    fontFamily: monoFontFamily,
    fontFamilyFallback: monoFontFamilyFallback,
    fontSize: codeMediumSize,
    fontWeight: medium,
    height: _lh18 / codeMediumSize,
  );

  /// code-sm — 11/14, w500.
  static TextStyle get codeSmall => const TextStyle(
    fontFamily: monoFontFamily,
    fontFamilyFallback: monoFontFamilyFallback,
    fontSize: codeSmallSize,
    fontWeight: medium,
    height: _lh14 / codeSmallSize,
  );

  /// code-lg — 18/26, w600 — the digits of a one-time code.
  static TextStyle get codeDisplay => const TextStyle(
    fontFamily: monoFontFamily,
    fontFamilyFallback: monoFontFamilyFallback,
    fontSize: codeDisplaySize,
    fontWeight: semiBold,
    height: _lh26 / codeDisplaySize,
  );

  /// Table/ledger cells: tabular figures with lining numerals so columns and
  /// decimal points align. Required by the design spec for data tables.
  static TextStyle tabular(TextStyle style) => style.copyWith(
    fontFeatures: const [
      FontFeature.tabularFigures(),
      FontFeature.liningFigures(),
    ],
  );
}

/// Muted metadata colour for the given [scheme].
Color mutedTextColor(ColorScheme scheme) =>
    AppColors.textMuted(scheme.brightness);
