import '../l10n/gen/app_localizations.dart';

/// Time of day a greeting belongs to.
///
/// Kept as an enum so the clock decides the period while the words stay in the
/// ARB, and so the boundaries are unit testable without a widget tree.
///
/// Shared: both the student hub and the candidate portal greet the user on
/// arrival, and two thresholds would be two chances to disagree.
enum GreetingPeriod {
  morning,
  afternoon,
  evening;

  /// Morning before noon, afternoon until 17:00, evening after that.
  static GreetingPeriod forHour(int hour) {
    if (hour < 12) return GreetingPeriod.morning;
    if (hour < 17) return GreetingPeriod.afternoon;
    return GreetingPeriod.evening;
  }

  /// The period for [time].
  static GreetingPeriod forTime(DateTime time) =>
      GreetingPeriod.forHour(time.hour);

  /// Localized greeting for the period.
  String localize(AppLocalizations l10n) => switch (this) {
    GreetingPeriod.morning => l10n.commonGreetingMorning,
    GreetingPeriod.afternoon => l10n.commonGreetingAfternoon,
    GreetingPeriod.evening => l10n.commonGreetingEvening,
  };
}
