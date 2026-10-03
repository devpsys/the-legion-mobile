import 'package:get_it/get_it.dart';

import '../notifications/notification_cubit.dart';
import '../notifications/notification_fixtures.dart';

/// Registers the session's notification centre.
///
/// A singleton, and that is the whole point: the student hub and the candidate
/// portal both badge their bell from this one object, so they cannot disagree
/// about how many things are unread.
void registerNotificationsModule(GetIt sl) {
  sl.registerSingleton<NotificationCubit>(
    NotificationCubit(entries: NotificationFixtures.entries),
  );
}
