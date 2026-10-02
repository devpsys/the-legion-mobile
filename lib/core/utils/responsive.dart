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

  static const double iconSmall = 16;
  static const double iconMedium = 20;

  /// Size of decorative icons that illustrate an empty or error state.
  static const double iconLarge = 40;

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
