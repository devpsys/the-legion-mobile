import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/config/app_config.dart';
import 'package:the_legion_mobile/core/config/environment.dart';
import 'package:the_legion_mobile/core/di/injection.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/router/app_router.dart';
import 'package:the_legion_mobile/core/router/auth_guard.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_shell.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_tab_bar.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/in_memory_auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/bloc/password_recovery_cubit.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/bloc/password_recovery_state.dart';

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

    test('protects every portal screen from an anonymous user', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: false,
      );

      // Over the whole set, so a new portal section cannot be added as a deep
      // link that anyone can reach without signing in.
      for (final path in Routes.admissionsPaths) {
        expect(
          resolveRedirect(authGuard: guard, location: path),
          Routes.login,
          reason: '$path is inside the portal and must need a session',
        );
      }
    });

    test('keeps a signed-in visitor on every portal screen', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: true,
      );

      for (final path in Routes.admissionsPaths) {
        expect(resolveRedirect(authGuard: guard, location: path), isNull);
      }
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

    test('lets an anonymous visitor reach every recovery step', () {
      // Regression: the recovery flow redirected straight back to /login, so
      // tapping "Forgot password?" bounced the user out of the flow.
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: false,
      );

      for (final path in Routes.recoveryPaths) {
        expect(
          resolveRedirect(authGuard: guard, location: path),
          isNull,
          reason: '$path must be reachable while signed out',
        );
      }
    });

    test('bounces a signed-in visitor out of the recovery flow', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: true,
      );

      for (final path in Routes.recoveryPaths) {
        expect(
          resolveRedirect(authGuard: guard, location: path),
          Routes.home,
          reason: '$path is pointless once authenticated',
        );
      }
    });

    test('still bounces recovery deep links before the session resolves', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: false,
        isAuthenticated: false,
      );

      expect(
        resolveRedirect(authGuard: guard, location: Routes.forgotPassword),
        Routes.splash,
      );
    });
  });

  group('admissionsBackTarget', () {
    test('leaves the portal through its front door', () {
      expect(admissionsBackTarget(Routes.admissions), Routes.homeName);
    });

    test('unwinds the detail screen to the record it was opened from', () {
      expect(
        admissionsBackTarget(Routes.admissionsApplicationDetail('app-00057')),
        Routes.admissionsApplicationsName,
        reason: 'a step above the record must fall back one step, not two',
      );
    });

    test('keeps the record itself out of the detail branch', () {
      // The prefix test is written with a trailing slash precisely so this
      // location is not mistaken for a child of itself.
      expect(
        admissionsBackTarget(Routes.admissionsApplications),
        Routes.admissionsName,
      );
    });

    test('sends every other section back to the overview', () {
      expect(
        admissionsBackTarget(Routes.admissionsProgrammes),
        Routes.admissionsName,
      );
    });
  });

  group('cold start with the in-memory backend', () {
    late AuthCubit cubit;

    setUp(() {
      // `TheLegionApp` does this in `main()`; the pages under test resolve
      // their configuration from the same locator.
      sl.registerFactory<PasswordRecoveryCubit>(PasswordRecoveryCubit.new);
      sl.registerFactory<AdmissionsCubit>(AdmissionsCubit.new);
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
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(value: cubit),
            // The app provides the session's notification centre above the
            // router; the bells in both hubs read it.
            BlocProvider<NotificationCubit>.value(
              value: NotificationCubit(entries: NotificationFixtures.entries),
            ),
          ],
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

      // Redirected out of /login into the authenticated shell, which lands on
      // the student hub built from the session's user.
      expect(find.text('Pay your accommodation fee'), findsOneWidget);
      expect(
        find.textContaining(', Ada'),
        findsOneWidget,
        reason: 'greeting uses the session',
      );
      expect(find.text('300 Level · B.Sc. Computer Science'), findsOneWidget);

      // The session created by the fake backend reaches the profile tab.
      // Scoped to the shell's navigation chrome — a rail on wide viewports, a
      // bar on phones — because the hub's account panel also links to
      // "Profile".
      await tester.tap(
        find
            .descendant(
              of: find.byWidgetPredicate(
                (widget) => widget is NavigationRail || widget is NavigationBar,
              ),
              matching: find.text('Profile'),
            )
            .first,
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Ada Lovelace'), findsOneWidget);
      // Shown in the header and in the "Signed in as" card.
      expect(find.text('ada@the-legion.dev'), findsWidgets);
      expect(find.text('Sign out'), findsOneWidget);
    });

    /// Signs in through the UI and lands on the hub.
    Future<void> signInAndReachHub(WidgetTester tester) async {
      tester.view
        ..physicalSize = const Size(390, 844) * 2
        ..devicePixelRatio = 2;
      addTearDown(tester.view.reset);

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
    }

    testWidgets('leaving the admissions portal lands back on the hub', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      // Hub -> Admissions, the way the directory row leads there.
      await tester.ensureVisible(find.text('Admissions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Admissions'));
      await tester.pumpAndSettle();

      // The portal's own chrome, not the greeting: the greeting follows the
      // wall clock, so asserting it made this test fail every evening.
      expect(find.text('Your applications'), findsOneWidget);

      // The bar carries no back arrow: the system gesture is the way out.
      expect(find.byIcon(Icons.arrow_back), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Pay your accommodation fee'), findsOneWidget);
      expect(find.text('Your applications'), findsNothing);
    });

    testWidgets('the system back gesture leaves the portal for the hub', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      await tester.ensureVisible(find.text('Admissions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Admissions'));
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(
        find.text('Pay your accommodation fee'),
        findsOneWidget,
        reason: 'the portal is pushed on the hub, so back unwinds to it',
      );
    });

    testWidgets('the Programmes tab opens the browser and back returns here', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      await tester.ensureVisible(find.text('Admissions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Admissions'));
      await tester.pumpAndSettle();

      // Overview -> Programmes, through the portal's own tab bar.
      await tester.tap(find.text('Programmes'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Explore degree programmes and check your eligibility before applying.',
        ),
        findsOneWidget,
        reason: 'the browser, not the overview',
      );
      expect(find.text('B.Sc. Computer Science'), findsOneWidget);

      // Back unwinds to the overview rather than leaving the portal: the
      // candidate asked a question here and may have another.
      expect(find.byIcon(Icons.arrow_back), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Your applications'), findsOneWidget);
      expect(
        find.text(
          'Explore degree programmes and check your eligibility before applying.',
        ),
        findsNothing,
      );
    });

    testWidgets('the Overview tab comes back from the browser', (tester) async {
      await signInAndReachHub(tester);

      await tester.ensureVisible(find.text('Admissions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Admissions'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Programmes'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Explore degree programmes and check your eligibility before applying.',
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Overview'));
      await tester.pumpAndSettle();

      expect(find.text('Your applications'), findsOneWidget);
      expect(
        find.text(
          'Explore degree programmes and check your eligibility before applying.',
        ),
        findsNothing,
      );
    });

    testWidgets('the Applications tab opens the record and back returns here', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      await tester.ensureVisible(find.text('Admissions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Admissions'));
      await tester.pumpAndSettle();

      // Overview -> Applications, through the portal's own tab bar.
      await tester.tap(find.text('Applications'));
      await tester.pumpAndSettle();

      // The screen is named after the record, not after its section.
      expect(find.text('My applications'), findsOneWidget);
      expect(find.text('APP/2026/00042'), findsOneWidget);
      expect(find.text('Your applications'), findsNothing);

      // Back unwinds to the overview rather than leaving the portal.
      expect(find.byIcon(Icons.arrow_back), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Your applications'), findsOneWidget);
      expect(find.text('My applications'), findsNothing);
    });

    testWidgets('the draft opens its detail, and both ways back lead here', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      await tester.ensureVisible(find.text('Admissions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Admissions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Applications'));
      await tester.pumpAndSettle();

      // The draft, addressed by its reference: its title names two cards.
      await tester.ensureVisible(find.text('APP/2026/00057'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('APP/2026/00057'));
      await tester.pumpAndSettle();

      // Its own chrome — a checklist, the record's title gone, and no tab bar:
      // this is one file being read, not a section being visited.
      expect(find.text('Before you submit'), findsOneWidget);
      expect(find.text('3 of 9 complete'), findsOneWidget);
      expect(find.text('My applications'), findsNothing);
      expect(find.byType(AdmissionsTabBar), findsNothing);

      // The system gesture unwinds one step, to the record.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('My applications'), findsOneWidget);

      // ...and so does the chevron in the bar.
      await tester.ensureVisible(find.text('APP/2026/00057'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('APP/2026/00057'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      expect(find.text('My applications'), findsOneWidget);
      expect(find.text('Before you submit'), findsNothing);
    });

    testWidgets('the record leads on to the browser and to the hub', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      await tester.ensureVisible(find.text('Admissions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Admissions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Applications'));
      await tester.pumpAndSettle();

      // Applying is done by choosing a programme, so the CTA goes there.
      await tester.tap(find.text('New application'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Explore degree programmes and check your eligibility before applying.',
        ),
        findsOneWidget,
        reason: 'the browser, not a dead end',
      );

      // Back to the record, and out through the card that has somewhere to go.
      await tester.tap(find.text('Applications'));
      await tester.pumpAndSettle();
      expect(find.text('My applications'), findsOneWidget);

      await tester.ensureVisible(find.text('Open the student portal'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open the student portal'));
      await tester.pumpAndSettle();

      expect(
        find.text('Pay your accommodation fee'),
        findsOneWidget,
        reason: 'a matriculated candidate is a student now',
      );
    });

    /// Opens the Applications tab and the record filed under [reference].
    Future<void> openApplication(WidgetTester tester, String reference) async {
      await tester.ensureVisible(find.text('Admissions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Admissions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Applications'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text(reference));
      await tester.pumpAndSettle();
      await tester.tap(find.text(reference));
      await tester.pumpAndSettle();
    }

    testWidgets('a matriculation opens the student portal from its detail', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      await openApplication(tester, 'APP/2024/00377');
      expect(find.text("You're matriculated"), findsOneWidget);

      await tester.tap(find.text('Open the student portal'));
      await tester.pumpAndSettle();

      expect(
        find.text('Pay your accommodation fee'),
        findsOneWidget,
        reason: 'the student portal is the hub the candidate came from',
      );
    });

    testWidgets('a lapsed offer and a withdrawal both lead to the browser', (
      tester,
    ) async {
      await signInAndReachHub(tester);
      const browser =
          'Explore degree programmes and check your eligibility before applying.';

      await openApplication(tester, 'APP/2025/00611');
      expect(
        find.text('The offer of B.Sc. Law expired on 28 February 2026.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Browse programmes'));
      await tester.pumpAndSettle();
      expect(find.text(browser), findsOneWidget);

      await tester.tap(find.text('Applications'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('APP/2026/00733'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('APP/2026/00733'));
      await tester.pumpAndSettle();
      expect(find.text('Application withdrawn'), findsWidgets);

      await tester.tap(find.text('Start a new application'));
      await tester.pumpAndSettle();
      expect(find.text(browser), findsOneWidget);
    });

    testWidgets('a refusal leads back to the record, by gesture or by link', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      await openApplication(tester, 'APP/2025/00918');
      expect(
        find.text('Official admissions committee finding'),
        findsOneWidget,
      );
      expect(find.byType(AdmissionsTabBar), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('My applications'), findsOneWidget);

      await tester.ensureVisible(find.text('APP/2025/00918'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('APP/2025/00918'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Return to my applications'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Return to my applications'));
      await tester.pumpAndSettle();
      expect(find.text('My applications'), findsOneWidget);
    });

    testWidgets(
      '"Forgot password?" opens the recovery flow and steps through it',
      (tester) async {
        await pumpApp(tester);
        await tester.pump();
        await tester.pump();

        // Tapping the link must not bounce back to /login.
        await tester.tap(find.text('Forgot password?'));
        await tester.pumpAndSettle();

        expect(find.text('Reset your password'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'ada@the-legion.dev');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Send recovery code'));
        await tester.pumpAndSettle();

        // Step 2 keeps its state across the navigation inside the flow shell.
        expect(find.text('Verify your identity'), findsOneWidget);
        // The masked destination is composed of spans, so match rich text.
        // `ada@the-legion.dev` is shown as `a•••••a@the-legion.dev`.
        expect(
          find.textContaining('@the-legion.dev', findRichText: true),
          findsOneWidget,
        );

        // The sixth digit submits automatically, so no extra tap is needed.
        await tester.enterText(find.byType(TextField), RecoveryRules.demoCode);
        await tester.pumpAndSettle();

        expect(find.text('Reset Password'), findsOneWidget);

        // The set-password step is taller than the test viewport.
        await tester.ensureVisible(find.text('Update password'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).first, 'Legion2024!');
        await tester.enterText(find.byType(TextField).last, 'Legion2024!');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Update password'));
        await tester.pumpAndSettle();

        expect(find.text('Password updated successfully'), findsOneWidget);

        // Leaving the flow cancels it.
        await tester.tap(find.text('Sign in with new password'));
        await tester.pumpAndSettle();
        expect(find.text('Reset your password'), findsNothing);
      },
    );

    testWidgets('phones get no tab bar on the hub, but keep it on the profile', (
      tester,
    ) async {
      // Phone width: the shell shows a navigation bar rather than a rail, so
      // this is the only viewport where the bar exists to be hidden.
      tester.view
        ..physicalSize = const Size(390, 844) * 2
        ..devicePixelRatio = 2;
      addTearDown(tester.view.reset);

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

      // The hub owns the full canvas.
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('Pay your accommodation fee'), findsOneWidget);

      // Its own account panel is the way into the profile tab.
      await tester.ensureVisible(find.text('Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Ada Lovelace'), findsOneWidget);

      // ...and the profile tab keeps the bar, so neither branch is a dead end.
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(
        find.textContaining('Overview'),
        findsWidgets,
        reason: 'the bar can navigate back to the hub',
      );
    });
  });
}
