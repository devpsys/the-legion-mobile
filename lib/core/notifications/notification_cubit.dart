import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_entry.dart';
import 'notification_state.dart';

/// The one unread-notification list the whole app reads.
///
/// Registered as a singleton in `core/di/injection.dart`, so the bell in the
/// student hub and the bell in the candidate portal are guaranteed to show the
/// same count and to open the same sheet — a per-feature cubit would show two
/// different numbers for the same session.
class NotificationCubit extends Cubit<NotificationCentre> {
  NotificationCubit({List<NotificationEntry> entries = const []})
    : super(NotificationCentre(entries: entries));

  /// Replaces the inbox, e.g. when a fetch lands.
  void load(List<NotificationEntry> entries) =>
      emit(state.copyWith(entries: entries));

  /// Adds one notification, newest first.
  void push(NotificationEntry entry) {
    if (state.entries.any((e) => e.id == entry.id)) return;
    emit(state.copyWith(entries: [entry, ...state.entries]));
  }

  /// Marks one as read; the badge falls, the entry stays in the list.
  void markRead(String id) {
    if (state.isRead(id)) return;
    emit(state.copyWith(readIds: {...state.readIds, id}));
  }

  /// Marks everything as read.
  void markAllRead() {
    if (state.readIds.length == state.entries.length) return;
    emit(
      state.copyWith(
        readIds: {...state.readIds, ...state.entries.map((e) => e.id)},
      ),
    );
  }

  /// Forgets every notification, for a fresh session.
  void clear() => emit(const NotificationCentre());
}
