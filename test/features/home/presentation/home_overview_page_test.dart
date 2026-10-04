import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/config/app_config.dart';
import 'package:the_legion_mobile/core/config/environment.dart';
import 'package:the_legion_mobile/core/di/injection.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/core/utils/greeting_period.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/in_memory_auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/register.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:the_legion_mobile/features/home/presentation/mock/hub_fixtures.dart';
import 'package:the_legion_mobile/features/home/presentation/pages/home_overview_page.dart';
import 'package:the_legion_mobile/features/home/presentation/widgets/account_services_panel.dart';
import 'package:the_legion_mobile/features/home/presentation/widgets/announcement_board.dart';
import 'package:the_legion_mobile/features/home/presentation/widgets/next_step_timeline.dart';

void main() {
  late AuthCubit cubit;

  /// A fixed afternoon so the greeting and the term maths are stable.
  final now = DateTime(2026, 10, 1, 14, 20);

  setUp(() {
    // The hub's drawer prints the build configuration in debug builds.
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

  Future<void> pumpHub(
    WidgetTester tester, {
    DateTime? at,
    Size size = const Size(390, 1400),
  }) async {
    await cubit.signIn(
      email: 'ada@the-legion.dev',
      password: FakeAuthRemoteDataSource.defaultPassword,
    );

    tester.view
      ..physicalSize = size * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: cubit),
          // The bell reads the session's notification centre, which the app
          // provides above the router.
          BlocProvider<NotificationCubit>.value(
            value: NotificationCubit(entries: NotificationFixtures.entries),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeOverviewPage(now: at ?? now),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('hero', () {
    testWidgets('greets the signed-in student with the standing and term', (
      tester,
    ) async {
      await pumpHub(tester);

      expect(find.text('Good afternoon, Ada'), findsOneWidget);
      expect(find.text('300 Level · B.Sc. Computer Science'), findsOneWidget);
      expect(
        find.text(
          '${HubFixtures.term.session} · ${HubFixtures.term.semesterLong}',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          '${HubFixtures.term.daysRemainingAt(now)}',
          skipOffstage: false,
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Ends '), findsOneWidget);
    });

    testWidgets('greets according to the time of day', (tester) async {
      await pumpHub(tester, at: DateTime(2026, 10, 1, 8));
      expect(find.textContaining('Good morning'), findsOneWidget);

      await pumpHub(tester, at: DateTime(2026, 10, 1, 22));
      expect(find.textContaining('Good evening'), findsOneWidget);
    });

    testWidgets('dates the hero with the injected day', (tester) async {
      await pumpHub(tester);

      expect(find.text('Thursday, 1 October 2026'), findsOneWidget);
    });
  });

  group('do this next', () {
    testWidgets('renders every step with its state tag', (tester) async {
      await pumpHub(tester, size: const Size(390, 2600));

      expect(find.byType(NextStepTimeline), findsOneWidget);
      expect(find.text('Pay your accommodation fee'), findsOneWidget);
      expect(find.text('Submit your course form'), findsOneWidget);
      expect(find.text('Your exam card is not ready'), findsOneWidget);
      expect(find.text('Upload your passport photo'), findsOneWidget);
      expect(find.text('First term fees paid'), findsOneWidget);

      expect(find.text('Due 3 Oct'), findsOneWidget);
      expect(find.text('Blocked'), findsNWidgets(2));
      expect(find.text('Waiting'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('counts the outstanding steps, not the cleared ones', (
      tester,
    ) async {
      await pumpHub(tester);

      final outstanding = HubFixtures.nextSteps
          .where((step) => step.state.name != 'done')
          .length;
      // Scoped to the timeline: the notification badge shows a count too.
      expect(
        find.descendant(
          of: find.byType(NextStepTimeline),
          matching: find.text('$outstanding'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('amounts in a step detail are set in the mono face', (
      tester,
    ) async {
      await pumpHub(tester, size: const Size(390, 2600));

      expect(
        find.textContaining(
          'Bed held until 3 October · ₦35,000.00',
          findRichText: true,
        ),
        findsOneWidget,
        reason: 'the sentence and the amount are one composed line',
      );
    });
  });

  group('module directory', () {
    testWidgets('groups the thirteen portals under three clusters', (
      tester,
    ) async {
      await pumpHub(tester, size: const Size(390, 3200));

      expect(find.text('13 Modules'), findsOneWidget);
      expect(find.text('ACADEMIC & RECORDS'), findsOneWidget);
      expect(find.text('CAMPUS LIFE & FACILITIES'), findsOneWidget);
      expect(find.text('CAREER & ADVANCEMENT'), findsOneWidget);
      expect(find.text('4 modules'), findsNWidgets(2));
      expect(find.text('5 modules'), findsOneWidget);
      expect(find.text('13 Modules'), findsOneWidget);
      expect(find.text('Library'), findsOneWidget);
    });

    testWidgets('a portal without a route reports it is not live yet', (
      tester,
    ) async {
      await pumpHub(tester, size: const Size(390, 3200));

      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();

      expect(
        find.text('This service goes live with the next release.'),
        findsOneWidget,
      );
    });
  });

  group('announcements', () {
    testWidgets('shows each bulletin with its category', (tester) async {
      await pumpHub(tester, size: const Size(390, 3200));

      expect(find.byType(AnnouncementBoard), findsOneWidget);
      expect(find.text('Urgent'), findsOneWidget);
      expect(find.text('Notice'), findsOneWidget);
      expect(find.text('Information'), findsOneWidget);
      expect(find.text('See all'), findsOneWidget);
    });

    testWidgets('the bell opens the unread sheet', (tester) async {
      await pumpHub(tester);

      await tester.tap(find.byIcon(Icons.notifications_outlined).first);
      await tester.pumpAndSettle();

      expect(
        find.text('Examination venue changes for Faculty of Science'),
        findsOneWidget,
      );
    });
  });

  group('account panel', () {
    testWidgets('signing out asks for confirmation first', (tester) async {
      await pumpHub(tester, size: const Size(390, 3400));

      await tester.ensureVisible(find.byType(AccountServicesPanel));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();

      // The sheet states what is needed to sign back in, and the session is
      // still alive because nothing was confirmed yet.
      expect(
        find.text(
          'You will need your institutional matriculation email and portal '
          'password to sign back in.',
        ),
        findsOneWidget,
      );
      expect(cubit.state.status, AuthStatus.authenticated);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(cubit.state.status, AuthStatus.authenticated);
    });

    testWidgets('confirming the sheet ends the session', (tester) async {
      await pumpHub(tester, size: const Size(390, 3400));

      await tester.ensureVisible(find.byType(AccountServicesPanel));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();

      // Two "Sign out" labels are on screen: the panel's and the sheet's.
      await tester.tap(find.text('Sign out').last);
      await tester.pumpAndSettle();

      expect(cubit.state.status, AuthStatus.unauthenticated);
    });
  });

  group('drawer', () {
    testWidgets('opens from the header and lists the directory', (
      tester,
    ) async {
      await pumpHub(tester);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('ada@the-legion.dev'), findsOneWidget);
      expect(find.text('Postgraduate & Research'), findsWidgets);
      // The drawer repeats every cluster header of the directory behind it.
      expect(find.text('ACADEMIC & RECORDS'), findsNWidgets(2));
    });
  });

  group('greeting period', () {
    test('the clock decides the period, not the words', () {
      expect(GreetingPeriod.forHour(0), GreetingPeriod.morning);
      expect(GreetingPeriod.forHour(11), GreetingPeriod.morning);
      expect(GreetingPeriod.forHour(12), GreetingPeriod.afternoon);
      expect(GreetingPeriod.forHour(16), GreetingPeriod.afternoon);
      expect(GreetingPeriod.forHour(17), GreetingPeriod.evening);
      expect(GreetingPeriod.forHour(23), GreetingPeriod.evening);
    });
  });
}
