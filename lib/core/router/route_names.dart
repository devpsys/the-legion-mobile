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

  // Account recovery flow
  static const String forgotPassword = '/forgot-password';
  static const String verifyRecoveryCode = '/forgot-password/verify';
  static const String setNewPassword = '/forgot-password/new-password';
  static const String recoverySuccess = '/forgot-password/success';

  // Route names, used for navigation so paths can change freely.
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String profileName = 'profile';
  static const String forgotPasswordName = 'forgotPassword';
  static const String verifyRecoveryCodeName = 'verifyRecoveryCode';
  static const String setNewPasswordName = 'setNewPassword';
  static const String recoverySuccessName = 'recoverySuccess';

  /// Reachable only while signed out — recovery is pointless once
  /// authenticated, so the redirect sends those deep links to the app shell.
  static const Set<String> recoveryPaths = {
    forgotPassword,
    verifyRecoveryCode,
    setNewPassword,
    recoverySuccess,
  };
}
