import '../models/registration_models.dart';

/// Builds an RFC 5545 `.ics` calendar from registration week meetings.
///
/// Pure Dart — no Flutter — so the RRULE / escape rules can be unit tested.
/// Each meeting becomes a weekly recurring VEVENT starting on the next
/// occurrence of its weekday from [anchor], until [weeksAhead] weeks later.
abstract final class WeekScheduleIcs {
  /// Number of weeks a term timetable is exported for when the window has no
  /// structured end date.
  static const int defaultWeeksAhead = 16;

  /// Calendar product identifier written into `PRODID`.
  static const String productId = '-//The Legion//Registration Week//EN';

  /// Builds the ICS document body for [meetings].
  ///
  /// [calendarName] is used in `X-WR-CALNAME`. [session] and [termLabel] feed
  /// the event description. [anchor] defaults to "now" for the next-occurrence
  /// calculation; pass a fixed instant in tests.
  static String build({
    required List<WeekMeeting> meetings,
    required String calendarName,
    required String session,
    required String termLabel,
    DateTime? anchor,
    int weeksAhead = defaultWeeksAhead,
  }) {
    final now = anchor ?? DateTime.now();
    final stamp = _formatUtc(now.toUtc());
    final buffer = StringBuffer()
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('VERSION:2.0')
      ..writeln('PRODID:$productId')
      ..writeln('CALSCALE:GREGORIAN')
      ..writeln('METHOD:PUBLISH')
      ..writeln('X-WR-CALNAME:${escapeText(calendarName)}');

    for (final meeting in meetings) {
      final start = nextOccurrence(
        weekday: meeting.weekday,
        timeLabel: meeting.startLabel,
        from: now,
      );
      final end = nextOccurrence(
        weekday: meeting.weekday,
        timeLabel: meeting.endLabel,
        from: now,
      );
      // If end is at/before start (crossing midnight), roll end forward a day.
      final endAdjusted = !end.isAfter(start)
          ? end.add(const Duration(days: 1))
          : end;
      final until = start.add(Duration(days: 7 * weeksAhead));
      final uid =
          '${meeting.courseCode}-${meeting.weekday}-'
          '${meeting.startLabel}-${meeting.venue}@thelegion.ng';
      final description = '$session · $termLabel · ${meeting.courseCode}';

      buffer
        ..writeln('BEGIN:VEVENT')
        ..writeln('UID:${escapeText(uid)}')
        ..writeln('DTSTAMP:$stamp')
        ..writeln('DTSTART:${_formatLocal(start)}')
        ..writeln('DTEND:${_formatLocal(endAdjusted)}')
        ..writeln('RRULE:FREQ=WEEKLY;UNTIL=${_formatUtc(until.toUtc())}')
        ..writeln('SUMMARY:${escapeText(meeting.courseCode)}')
        ..writeln('LOCATION:${escapeText(meeting.venue)}')
        ..writeln('DESCRIPTION:${escapeText(description)}')
        ..writeln('END:VEVENT');
    }

    buffer.writeln('END:VCALENDAR');
    return buffer.toString();
  }

  /// Filename hint for the shared `.ics` file.
  static String fileName({
    required String session,
    required String termLabel,
  }) {
    final safeSession = session.replaceAll(RegExp(r'[^\w\-]+'), '_');
    final safeTerm = termLabel.replaceAll(RegExp(r'[^\w\-]+'), '_');
    return 'legion_week_${safeSession}_$safeTerm.ics';
  }

  /// Next local [DateTime] on [weekday] (Mon=1…Sun=7) at [timeLabel] (`HH:mm`),
  /// on or after [from]'s calendar day.
  static DateTime nextOccurrence({
    required int weekday,
    required String timeLabel,
    required DateTime from,
  }) {
    final parts = parseTimeLabel(timeLabel);
    var candidate = DateTime(
      from.year,
      from.month,
      from.day,
      parts.$1,
      parts.$2,
    );
    while (candidate.weekday != weekday || candidate.isBefore(from)) {
      candidate = candidate.add(const Duration(days: 1));
      candidate = DateTime(
        candidate.year,
        candidate.month,
        candidate.day,
        parts.$1,
        parts.$2,
      );
    }
    return candidate;
  }

  /// Parses an `HH:mm` label into `(hour, minute)`.
  ///
  /// Throws [FormatException] when the label is not two colon-separated ints.
  static (int, int) parseTimeLabel(String label) {
    final parts = label.split(':');
    if (parts.length != 2) {
      throw FormatException('Expected HH:mm, got "$label"');
    }
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw FormatException('Out-of-range time "$label"');
    }
    return (hour, minute);
  }

  /// Escapes TEXT values per RFC 5545 (§3.3.11).
  static String escapeText(String value) {
    return value
        .replaceAll(r'\', r'\\')
        .replaceAll(';', r'\;')
        .replaceAll(',', r'\,')
        .replaceAll('\n', r'\n');
  }

  static String _formatLocal(DateTime value) {
    final y = value.year.toString().padLeft(4, '0');
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    final h = value.hour.toString().padLeft(2, '0');
    final min = value.minute.toString().padLeft(2, '0');
    final s = value.second.toString().padLeft(2, '0');
    return '$y$m${d}T$h$min$s';
  }

  static String _formatUtc(DateTime value) {
    final utc = value.toUtc();
    final y = utc.year.toString().padLeft(4, '0');
    final m = utc.month.toString().padLeft(2, '0');
    final d = utc.day.toString().padLeft(2, '0');
    final h = utc.hour.toString().padLeft(2, '0');
    final min = utc.minute.toString().padLeft(2, '0');
    final s = utc.second.toString().padLeft(2, '0');
    return '$y$m${d}T$h$min${s}Z';
  }
}
