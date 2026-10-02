import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/config/app_config.dart';
import 'package:the_legion_mobile/core/config/environment.dart';
import 'package:the_legion_mobile/core/di/injection.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/router/app_router.dart';
import 'package:the_legion_mobile/core/router/auth_guard.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/in_memory_auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';

/// Minimal stand-in for the cubit so the redirect rules can be checked without
/// touching storage or the network.
class _FakeAuthGuard implements AuthGuard {
  _FakeAuthGuard({
    required this.isSessionResolved,
    required this.isAuthenticated,
  });

  @override
  bool isSessionResolved;
  @override
  bool isAuthenticated;
}

void main() {
  group('resolveRedirect', () {
    test('keeps the splash while the session is unresolved', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: false,
        isAuthenticated: false,
      );

      expect(
        resolveRedirect(authGuard: guard, location: Routes.splash),
        isNull,
      );
    });

    test(
      'bounces a deep link to the splash while the session is unresolved',
      () {
        final guard = _FakeAuthGuard(
          isSessionResolved: false,
          isAuthenticated: false,
        );

        expect(
          resolveRedirect(authGuard: guard, location: Routes.home),
          Routes.splash,
        );
        expect(
          resolveRedirect(authGuard: guard, location: Routes.profile),
          Routes.splash,
        );
      },
    );

    test(
      'leaves the splash for the login screen once resolved and anonymous',
      () {
        // Regression: the splash used to be treated as a public route, so a
        // resolved anonymous session stayed here forever.
        final guard = _FakeAuthGuard(
          isSessionResolved: true,
          isAuthenticated: false,
        );

        expect(
          resolveRedirect(authGuard: guard, location: Routes.splash),
          Routes.login,
        );
      },
    );

    test('keeps an anonymous user on the login screen', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: false,
      );

      expect(resolveRedirect(authGuard: guard, location: Routes.login), isNull);
    });

    test('protects app routes from an anonymous user', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: false,
      );

      expect(
        resolveRedirect(authGuard: guard, location: Routes.home),
        Routes.login,
      );
      expect(
        resolveRedirect(authGuard: guard, location: Routes.profile),
        Routes.login,
      );
    });

    test(
      'sends an authenticated user from the splash and login to the app',
      () {
        final guard = _FakeAuthGuard(
          isSessionResolved: true,
          isAuthenticated: true,
        );

        expect(
          resolveRedirect(authGuard: guard, location: Routes.splash),
          Routes.home,
        );
        expect(
          resolveRedirect(authGuard: guard, location: Routes.login),
          Routes.home,
        );
      },
    );

    test('leaves an authenticated user on app routes', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: true,
      );

      expect(resolveRedirect(authGuard: guard, location: Routes.home), isNull);
      expect(
        resolveRedirect(authGuard: guard, location: Routes.profile),
        isNull,
      );
    });
  });

  group('cold start with the in-memory backend', () {
    late AuthCubit cubit;

    setUp(() {
      // `TheLegionApp` does this in `main()`; the pages under test resolve
      // their configuration from the same locator.
      sl.registerSingleton<AppConfig>(
        const AppConfig(
          environment: Environment.development,
          apiBaseUrl: 'https://test.local',
          networkTimeout: Duration(seconds: 30),
          enableNetworkLogging: false,
          useFakeDataSources: true,
        ),
      );

      final repository = AuthRepositoryImpl(
        remote: FakeAuthRemoteDataSource(latency: Duration.zero),
        local: InMemoryAuthLocalDataSource(),
      );
      cubit = AuthCubit(
        login: LoginUseCase(repository),
        logout: LogoutUseCase(repository),
        restoreSession: RestoreSessionUseCase(repository),
      );
    });

    tearDown(() async {
      await cubit.close();
      await sl.reset();
    });

    Future<void> pumpApp(WidgetTester tester) async {
      final router = createRouter(
        authGuard: cubit,
        authStateChanges: cubit.stream,
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: cubit,
          child: MaterialApp.router(
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
    }

    testWidgets(
      'an anonymous session gets past the splash to the login screen',
      (tester) async {
        await pumpApp(tester);
        await tester.pump();
        await tester.pump();

        expect(find.text('Restoring your session'), findsNothing);
        // Credential deck and statutory notice from the sign-in design.
        expect(
          find.text('Use your institutional email and password.'),
          findsOneWidget,
        );
        expect(find.text('Statutory Audit Protocol'), findsOneWidget);
      },
    );

    testWidgets('signing in through the UI reaches the authenticated shell', (
      tester,
    ) async {
      await pumpApp(tester);
      await tester.pump();
      await tester.pump();

      await tester.enterText(
        find.byType(TextField).first,
        'ada@the-legion.dev',
      );
      await tester.enterText(
        find.byType(TextField).last,
        FakeAuthRemoteDataSource.defaultPassword,
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.pump();

      // Redirected out of /login into the authenticated shell.
      expect(find.widgetWithText(AppBar, 'Overview'), findsOneWidget);
      expect(find.text('Foundation is ready'), findsOneWidget);

      // The session created by the fake backend reaches the profile tab.
      await tester.tap(find.text('Profile'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Ada Lovelace'), findsOneWidget);
      // Shown in the header and in the "Signed in as" card.
      expect(find.text('ada@the-legion.dev'), findsWidgets);
      expect(find.text('Sign out'), findsOneWidget);
    });
  });
}
