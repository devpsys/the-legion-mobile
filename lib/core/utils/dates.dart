import 'package:intl/intl.dart';

/// The date formats the app prints, in the day-first order the designs use.
///
/// `intl`'s skeletons (`yMMMd`, `MMMd`) take their field order from the
/// locale, and under `en` that is month-first — "Sep 14, 2026" — while every
/// design in `ui-designs/` writes "14 Sep 2026". Explicit patterns pin the
/// order, and keep it the same whatever locale the device reports. The month
/// and weekday names still come from [locale], so a translation changes the
/// words, not the layout.
///
/// Presentation code reaches for one of these rather than `DateFormat`
/// directly, so a date reads the same on every screen.
abstract final class AppDateFormats {
  /// `14 September 2026` — a date in prose: a deadline, a decision.
  static DateFormat long(String locale) => DateFormat('d MMMM y', locale);

  /// `15 January 2027, 11:08` — a date and time written out in full, on a
  /// receipt or an audit line.
  static DateFormat longDateTime(String locale) =>
      DateFormat('d MMMM y, HH:mm', locale);

  /// `Saturday 3 October 2026, 10:00` — a hearing appointment line.
  static DateFormat weekdayLongDateTime(String locale) =>
      DateFormat('EEEE d MMMM y, HH:mm', locale);

  /// `14 Sep 2026` — a date on a card or in a column.
  static DateFormat medium(String locale) => DateFormat('d MMM y', locale);

  /// `Sep 2029` — a card expiry month on an ID history line.
  static DateFormat monthYear(String locale) => DateFormat('MMM y', locale);

  /// `14 Sep` — a date on a timeline, where the year is understood.
  static DateFormat short(String locale) => DateFormat('d MMM', locale);

  /// `Thursday, 1 October 2026` — today, on the hub.
  static DateFormat full(String locale) => DateFormat('EEEE, d MMMM y', locale);

  /// `09:00` — a 24-hour time, printed beside a date.
  static DateFormat time(String locale) => DateFormat.Hm(locale);

  /// `02 / 05 / 2008` — a date in a form field, digit by digit, the way a
  /// candidate reads it off a slip.
  static DateFormat field(String locale) => DateFormat('dd / MM / y', locale);
}
