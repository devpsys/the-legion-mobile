/// Screen size buckets derived from [AppDimensions] breakpoints.
///
/// Presentation code branches on this bucket instead of reading raw pixel
/// values, and everything reacts to the viewport (never to `Platform`) so
/// Android, iOS and Web behave identically.
enum ScreenSize {
  /// Phones in portrait.
  compact,

  /// Large phones in landscape / small tablets.
  medium,

  /// Tablets and small desktop windows.
  expanded,

  /// Wide desktop and web windows.
  large;

  bool get isCompact => this == ScreenSize.compact;

  bool get isCompactOrMedium =>
      this == ScreenSize.compact || this == ScreenSize.medium;

  bool get isAtLeastExpanded =>
      this == ScreenSize.expanded || this == ScreenSize.large;
}

/// Resolves the [ScreenSize] bucket for the given viewport [width].
ScreenSize resolveScreenSize(double width) {
  if (width >= AppDimensions.largeBreakpoint) return ScreenSize.large;
  if (width >= AppDimensions.expandedBreakpoint) return ScreenSize.expanded;
  if (width >= AppDimensions.mediumBreakpoint) return ScreenSize.medium;
  return ScreenSize.compact;
}

/// Layout tokens: maximum content widths, control sizes and breakpoints.
///
/// Breakpoints follow the design spec: mobile < 600px, tablet 600–1024px,
/// desktop > 1024px (12-column layout, 1280px centred frame).
abstract final class AppDimensions {
  /// Widest a reading-oriented layout may grow on phones/tablets.
  static const double maxContentWidth = 720;

  /// Widest a form may grow on tablet/desktop.
  static const double maxFormWidth = 480;

  /// Centred desktop frame from the design spec.
  static const double maxFrameWidth = 1280;

  /// Minimum touch target and control height across all densities (spec: 44).
  static const double minTapTarget = 44;

  static const double buttonHeight = 44;
  static const double inputHeight = 44;
  static const double badgeHeight = 24;
  static const double checkboxSize = 20;

  /// Uniform 1px perimeter stroke used instead of elevation.
  static const double hairline = 1;

  /// 2px focus ring per the spec.
  static const double focusRingWidth = 2;

  // --- Icon scale ---------------------------------------------------------
  // Glyph sizes across the app. Widgets read these instead of spelling out a
  // number next to `Icon(size: …)`.

  /// 12px — dense rows and inline status glyphs.
  static const double iconMicro = 12;

  static const double iconSmall = 16;

  /// 18px — the default size of Material Symbols in the designs.
  static const double iconDense = 18;

  static const double iconMedium = 20;

  /// 22px — sheet and notice headers.
  static const double iconHero = 22;

  /// 30px — the success glyph inside a status mark.
  static const double iconDisplay = 30;

  /// Size of decorative icons that illustrate an empty or error state.
  static const double iconLarge = 40;

  // --- Surfaces and marks -------------------------------------------------

  /// Side of the square icon tile on a card (timeline step, credential row).
  static const double iconTile = 36;

  /// Side of the compact icon tile on a directory row.
  static const double iconTileSmall = 32;

  /// Diameter of a marker on a vertical rail or timeline.
  static const double marker = 24;

  /// Side of a small round indicator (status pip, unread bullet).
  static const double indicator = 8;

  /// Width of the status stripe down the left edge of a card.
  static const double accentStripe = 4;

  /// Width of the wider category stripe on a bulletin.
  static const double accentStripeWide = 5;

  /// Height of a progress track, meter or rail segment.
  static const double trackHeight = 8;

  /// Height of the thin strength/cooldown meter.
  static const double meterHeight = 4;

  /// Height of a directory or list row.
  static const double rowHeight = 56;

  /// Side of a round monogram or crest container.
  static const double monogramSize = 40;

  /// Side of the large status mark on a confirmation screen.
  static const double statusMark = 64;

  /// Side of a hero avatar carrying an online marker.
  static const double avatarLarge = 56;

  /// Side of an avatar in an app bar or list header.
  static const double avatarSmall = 32;

  /// Height of a one-time-code digit box.
  static const double codeFieldHeight = 48;

  /// Height of the primary and secondary actions in a bottom sheet.
  /// Height of a compact inline button, e.g. a section's "Apply".
  static const double buttonCompact = 36;

  /// Height of a navigation tab's icon.
  static const double iconTab = 22;

  /// Width of the underline beneath the active navigation tab.
  static const double tabIndicator = 24;

  /// Thickness of that underline.
  static const double tabIndicatorHeight = 2.5;

  /// Height of the candidate portal's tab bar.
  static const double admissionsBarHeight = 64;

  /// Height of a horizontal filter-chip strip.
  ///
  /// One tap target tall: the strip is a control row, not a line of text, so
  /// the pills need room to be pressed as well as to be read.
  static const double filterChipRowHeight = 44;

  /// Widest the cycle pill may grow in the candidate portal's app bar; it sits
  /// between the menu button and the bell, so a longer cycle name ellipsizes.
  static const double cyclePillMaxWidth = 180;

  /// Height of a bottom sheet's primary and secondary actions.
  static const double sheetActionHeight = 48;

  /// Drag handle of a bottom sheet.
  static const double sheetHandleWidth = 40;
  static const double sheetHandleHeight = 6;

  /// Largest share of the viewport a bottom sheet may cover.
  static const double sheetMaxHeightFactor = 0.6;

  /// Widest a line of body copy before it stops growing, so an empty state's
  /// paragraph stays readable instead of spanning the canvas.
  static const double copyMeasure = 260;

  /// Widest a piece of chrome (splash mark, sign-in brand) may grow.
  static const double chromeMaxWidth = 320;

  /// Widest the hub's term pill may grow inside the app bar. It sits beside
  /// the leading button, the notification bell and the avatar, so it yields
  /// rather than pushing them off a 390px phone; a longer localized session
  /// name ellipsizes.
  static const double termPillMaxWidth = 200;

  /// Reference viewport the designs were drawn at (390 × 844).
  static const double referenceWidth = 390;
  static const double referenceHeight = 844;

  /// Width (inclusive) at which the compact layout applies: phones.
  static const double mediumBreakpoint = 600;

  /// Width (inclusive) at which navigation moves to a rail: tablets.
  static const double expandedBreakpoint = 1024;

  /// Width (inclusive) above which the shell is width constrained.
  static const double largeBreakpoint = 1440;
}
