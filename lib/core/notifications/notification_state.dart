import 'package:equatable/equatable.dart';

import 'notification_entry.dart';

/// The session's unread notifications.
///
/// A singleton on purpose: two screens reading the same object is the only way
/// to guarantee they agree. A per-feature counter would drift the moment one
/// screen marked something read and the other did not.
class NotificationCentre extends Equatable {
  const NotificationCentre({this.entries = const [], this.readIds = const {}});

  /// Everything the person has not been shown yet, newest first.
  final List<NotificationEntry> entries;

  /// Ids already read, so the badge can fall without losing the list.
  final Set<String> readIds;

  /// What the bell badges.
  int get unreadCount => entries.where((e) => !readIds.contains(e.id)).length;

  /// Entries still unread, newest first.
  List<NotificationEntry> get unreadEntries =>
      entries.where((e) => !readIds.contains(e.id)).toList();

  bool isRead(String id) => readIds.contains(id);

  NotificationCentre copyWith({
    List<NotificationEntry>? entries,
    Set<String>? readIds,
  }) => NotificationCentre(
    entries: entries ?? this.entries,
    readIds: readIds ?? this.readIds,
  );

  @override
  List<Object?> get props => [entries, readIds];
}
