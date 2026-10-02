import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_overview_page.dart';
import '../../features/home/presentation/pages/home_shell_page.dart';
import '../../features/password_recovery/presentation/bloc/password_recovery_cubit.dart';
import '../../features/password_recovery/presentation/pages/recovery_success_page.dart';
import '../../features/password_recovery/presentation/pages/request_recovery_code_page.dart';
import '../../features/password_recovery/presentation/pages/set_new_password_page.dart';
import '../../features/password_recovery/presentation/pages/verify_recovery_code_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../di/injection.dart';
import 'auth_guard.dart';
import 'route_names.dart';
import 'router_refresh_notifier.dart';
import 'widgets/route_error_page.dart';

/// Decides where [location] must redirect to, or `null` to stay.
///
/// Extracted from [createRouter] as a pure function so the authentication
/// rules can be unit tested without a widget tree or a router instance.
///
/// | Session | Current location | Redirect |
/// | --- | --- | --- |
/// | unresolved | anything but `/` | `/` (splash) |
/// | resolved, anonymous | anything but `/login` and the recovery flow | `/login` |
/// | resolved, authenticated | `/`, `/login` or the recovery flow | `/home` |
String? resolveRedirect({
  required AuthGuard authGuard,
  required String location,
}) {
  // Until the persisted session is restored, only the splash is reachable so
  // protected screens never flash before authentication is known.
  if (!authGuard.isSessionResolved) {
    return location == Routes.splash ? null : Routes.splash;
  }

  if (!authGuard.isAuthenticated) {
    // Anonymous: the splash has done its job. Sign-in and the recovery flow
    // are the only reachable screens — recovery is exactly what a signed-out
    // visitor needs, so it must not bounce back to sign-in.
    final isPublicScreen =
        location == Routes.login || Routes.recoveryPaths.contains(location);
    return isPublicScreen ? null : Routes.login;
  }

  // Authenticated: nothing left to do on the splash, the login screen or the
  // recovery flow.
  final isEntryScreen = location == Routes.splash || location == Routes.login;
  if (isEntryScreen || Routes.recoveryPaths.contains(location)) {
    return Routes.home;
  }
  return null;
}

/// Builds the application router.
///
/// Handles authentication-aware redirects, deep links and web URLs. The
/// router is the composition root of navigation: it is the only place allowed
/// to reference concrete feature pages.
GoRouter createRouter({
  required AuthGuard authGuard,
  required Stream<Object?> authStateChanges,
}) {
  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: RouterRefreshNotifier(authStateChanges),
    errorBuilder: (context, state) =>
        RouteErrorPage(location: state.uri.toString()),
    redirect: (context, state) =>
        resolveRedirect(authGuard: authGuard, location: state.matchedLocation),
    routes: [
      GoRoute(
        path: Routes.splash,
        name: Routes.splashName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: Routes.login,
        name: Routes.loginName,
        builder: (context, state) => const LoginPage(),
      ),
      // One cubit for the whole recovery flow: the identifier, the masked
      // destinations and the attempt counters survive step changes, and a new
      // entry into the flow starts clean.
      ShellRoute(
        builder: (context, state, child) => BlocProvider<PasswordRecoveryCubit>(
          create: (context) => sl<PasswordRecoveryCubit>(),
          child: child,
        ),
        routes: [
          GoRoute(
            path: Routes.forgotPassword,
            name: Routes.forgotPasswordName,
            builder: (context, state) => const RequestRecoveryCodePage(),
          ),
          GoRoute(
            path: Routes.verifyRecoveryCode,
            name: Routes.verifyRecoveryCodeName,
            builder: (context, state) => const VerifyRecoveryCodePage(),
          ),
          GoRoute(
            path: Routes.setNewPassword,
            name: Routes.setNewPasswordName,
            builder: (context, state) => const SetNewPasswordPage(),
          ),
          GoRoute(
            path: Routes.recoverySuccess,
            name: Routes.recoverySuccessName,
            builder: (context, state) => const RecoverySuccessPage(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                name: Routes.homeName,
                builder: (context, state) => const HomeOverviewPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                name: Routes.profileName,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
