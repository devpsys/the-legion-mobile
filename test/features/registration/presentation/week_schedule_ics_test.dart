import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/registration/presentation/models/registration_models.dart';
import 'package:the_legion_mobile/features/registration/presentation/utils/week_schedule_ics.dart';

void main() {
  group('WeekScheduleIcs.parseTimeLabel', () {
    test('reads HH:mm', () {
      expect(WeekScheduleIcs.parseTimeLabel('09:00'), (9, 0));
      expect(WeekScheduleIcs.parseTimeLabel('14:30'), (14, 30));
    });

    test('rejects malformed labels', () {
      expect(
        () => WeekScheduleIcs.parseTimeLabel('9am'),
        throwsFormatException,
      );
      expect(
        () => WeekScheduleIcs.parseTimeLabel('25:00'),
        throwsFormatException,
      );
    });
  });

  group('WeekScheduleIcs.escapeText', () {
    test('escapes backslash, semicolon, comma and newlines', () {
      expect(
        WeekScheduleIcs.escapeText('A;B,C\\D\nE'),
        r'A\;B\,C\\D\nE',
      );
    });
  });

  group('WeekScheduleIcs.nextOccurrence', () {
    test('keeps today when weekday and time are still ahead', () {
      // Wednesday 2026-10-07 08:00 — next Wed 09:00 is the same day.
      final from = DateTime(2026, 10, 7, 8);
      final next = WeekScheduleIcs.nextOccurrence(
        weekday: DateTime.wednesday,
        timeLabel: '09:00',
        from: from,
      );
      expect(next, DateTime(2026, 10, 7, 9));
    });

    test('rolls forward when today\'s slot has passed', () {
      final from = DateTime(2026, 10, 7, 10);
      final next = WeekScheduleIcs.nextOccurrence(
        weekday: DateTime.wednesday,
        timeLabel: '09:00',
        from: from,
      );
      expect(next, DateTime(2026, 10, 14, 9));
    });

    test('finds the next matching weekday', () {
      // Wednesday → next Monday.
      final from = DateTime(2026, 10, 7, 8);
      final next = WeekScheduleIcs.nextOccurrence(
        weekday: DateTime.monday,
        timeLabel: '09:00',
        from: from,
      );
      expect(next, DateTime(2026, 10, 12, 9));
    });
  });

  group('WeekScheduleIcs.build', () {
    const meetings = [
      WeekMeeting(
        weekday: 1,
        startLabel: '09:00',
        endLabel: '11:00',
        courseCode: 'CSC301',
        venue: 'LT1',
      ),
      WeekMeeting(
        weekday: 3,
        startLabel: '14:00',
        endLabel: '16:00',
        courseCode: 'CSC;315',
        venue: 'Lab, A',
      ),
    ];

    test('emits a calendar with weekly RRULEs and escaped text', () {
      final ics = WeekScheduleIcs.build(
        meetings: meetings,
        calendarName: 'The Legion · 2026/2027 · First semester',
        session: '2026/2027',
        termLabel: 'First semester',
        anchor: DateTime(2026, 10, 6, 8),
        weeksAhead: 16,
      );

      expect(ics, contains('BEGIN:VCALENDAR'));
      expect(ics, contains('END:VCALENDAR'));
      expect(ics, contains('BEGIN:VEVENT'));
      expect(ics, contains('SUMMARY:CSC301'));
      expect(ics, contains('LOCATION:LT1'));
      expect(ics, contains('SUMMARY:CSC\\;315'));
      expect(ics, contains('LOCATION:Lab\\, A'));
      expect(ics, contains('RRULE:FREQ=WEEKLY;UNTIL='));
      expect(ics, contains('DTSTART:20261012T090000'));
      expect(ics, contains('DTEND:20261012T110000'));
      expect(ics, contains('X-WR-CALNAME:The Legion · 2026/2027 · First semester'));
    });

    test('fileName sanitises session and term', () {
      expect(
        WeekScheduleIcs.fileName(
          session: '2026/2027',
          termLabel: 'First semester',
        ),
        'legion_week_2026_2027_First_semester.ics',
      );
    });
  });
}
