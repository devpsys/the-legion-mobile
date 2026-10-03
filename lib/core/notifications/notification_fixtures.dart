import '../notifications/notification_entry.dart';

/// Sample notifications the centre starts with.
///
/// Temporary: the API's inbox replaces this the moment it exists, and the
/// fixture disappears with it. Seeded once at startup rather than per feature,
/// so the badge is the same number everywhere.
abstract final class NotificationFixtures {
  static final List<NotificationEntry> entries = [
    const NotificationEntry(
      id: 'exam-venue',
      category: NotificationCategory.urgent,
      publishedLabel: '3 hours ago',
      title: 'Examination venue changes for Faculty of Science',
    ),
    const NotificationEntry(
      id: 'hostel-maintenance',
      category: NotificationCategory.warning,
      publishedLabel: 'Yesterday',
      title: 'Hostel maintenance protocol & inspection window',
    ),
    const NotificationEntry(
      id: 'library-archive',
      category: NotificationCategory.information,
      publishedLabel: '2 days ago',
      title: 'Library digital archive access extended',
    ),
    const NotificationEntry(
      id: 'jamb-results',
      category: NotificationCategory.success,
      publishedLabel: '6 days ago',
      title: 'JAMB results received for the 2026 examination',
    ),
  ];
}
