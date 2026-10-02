import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_overview_page.dart';
import '../../features/home/presentation/pages/home_shell_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
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
/// | resolved, anonymous | anything but `/login` | `/login` |
/// | resolved, authenticated | `/` or `/login` | `/home` |
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
    // Anonymous: the splash has done its job, hand over to the login screen.
    return location == Routes.login ? null : Routes.login;
  }

  // Authenticated: nothing left to do on the splash or the login screen.
  final isEntryScreen = location == Routes.splash || location == Routes.login;
  return isEntryScreen ? Routes.home : null;
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
