import 'package:equatable/equatable.dart';

import '../theme/app_tone.dart';

/// One thing the university has told the signed-in person.
///
/// Session-wide, not module-wide: the notification bell in the student hub and
/// the one in the candidate portal are the *same* bell, so they must show the
/// same count and open the same list. Keeping the model in core is what lets two
/// features render one inbox instead of two private copies that drift apart.
///
/// `body` is optional because the bell's sheet shows a headline and a timestamp,
/// while a board section on a full screen has room for the summary too.
class NotificationEntry extends Equatable {
  const NotificationEntry({
    required this.id,
    required this.category,
    required this.publishedLabel,
    required this.title,
    this.body,
  });

  final String id;

  /// Editorial weight, which decides the tone of the row's marker.
  final NotificationCategory category;

  /// Relative timestamp, e.g. `3 hours ago`.
  final String publishedLabel;

  final String title;
  final String? body;

  @override
  List<Object?> get props => [id, category, publishedLabel, title, body];
}

/// How loudly a [NotificationEntry] is presented.
///
/// Deliberately coarser than either module's own vocabulary: the bell has to
/// summarise both the student's notices and the candidate's deadlines in one
/// list, and it must not imply a candidate has been rejected because a
/// student has a hostel inspection.
enum NotificationCategory {
  /// Cannot wait.
  urgent,

  /// Needs attention, not alarm.
  warning,

  /// Informational.
  information,

  /// Something finished.
  success,
}

/// Semantic tone of a [NotificationCategory].
extension NotificationCategoryTone on NotificationCategory {
  AppTone get tone => switch (this) {
    NotificationCategory.urgent => AppTone.danger,
    NotificationCategory.warning => AppTone.warning,
    NotificationCategory.information => AppTone.info,
    NotificationCategory.success => AppTone.success,
  };
}
