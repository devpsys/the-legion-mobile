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
/// Everything here is a design decision, which is why it lives in the design
/// system instead of being repeated across widgets.
abstract final class AppDimensions {
  /// Widest a reading-oriented layout may grow on phones/tablets.
  static const double maxContentWidth = 640;

  /// Widest a form or dashboard may grow on tablet/desktop.
  static const double maxFormWidth = 480;

  /// Minimum interactive size recommended by the platform guidelines.
  static const double minTapTarget = 48;

  static const double buttonHeight = 48;
  static const double dividerThickness = 1;
  static const double iconSmall = 20;

  /// Size of decorative icons that illustrate an empty or error state.
  static const double iconLarge = 40;

  /// Width (inclusive) at which the compact layout applies: phones.
  static const double mediumBreakpoint = 600;

  /// Width (inclusive) at which navigation moves to a rail: tablets.
  static const double expandedBreakpoint = 840;

  /// Width (inclusive) above which the shell is width constrained.
  static const double largeBreakpoint = 1440;
}
