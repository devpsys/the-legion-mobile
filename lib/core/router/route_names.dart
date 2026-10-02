/// Single source of truth for every navigation path.
///
/// Widgets must navigate with `context.goNamed(Routes.loginName)` /
/// `context.pushNamed(...)` and never with an inline string literal, so deep
/// links and web URLs can be changed in one place.
abstract final class Routes {
  // Paths
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/home/profile';

  // Route names, used for navigation so paths can change freely.
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String profileName = 'profile';
}
