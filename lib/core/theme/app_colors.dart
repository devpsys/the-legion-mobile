import 'package:flutter/material.dart';

/// Color tokens of the design system — "Institutional Sovereign".
///
/// Source of truth: `ui-designs/institutional_sovereign/DESIGN.md`, cross
/// checked against the Tailwind tokens in the exported `code.html` files
/// (`tailwind.config.colors`), which are the values the screens actually use.
///
/// Widgets must read colors from the ambient [ThemeData] (`colorScheme`,
/// `textTheme`, ...) or from these tokens — never from a raw
/// `Color(0xFF...)` literal.
///
/// Style rules that come with this palette:
/// * no gradients, no glows, no emoji;
/// * elevation comes from 1px hairline strokes, not diffuse shadows;
/// * primary action inverts to honey gold in dark mode so it stays legible.
abstract final class AppColors {
  // --- Brand -------------------------------------------------------------
  /// Brand navy: the primary actionable anchor in light mode.
  static const Color navy = Color(0xFF0F3F6B);

  /// Hover / pressed navy.
  static const Color navyPressed = Color(0xFF0B2F50);

  /// Honey gold: the premium attention anchor, and the primary action in dark
  /// mode (inverted so heavy navy does not sink into deep surfaces).
  static const Color honeyGold = Color(0xFFE6B841);

  static const Color honeyGoldPressed = Color(0xFFC99E32);

  /// Text/icon colour that sits on [honeyGold].
  static const Color onGoldLight = Color(0xFF402908);
  static const Color onGoldDark = Color(0xFF2D1D06);

  /// Informational accent that replaces navy in dark mode (links, indicators).
  static const Color navyInkDark = Color(0xFFA0C7EE);

  /// Standard 2px focus ring.
  static const Color focusRing = Color(0xFF1B6EBB);

  // --- Surfaces & strokes (light) ----------------------------------------
  /// Level 0 — canvas base.
  static const Color canvasLight = Color(0xFFEBF0F5);

  /// Level 1 — cards and section containers.
  static const Color cardLight = Color(0xFFFFFFFF);

  /// Level 2 — in-card blocks and input fields.
  static const Color subtleLight = Color(0xFFF2F5F7);

  /// Uniform 1px perimeter stroke.
  static const Color strokeLight = Color(0xFFD1DBE5);

  // --- Surfaces & strokes (dark) -----------------------------------------
  /// Level 0 — deep void base.
  static const Color canvasDark = Color(0xFF0B1219);

  /// Level 1 — structural card.
  static const Color cardDark = Color(0xFF121C26);

  /// Level 2 — subtle inset.
  static const Color subtleDark = Color(0xFF1D2630);

  /// Level 2 — input field surface (slightly deeper than the inset).
  static const Color inputDark = Color(0xFF0F171F);

  static const Color strokeDark = Color(0xFF28333E);

  // --- Text ---------------------------------------------------------------
  static const Color textPrimaryLight = Color(0xFF141F29);
  static const Color textMutedLight = Color(0xFF55616D);
  static const Color textPrimaryDark = Color(0xFFE8EBEE);
  static const Color textMutedDark = Color(0xFF98A3AE);

  // --- Semantic status pairs (text on container) -------------------------
  static const Color successTextLight = Color(0xFF15793A);
  static const Color successSurfaceLight = Color(0xFFDFF6E8);
  static const Color successTextDark = Color(0xFF59CF84);
  static const Color successSurfaceDark = Color(0xFF153220);

  static const Color warningTextLight = Color(0xFF8A590F);
  static const Color warningSurfaceLight = Color(0xFFFBEFD0);
  static const Color warningTextDark = Color(0xFFF0BF4C);
  static const Color warningSurfaceDark = Color(0xFF362A12);

  static const Color infoTextLight = Color(0xFF165998);
  static const Color infoSurfaceLight = Color(0xFFE2EDF9);
  static const Color infoTextDark = Color(0xFF71B3F4);
  static const Color infoSurfaceDark = Color(0xFF14293D);

  static const Color dangerTextLight = Color(0xFFB81E1E);
  static const Color dangerSurfaceLight = Color(0xFFFDE7E7);
  static const Color dangerTextDark = Color(0xFFEF6C6C);
  static const Color dangerSurfaceDark = Color(0xFF3B1616);

  static const Color brandTintSurfaceLight = Color(0xFFDFEBF6);

  // --- Portal role accents -----------------------------------------------
  // Reserved for role badges, contextual top bars and breadcrumb pips.
  static const Color portalStudent = Color(0xFF5CC188);
  static const Color portalStaff = Color(0xFFE2B150);
  static const Color portalAdmin = Color(0xFF709FE1);
  static const Color portalCandidate = Color(0xFF809CEF);
  static const Color portalGuardian = Color(0xFFAB99E5);

  // --- Brightness-aware lookups ------------------------------------------

  static Color canvas(Brightness brightness) =>
      brightness == Brightness.dark ? canvasDark : canvasLight;

  static Color card(Brightness brightness) =>
      brightness == Brightness.dark ? cardDark : cardLight;

  static Color subtle(Brightness brightness) =>
      brightness == Brightness.dark ? subtleDark : subtleLight;

  static Color inputSurface(Brightness brightness) =>
      brightness == Brightness.dark ? inputDark : cardLight;

  static Color stroke(Brightness brightness) =>
      brightness == Brightness.dark ? strokeDark : strokeLight;

  static Color textPrimary(Brightness brightness) =>
      brightness == Brightness.dark ? textPrimaryDark : textPrimaryLight;

  static Color textMuted(Brightness brightness) =>
      brightness == Brightness.dark ? textMutedDark : textMutedLight;

  /// Primary action colour: navy in light mode, honey gold in dark.
  static Color primaryAction(Brightness brightness) =>
      brightness == Brightness.dark ? honeyGold : navy;

  /// Text that sits on [primaryAction].
  static Color onPrimaryAction(Brightness brightness) =>
      brightness == Brightness.dark ? onGoldDark : Colors.white;

  static Color successText(Brightness brightness) =>
      brightness == Brightness.dark ? successTextDark : successTextLight;

  static Color successSurface(Brightness brightness) =>
      brightness == Brightness.dark ? successSurfaceDark : successSurfaceLight;

  static Color warningText(Brightness brightness) =>
      brightness == Brightness.dark ? warningTextDark : warningTextLight;

  static Color warningSurface(Brightness brightness) =>
      brightness == Brightness.dark ? warningSurfaceDark : warningSurfaceLight;

  static Color infoText(Brightness brightness) =>
      brightness == Brightness.dark ? infoTextDark : infoTextLight;

  static Color infoSurface(Brightness brightness) =>
      brightness == Brightness.dark ? infoSurfaceDark : infoSurfaceLight;

  static Color dangerText(Brightness brightness) =>
      brightness == Brightness.dark ? dangerTextDark : dangerTextLight;

  static Color dangerSurface(Brightness brightness) =>
      brightness == Brightness.dark ? dangerSurfaceDark : dangerSurfaceLight;

  // --- ColorScheme --------------------------------------------------------

  static ColorScheme get lightScheme => _scheme(Brightness.light);

  static ColorScheme get darkScheme => _scheme(Brightness.dark);

  static ColorScheme _scheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: navy,
      brightness: brightness,
    );

    return scheme.copyWith(
      // Dark mode inverts the primary action to honey gold.
      primary: primaryAction(brightness),
      onPrimary: onPrimaryAction(brightness),
      primaryContainer: isDark ? honeyGoldPressed : navyPressed,
      onPrimaryContainer: isDark ? onGoldDark : Colors.white,
      // Honey gold remains the premium attention anchor in both modes.
      secondary: honeyGold,
      onSecondary: isDark ? onGoldDark : onGoldLight,
      secondaryContainer: isDark ? honeyGoldPressed : honeyGold,
      onSecondaryContainer: isDark ? onGoldDark : onGoldLight,
      tertiary: navyInkDark,
      onTertiary: textPrimaryLight,
      tertiaryContainer: brandTintSurfaceLight,
      onTertiaryContainer: navy,

      error: dangerText(brightness),
      onError: Colors.white,
      errorContainer: dangerSurface(brightness),
      onErrorContainer: dangerText(brightness),

      surface: card(brightness),
      onSurface: textPrimary(brightness),
      surfaceContainerLowest: card(brightness),
      surfaceContainerLow: subtle(brightness),
      surfaceContainer: subtle(brightness),
      surfaceContainerHigh: subtle(brightness),
      surfaceContainerHighest: subtle(brightness),
      onSurfaceVariant: textMuted(brightness),
      outline: stroke(brightness),
      outlineVariant: stroke(brightness),

      inverseSurface: isDark ? cardLight : canvasDark,
      onInverseSurface: isDark ? textPrimaryLight : textPrimaryDark,
      inversePrimary: isDark ? navy : honeyGold,
    );
  }
}
