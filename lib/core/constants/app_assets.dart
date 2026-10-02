/// Keys of the assets bundled with the application.
///
/// Referencing assets through these constants keeps the paths in one place, so
/// moving or renaming a file is a single edit and no widget spells out a raw
/// path.
abstract final class AppAssets {
  /// Portrait of the student account, used while the API serves no avatar.
  ///
  /// Demo content: the real backend returns an `avatarUrl` per user, and this
  /// entry disappears with the fake datasource.
  static const String studentAvatar = 'assets/images/student_avatar.png';
}
