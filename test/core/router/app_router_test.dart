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
import 'package:the_legion_mobile/features/accommodation/presentation/bloc/accommodation_cubit.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/bloc/staff/housing_cubit.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/widgets/accommodation_tab_bar.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/widgets/accommodation_task_bar.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admission_verification_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/jamb_claim_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/pages/jamb_claim_page.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admission_letter_document.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_shell.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_tab_bar.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_task_bar.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/in_memory_auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/register.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/registration_card.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_card_checkout_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_checkout_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_gateway_return_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_receipt_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fees_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/receipt_verification_cubit.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/bloc/password_recovery_cubit.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/bloc/password_recovery_state.dart';
import 'package:the_legion_mobile/features/registration/presentation/bloc/registration_cubit.dart';
import 'package:the_legion_mobile/features/registration/presentation/widgets/registration_tab_bar.dart';
import 'package:the_legion_mobile/features/registration/presentation/widgets/registration_task_bar.dart';

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
      for (final path in [
        ...Routes.admissionsPaths,
        ...Routes.registrationPaths,
        ...Routes.accommodationPaths,
      ]) {
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

      for (final path in [
        ...Routes.admissionsPaths,
        ...Routes.registrationPaths,
        ...Routes.accommodationPaths,
      ]) {
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

    test('lets an anonymous visitor open an applicant account', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: false,
      );

      expect(
        resolveRedirect(authGuard: guard, location: Routes.createAccount),
        isNull,
      );
    });

    test('bounces a signed-in visitor out of account creation', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: true,
      );

      expect(
        resolveRedirect(authGuard: guard, location: Routes.createAccount),
        Routes.home,
        reason: 'somebody with a session already has an account',
      );
    });

    test('lets anyone, signed in or not, verify an admission letter', () {
      // The person holding a letter is a landlord or an employer, who has no
      // account; and a student scanning their own letter has one.
      for (final isAuthenticated in [false, true]) {
        final guard = _FakeAuthGuard(
          isSessionResolved: true,
          isAuthenticated: isAuthenticated,
        );
        expect(
          resolveRedirect(authGuard: guard, location: Routes.verifyAdmission),
          isNull,
          reason:
              'verification must be public (authenticated: $isAuthenticated)',
        );
      }
    });

    test('holds verification at the splash until the session resolves', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: false,
        isAuthenticated: false,
      );

      expect(
        resolveRedirect(authGuard: guard, location: Routes.verifyAdmission),
        Routes.splash,
      );
    });

    test('protects the fees tab and the checkout from an anonymous user', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: false,
      );

      for (final path in [
        Routes.fees,
        Routes.feesCheckout,
        Routes.feesCardCheckout,
        Routes.feesGatewayReturn,
        Routes.feesReceipt('rec-098812'),
      ]) {
        expect(
          resolveRedirect(authGuard: guard, location: path),
          Routes.login,
          reason: '$path is inside the student shell and must need a session',
        );
      }
    });

    test('keeps a signed-in student on the fees tab and the checkout', () {
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: true,
      );

      for (final path in [
        Routes.fees,
        Routes.feesCheckout,
        Routes.feesCardCheckout,
        Routes.feesGatewayReturn,
        Routes.feesReceipt('rec-098812'),
      ]) {
        expect(resolveRedirect(authGuard: guard, location: path), isNull);
      }
    });

    test('leaves the public receipt and ID card checks alone for anyone', () {
      for (final authenticated in [false, true]) {
        final guard = _FakeAuthGuard(
          isSessionResolved: true,
          isAuthenticated: authenticated,
        );
        expect(
          resolveRedirect(authGuard: guard, location: Routes.verifyReceipt),
          isNull,
        );
        expect(
          resolveRedirect(authGuard: guard, location: Routes.verifyIdCard),
          isNull,
        );
      }
    });

    test('protects the admission letter itself from an anonymous user', () {
      // The letter carries the candidate's address: public verification shows
      // what the letter prints, the letter screen shows the letter.
      final guard = _FakeAuthGuard(
        isSessionResolved: true,
        isAuthenticated: false,
      );

      expect(
        resolveRedirect(
          authGuard: guard,
          location: Routes.admissionsAdmissionLetter('app-00042'),
        ),
        Routes.login,
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
      expect(
        admissionsBackTarget(Routes.admissionsJamb),
        Routes.admissionsName,
      );
    });

    test('unwinds the letter to the detail it was opened from', () {
      final location = Routes.admissionsAdmissionLetter('app-00042');

      expect(
        admissionsBackTarget(location),
        Routes.admissionsApplicationDetailName,
        reason: 'the letter is one step above the detail, not two',
      );
      expect(admissionsBackPathParameters(location), {'id': 'app-00042'});
    });

    test('passes no path parameters where back needs none', () {
      expect(
        admissionsBackPathParameters(
          Routes.admissionsApplicationDetail('app-00042'),
        ),
        isEmpty,
      );
      expect(admissionsBackPathParameters(Routes.admissions), isEmpty);
    });

    test('reads the record id out of a letter location, and only there', () {
      expect(
        admissionLetterApplicationId(
          Routes.admissionsAdmissionLetter('app-00042'),
        ),
        'app-00042',
      );
      expect(
        admissionLetterApplicationId(
          Routes.admissionsApplicationDetail('app-00042'),
        ),
        isNull,
      );
      expect(
        admissionLetterApplicationId(
          '${Routes.admissionsAdmissionLetter('app-00042')}/extra',
        ),
        isNull,
      );
    });
  });

  group('the fees routes', () {
    test('nest the checkout under the tab', () {
      expect(
        Routes.feesCheckout,
        '${Routes.fees}/${Routes.feesCheckoutSegment}',
      );
      expect(Routes.fees, startsWith('${Routes.home}/'));
    });

    test('carry the invoices to pay in the query, and read them back', () {
      expect(Routes.feesCheckoutInvoicesQuery(['a', 'b']), 'a,b');
      expect(Routes.feesCheckoutInvoicesQuery(const []), isEmpty);

      expect(Routes.feesCheckoutInvoicesFrom('a,b'), ['a', 'b']);
      expect(Routes.feesCheckoutInvoicesFrom(' a , ,b '), ['a', 'b']);
      expect(Routes.feesCheckoutInvoicesFrom(''), isEmpty);
      expect(Routes.feesCheckoutInvoicesFrom(null), isEmpty);
    });

    test(
      'give the hub and the payment tasks the whole canvas, and nothing else',
      () {
        expect(
          Routes.fullCanvasPaths,
          containsAll([
            Routes.home,
            Routes.feesCheckout,
            Routes.feesCardCheckout,
            Routes.feesGatewayReturn,
          ]),
        );
        expect(Routes.fullCanvasPaths, isNot(contains(Routes.fees)));
        expect(Routes.fullCanvasPaths, isNot(contains(Routes.profile)));
        expect(Routes.isFeesReceiptPath(Routes.feesReceipt('rec-1')), isTrue);
        expect(Routes.isFeesReceiptPath(Routes.fees), isFalse);
        expect(Routes.publicPaths, contains(Routes.verifyReceipt));
        expect(Routes.publicPaths, contains(Routes.verifyIdCard));
      },
    );
  });

  group('cold start with the in-memory backend', () {
    late AuthCubit cubit;

    setUp(() {
      // `TheLegionApp` does this in `main()`; the pages under test resolve
      // their configuration from the same locator.
      sl.registerFactory<PasswordRecoveryCubit>(PasswordRecoveryCubit.new);
      sl.registerFactory<AdmissionsCubit>(AdmissionsCubit.new);
      sl.registerFactory<JambClaimCubit>(JambClaimCubit.new);
      sl.registerFactory<RegistrationCubit>(RegistrationCubit.new);
      sl.registerFactory<AccommodationCubit>(AccommodationCubit.new);
      sl.registerFactory<HousingCubit>(HousingCubit.new);
      sl.registerFactory<FeesCubit>(FeesCubit.new);
      sl.registerFactory<FeeCheckoutCubit>(FeeCheckoutCubit.new);
      sl.registerFactory<FeeCardCheckoutCubit>(FeeCardCheckoutCubit.new);
      sl.registerFactory<FeeGatewayReturnCubit>(FeeGatewayReturnCubit.new);
      sl.registerFactory<FeeReceiptCubit>(FeeReceiptCubit.new);
      sl.registerFactory<ReceiptVerificationCubit>(
        ReceiptVerificationCubit.new,
      );
      sl.registerFactory<AdmissionVerificationCubit>(
        AdmissionVerificationCubit.new,
      );
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
        register: RegisterUseCase(repository),
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

    testWidgets(
      'the JAMB tab opens the claim under the portal\'s bar, and back is the overview',
      (tester) async {
        await signInAndReachHub(tester);

        await tester.ensureVisible(find.text('Admissions'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Admissions'));
        await tester.pumpAndSettle();

        // The fourth tab is live: the claim screen, under the same bar and
        // over the same tab bar as the other three.
        await tester.tap(find.text('JAMB'));
        await tester.pumpAndSettle();
        expect(find.text('Claim your JAMB result'), findsOneWidget);
        expect(find.byType(AdmissionsTaskBar), findsOneWidget);
        expect(find.text('2026/2027 Cycle'), findsOneWidget);
        expect(find.byType(AdmissionsTabBar), findsOneWidget);
        expect(find.text('You chose us in JAMB'), findsNothing);

        // The system gesture unwinds to the overview.
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.text('You chose us in JAMB'), findsOneWidget);

        // The overview's own claim card leads to the same screen.
        await tester.ensureVisible(find.text('Claim your result'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Claim your result'));
        await tester.pumpAndSettle();
        expect(find.text('Claim your JAMB result'), findsOneWidget);
      },
    );

    testWidgets(
      'claiming the result through the UI clears the claim everywhere',
      (tester) async {
        await signInAndReachHub(tester);

        await tester.ensureVisible(find.text('Admissions'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Admissions'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('JAMB'));
        await tester.pumpAndSettle();

        final fields = find.byType(TextField);
        await tester.enterText(fields.at(0), '202630112233AB');
        await tester.enterText(fields.at(1), 'Ibrahim');
        await tester.pumpAndSettle();

        // The birthday goes in through the picker's keyboard mode.
        await tester.ensureVisible(fields.at(2));
        await tester.pumpAndSettle();
        await tester.tap(fields.at(2));
        await tester.pumpAndSettle();
        expect(find.byType(DatePickerDialog), findsOneWidget);
        await tester.tap(find.byIcon(Icons.edit_outlined));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.descendant(
            of: find.byType(DatePickerDialog),
            matching: find.byType(TextField),
          ),
          '05/02/2008',
        );
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        expect(find.text('02 / 05 / 2008'), findsOneWidget);

        await tester.ensureVisible(find.text('Find my result'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Find my result'));
        await tester.pumpAndSettle();
        expect(find.text('Record found'), findsOneWidget);

        await tester.ensureVisible(find.text('Confirm and link result'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Confirm and link result'));
        await tester.pumpAndSettle();
        expect(find.text('Linked'), findsOneWidget);

        // After the pause the page moves on, by itself, to the draft the
        // result was linked to — where the checklist row is now ticked.
        await tester.pump(JambClaimPage.defaultLinkedPause);
        await tester.pumpAndSettle();
        expect(find.text('Before you submit'), findsOneWidget);
        expect(find.text('4 of 9 complete'), findsOneWidget);
        expect(find.textContaining('2026 UTME, aggregate 312'), findsOneWidget);
        expect(find.byType(AdmissionsTabBar), findsNothing);

        // Back from the detail is the record, as always.
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.text('My applications'), findsOneWidget);

        // The overview no longer asks: the card is gone and the tab unbadged.
        await tester.tap(find.text('Overview'));
        await tester.pumpAndSettle();
        expect(find.text('You chose us in JAMB'), findsNothing);
        final jambTab = tester.widget<AdmissionsTab>(
          find
              .ancestor(
                of: find.text('JAMB'),
                matching: find.byType(AdmissionsTab),
              )
              .first,
        );
        expect(jambTab.hasBadge, isFalse);

        // Coming back to the tab shows the record, not the form.
        await tester.tap(find.text('JAMB'));
        await tester.pumpAndSettle();
        expect(find.text('Linked'), findsOneWidget);
        expect(find.text('Find my result'), findsNothing);
      },
    );

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

    testWidgets('an offer opens its letter, and back returns to the offer', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      await openApplication(tester, 'APP/2026/00042');
      expect(find.text('Accept offer'), findsOneWidget);

      await tester.tap(find.text('Admission letter'));
      await tester.pumpAndSettle();

      expect(find.byType(AdmissionLetterDocument), findsOneWidget);
      expect(find.byType(AdmissionsTabBar), findsNothing);
      expect(
        find.text('OFFER OF PROVISIONAL ADMISSION: 2026/2027 SESSION'),
        findsOneWidget,
      );

      // The system gesture unwinds one step, to the detail — not to the list.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Accept offer'), findsOneWidget);
      expect(find.byType(AdmissionLetterDocument), findsNothing);

      // The second way in, below the deadline, leads to the same letter; the
      // bar's chevron is the way back.
      await tester.ensureVisible(find.text('Read the admission letter first'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Read the admission letter first'));
      await tester.pumpAndSettle();
      expect(find.byType(AdmissionLetterDocument), findsOneWidget);

      await tester.tap(find.byTooltip('Back to the application'));
      await tester.pumpAndSettle();
      expect(find.text('Accept offer'), findsOneWidget);
    });

    testWidgets('a matriculation leads to the letter that admitted it', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      await openApplication(tester, 'APP/2024/00377');
      await tester.ensureVisible(find.text('Download your admission letter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Download your admission letter'));
      await tester.pumpAndSettle();

      expect(find.byType(AdmissionLetterDocument), findsOneWidget);
      expect(
        find.text('OFFER OF PROVISIONAL ADMISSION: 2025/2026 SESSION'),
        findsOneWidget,
      );
    });

    testWidgets('the sign-in screen leads to public verification and back', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(390, 844) * 2
        ..devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      await pumpApp(tester);
      await tester.pump();
      await tester.pump();

      await tester.ensureVisible(find.text('Verify an admission letter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Verify an admission letter'));
      await tester.pumpAndSettle();

      // Public: reached without a session, and without the app's chrome.
      expect(find.text('Verify an admission'), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);

      await tester.enterText(find.byType(TextField), '7kq2 m9xw 4hpa');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Verify'));
      await tester.pumpAndSettle();
      expect(find.text('Genuine admission'), findsOneWidget);

      await tester.ensureVisible(find.text('Sign in to the portal'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign in to the portal'));
      await tester.pumpAndSettle();
      expect(find.text('Verify an admission letter'), findsOneWidget);
    });

    testWidgets('the sign-in screen leads to account creation and back', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(390, 844) * 2
        ..devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      await pumpApp(tester);
      await tester.pump();
      await tester.pump();

      await tester.ensureVisible(find.text('Create an applicant account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create an applicant account'));
      await tester.pumpAndSettle();

      expect(find.byType(RegistrationCard), findsOneWidget);
      expect(find.text('Create account'), findsOneWidget);

      // Both ways back lead to sign-in: the chevron and the link.
      await tester.tap(find.byTooltip('Back to sign in'));
      await tester.pumpAndSettle();
      expect(find.byType(RegistrationCard), findsNothing);
      expect(find.text('Forgot password?'), findsOneWidget);

      await tester.ensureVisible(find.text('Create an applicant account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create an applicant account'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sign in'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.byType(RegistrationCard), findsNothing);
      expect(find.text('Forgot password?'), findsOneWidget);
    });

    testWidgets('the system back gesture leaves account creation for sign-in', (
      tester,
    ) async {
      await pumpApp(tester);
      await tester.pump();
      await tester.pump();

      await tester.ensureVisible(find.text('Create an applicant account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create an applicant account'));
      await tester.pumpAndSettle();
      expect(find.byType(RegistrationCard), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(RegistrationCard), findsNothing);
      expect(find.text('Forgot password?'), findsOneWidget);
    });

    testWidgets('a new applicant is signed in and lands on the hub', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(390, 1600) * 2
        ..devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      await pumpApp(tester);
      await tester.pump();
      await tester.pump();

      await tester.ensureVisible(find.text('Create an applicant account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create an applicant account'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Oluwaseun');
      await tester.enterText(fields.at(1), 'Adeyemi');
      await tester.enterText(fields.at(3), 'seun@example.com');
      await tester.enterText(fields.at(5), 'legion123');
      await tester.enterText(fields.at(6), 'legion123');
      await tester.ensureVisible(find.text('Create account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(cubit.state.isAuthenticated, isTrue);
      expect(find.byType(RegistrationCard), findsNothing);
      expect(
        find.text('Pay your accommodation fee'),
        findsOneWidget,
        reason: 'success is a session, and the redirect takes it to the hub',
      );
    });

    testWidgets('the system back gesture leaves verification for sign-in', (
      tester,
    ) async {
      await pumpApp(tester);
      await tester.pump();
      await tester.pump();

      await tester.ensureVisible(find.text('Verify an admission letter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Verify an admission letter'));
      await tester.pumpAndSettle();
      expect(find.text('Verify an admission'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Verify an admission'), findsNothing);
      expect(find.text('Verify an admission letter'), findsOneWidget);
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

    /// The shell's own tab bar, as opposed to a label elsewhere on the page.
    Finder tabBarText(String label) => find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(label),
    );

    testWidgets(
      'the directory opens Registration & Records under its own tab bar',
      (tester) async {
        await signInAndReachHub(tester);

        await tester.ensureVisible(find.text('Registration & Records'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Registration & Records'));
        await tester.pumpAndSettle();

        expect(find.text('Course registration'), findsWidgets);
        expect(find.byType(RegistrationTaskBar), findsOneWidget);
        expect(find.byType(RegistrationTabBar), findsOneWidget);
        expect(find.text('Amaka Bello'), findsOneWidget);

        await tester.tap(find.text('Study plan'));
        await tester.pumpAndSettle();
        expect(find.text('UNDERGRADUATE DEGREE'), findsOneWidget);

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.text('Course registration'), findsWidgets);

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.text('Registration & Records'), findsOneWidget);
      },
    );

    testWidgets(
      'the directory opens Accommodation, and back unwinds through its hub',
      (tester) async {
        await signInAndReachHub(tester);

        await tester.ensureVisible(find.text('Accommodation'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Accommodation'));
        await tester.pumpAndSettle();

        expect(find.byType(AccommodationTaskBar), findsOneWidget);
        expect(find.byType(AccommodationTabBar), findsOneWidget);
        expect(find.text('Amina Hall · Block A'), findsWidgets);

        await tester.tap(find.text('History'));
        await tester.pumpAndSettle();
        expect(
          find.textContaining('Use this record for clearance'),
          findsOneWidget,
        );

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.byType(AccommodationTabBar), findsOneWidget);
        expect(
          find.textContaining('Use this record for clearance'),
          findsNothing,
        );

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.byType(AccommodationTaskBar), findsNothing);
      },
    );

    testWidgets('the directory opens the fees tab, and the checkout owns the '
        'canvas above it', (tester) async {
      await signInAndReachHub(tester);

      // Hub -> Fees, the way the directory row leads there.
      await tester.ensureVisible(find.text('Fees & Payments'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fees & Payments'));
      await tester.pumpAndSettle();

      // A tab of the shell: the bar is there, with Fees selected.
      expect(find.text('Student fees'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(tabBarText('Fees'), findsOneWidget);
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        1,
      );

      // Fees -> checkout, through the hero. A task: no tab bar under it.
      await tester.ensureVisible(find.text('Pay outstanding (₦66,000.00)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pay outstanding (₦66,000.00)'));
      await tester.pumpAndSettle();

      expect(find.text('Make payment'), findsOneWidget);
      expect(find.text('Proceed to pay ₦66,350.00'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('Student fees'), findsNothing);

      // The system gesture unwinds one step, to the tab...
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Student fees'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Make payment'), findsNothing);

      // ...and one more to the hub.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Pay your accommodation fee'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('a card pays its own invoice, and the chevron comes back', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      await tester.ensureVisible(find.text('Fees & Payments'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fees & Payments'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Pay ₦16,000.00'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pay ₦16,000.00'));
      await tester.pumpAndSettle();

      // Only the levy is on the till.
      expect(find.text('INV-2026-09104'), findsOneWidget);
      expect(find.text('INV-2026-08821'), findsNothing);
      expect(find.text('Proceed to pay ₦16,350.00'), findsOneWidget);

      await tester.tap(find.byTooltip('Back to your fees'));
      await tester.pumpAndSettle();
      expect(find.text('Student fees'), findsOneWidget);
    });

    testWidgets(
      'Proceed opens card checkout; Pay opens awaiting confirmation',
      (tester) async {
        await signInAndReachHub(tester);

        await tester.ensureVisible(find.text('Fees & Payments'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Fees & Payments'));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('Pay outstanding (₦66,000.00)'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Pay outstanding (₦66,000.00)'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Proceed to pay ₦66,350.00'));
        await tester.pumpAndSettle();
        expect(find.text('Card checkout'), findsOneWidget);
        expect(find.byType(NavigationBar), findsNothing);

        final fields = find.byType(TextField);
        await tester.enterText(fields.at(0), '5399123456784012');
        await tester.enterText(fields.at(1), '1228');
        await tester.enterText(fields.at(2), '123');
        await tester.enterText(fields.at(3), '1234');
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('Pay ₦66,350.00'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Pay ₦66,350.00'));
        await tester.pumpAndSettle();

        expect(find.text('AWAITING CONFIRMATION'), findsOneWidget);
        expect(find.text('Payment successful'), findsNothing);
        expect(find.textContaining('You can close this page.'), findsWidgets);
      },
    );

    testWidgets('the fees tab and the profile tab reach each other through '
        'the bar', (tester) async {
      await signInAndReachHub(tester);

      await tester.ensureVisible(find.text('Fees & Payments'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fees & Payments'));
      await tester.pumpAndSettle();

      await tester.tap(tabBarText('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Ada Lovelace'), findsOneWidget);

      await tester.tap(tabBarText('Fees'));
      await tester.pumpAndSettle();
      expect(find.text('Student fees'), findsOneWidget);

      // The bar's own back to the hub.
      await tester.tap(find.byTooltip('Back to the hub'));
      await tester.pumpAndSettle();
      expect(find.text('Pay your accommodation fee'), findsOneWidget);
    });

    testWidgets('the account panel\'s Payments shortcut opens the fees tab', (
      tester,
    ) async {
      await signInAndReachHub(tester);

      await tester.ensureVisible(find.text('Payments'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Payments'));
      await tester.pumpAndSettle();

      expect(find.text('Student fees'), findsOneWidget);
    });

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
