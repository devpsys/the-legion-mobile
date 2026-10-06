import 'dart:convert';

import 'package:share_plus/share_plus.dart';

import '../models/registration_models.dart';
import 'week_schedule_ics.dart';

/// Shares the week strip as an `.ics` file through the system share sheet.
abstract final class WeekScheduleCalendarShare {
  /// Builds and shares an ICS for [meetings].
  ///
  /// Returns the [ShareResult] from `share_plus`. Throws when [meetings] is
  /// empty or the ICS cannot be built.
  static Future<ShareResult> share({
    required List<WeekMeeting> meetings,
    required String session,
    required String termLabel,
    DateTime? anchor,
  }) async {
    if (meetings.isEmpty) {
      throw StateError('No meetings to share');
    }

    final calendarName = 'The Legion · $session · $termLabel';
    final ics = WeekScheduleIcs.build(
      meetings: meetings,
      calendarName: calendarName,
      session: session,
      termLabel: termLabel,
      anchor: anchor,
    );
    final fileName = WeekScheduleIcs.fileName(
      session: session,
      termLabel: termLabel,
    );

    return SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            utf8.encode(ics),
            mimeType: 'text/calendar',
            name: fileName,
          ),
        ],
        subject: calendarName,
        fileNameOverrides: [fileName],
      ),
    );
  }
}
