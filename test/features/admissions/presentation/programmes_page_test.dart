import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/core/utils/responsive.dart';
import 'package:the_legion_mobile/core/widgets/state_views.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/admissions_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/programme_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/admissions_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/programme_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/pages/programmes_page.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_tab_bar.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/cycle_notice.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/cycle_picker_sheet.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/faculty_filter_chips.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/programme_card.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/programme_card_actions.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/programme_deadline_notice.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';

import '../../../helpers/signed_in_auth_cubit.dart';

void main() {
  late AdmissionsCubit cubit;
  late AuthCubit auth;

  /// 4 February 2027 — the day the Programmes design was drawn on, which is what
  /// makes English read "closes in 10 days" rather than "admissions active".
  final designDay = DateTime(2027, 2, 4);

  setUp(() async {
    cubit = AdmissionsCubit();
    auth = await signedInAuthCubit();
  });
  tearDown(() async {
    await cubit.close();
    await auth.close();
  });

  /// The portal's providers around [child], as the app arranges them.
  Widget portal(Widget child) => MultiBlocProvider(
    providers: [
      BlocProvider<AdmissionsCubit>.value(value: cubit),
      BlocProvider<AuthCubit>.value(value: auth),
      // The bell reads the session's notification centre, which the app
      // provides above the router.
      BlocProvider<NotificationCubit>.value(
        value: NotificationCubit(entries: NotificationFixtures.entries),
      ),
    ],
    child: child,
  );

  void setViewport(WidgetTester tester, Size size) {
    tester.view
      ..physicalSize = size * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  Future<void> pumpBrowser(
    WidgetTester tester, {
    DateTime? at,
    Size size = const Size(390, 2400),
    bool dark = false,
  }) async {
    setViewport(tester, size);

    await tester.pumpWidget(
      portal(
        MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProgrammesPage(now: at ?? designDay),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The browser under a router with two stops: itself, and a stand-in for
  /// the application detail that "Apply" is expected to leave for.
  Future<void> pumpBrowserWithRouter(WidgetTester tester) async {
    setViewport(tester, const Size(390, 2400));

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => ProgrammesPage(now: designDay),
        ),
        GoRoute(
          path: Routes.admissionsApplicationDetailTemplate,
          name: Routes.admissionsApplicationDetailName,
          builder: (_, state) => Text('detail:${state.pathParameters['id']}'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      portal(
        MaterialApp.router(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Loads the portal and takes every application off the record, for the
  /// cards a candidate with nothing live sees.
  void clearRecord() {
    cubit.load();
    cubit.emit(cubit.state.copyWith(applications: const []));
  }

  /// Everything inside the card titled [title].
  Finder cardOf(String title) =>
      find.ancestor(of: find.text(title), matching: find.byType(ProgrammeCard));

  Finder inCard(String title, String text) =>
      find.descendant(of: cardOf(title), matching: find.text(text));

  /// Scrolls the filter strip until [label] is built.
  ///
  /// The strip is a lazy horizontal list, so a chip past the fold does not
  /// exist until it is scrolled to — which is also how a candidate reaches it.
  Future<void> scrollChipsUntilVisible(
    WidgetTester tester,
    String label,
  ) async {
    for (var attempt = 0; attempt < 8; attempt++) {
      if (find.text(label).evaluate().isNotEmpty) return;
      await tester.drag(
        find.byType(FacultyFilterChips),
        const Offset(-120, 0),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
    }
  }

  group('chrome', () {
    testWidgets('titles the browser and counts the catalogue', (tester) async {
      await pumpBrowser(tester);

      expect(
        find.text('Programmes'),
        findsNWidgets(2),
        reason: 'title and tab',
      );
      expect(find.text('5 available'), findsOneWidget);
      expect(find.text('All faculties (5)'), findsOneWidget);
    });

    testWidgets('keeps Programmes selected in the portal tab bar', (
      tester,
    ) async {
      await pumpBrowser(tester);

      final tabBar = tester.widget<AdmissionsTabBar>(
        find.byType(AdmissionsTabBar),
      );
      expect(tabBar.selectedIndex, 1);
    });

    testWidgets('shares the bell and the count with the rest of the portal', (
      tester,
    ) async {
      await pumpBrowser(tester);

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(
        find.text('${NotificationFixtures.entries.length}'),
        findsOneWidget,
        reason: 'one centre, so the badge matches the overview exactly',
      );
    });
  });

  group('the cycle notice', () {
    testWidgets('names the cycle, its deadline and its fee', (tester) async {
      await pumpBrowser(tester);

      expect(find.byType(CycleNotice), findsOneWidget);
      expect(find.text('2026/2027 Undergraduate Admissions'), findsOneWidget);
      expect(find.text('Closes 28 Feb 2027'), findsOneWidget);
      expect(
        find.text('₦7,500.00'),
        findsNWidgets(4),
        reason:
            'the cycle fee plus the three programmes priced at it; the '
            'diploma and English quote their own',
      );
    });

    testWidgets('switching cycles changes the quoted deadline', (tester) async {
      await pumpBrowser(tester);

      await tester.tap(find.text('Switch cycle'));
      await tester.pumpAndSettle();

      expect(find.byType(CyclePickerSheet), findsOneWidget);
      expect(find.text('2026/2027 Postgraduate Admissions'), findsOneWidget);

      await tester.tap(find.text('2026/2027 Postgraduate Admissions'));
      await tester.pumpAndSettle();

      expect(find.byType(CyclePickerSheet), findsNothing);
      expect(
        find.text('Closed 31 Jan 2027'),
        findsOneWidget,
        reason:
            'the postgraduate cycle had already closed on 31 January, so the '
            'notice says so rather than quoting a deadline in the past',
      );
      expect(
        find.text('₦1,250.00'),
        findsOneWidget,
        reason: 'the postgraduate form fee replaces the undergraduate one',
      );
    });

    testWidgets('dismissing the sheet changes nothing', (tester) async {
      await pumpBrowser(tester);

      await tester.tap(find.text('Switch cycle'));
      await tester.pumpAndSettle();

      // The barrier is the way out that is always available.
      await tester.tapAt(const Offset(195, 20));
      await tester.pumpAndSettle();

      expect(find.byType(CyclePickerSheet), findsNothing);
      expect(find.text('2026/2027 Undergraduate Admissions'), findsOneWidget);
    });
  });

  group('layout', () {
    for (final width in [320.0, 390.0, 430.0, 768.0, 1280.0]) {
      testWidgets('fits a $width px viewport without overflowing', (
        tester,
      ) async {
        // 320px is the narrowest phone the app claims to support; 1280 is a
        // desktop window, where the canvas is centred rather than full width.
        await pumpBrowser(tester, size: Size(width, 2400));

        expect(
          tester.takeException(),
          isNull,
          reason: 'an overflow here is one a candidate would see',
        );
      });
    }
  });

  group('layout', () {
    testWidgets('renders in dark mode too', (tester) async {
      await pumpBrowser(tester, dark: true);

      expect(tester.takeException(), isNull);
      expect(find.byType(ProgrammeCard), findsNWidgets(5));
    });
  });

  group('filtering', () {
    testWidgets('narrows the list to the chosen faculty', (tester) async {
      await pumpBrowser(tester);

      await tester.tap(find.text('Arts (1)'));
      await tester.pumpAndSettle();

      expect(find.byType(ProgrammeCard), findsOneWidget);
      expect(find.text('B.A. English'), findsOneWidget);
      expect(find.text('1 available'), findsOneWidget);
    });

    testWidgets('shows every faculty, including the empty one', (tester) async {
      await pumpBrowser(tester);

      // Built lazily as the strip scrolls, so each is checked when it is
      // reachable rather than all at once.
      for (final chip in [
        'All faculties (5)',
        'Science (2)',
        'Arts (1)',
        'Law (2)',
        'Engineering (0)',
      ]) {
        await scrollChipsUntilVisible(tester, chip);
        expect(
          find.text(chip),
          findsOneWidget,
          reason: 'a filter that disappears is a filter nobody trusts',
        );
      }
    });

    testWidgets('an empty faculty is shown but cannot be chosen', (
      tester,
    ) async {
      await pumpBrowser(tester);
      await scrollChipsUntilVisible(tester, 'Engineering (0)');

      await tester.tap(find.text('Engineering (0)'));
      await tester.pumpAndSettle();

      expect(
        find.byType(ProgrammeCard),
        findsNWidgets(5),
        reason: 'a disabled chip must not silently clear the list',
      );
    });

    testWidgets('searches by course code as well as by name', (tester) async {
      await pumpBrowser(tester);

      await tester.enterText(find.byType(TextField), 'csc');
      await tester.pumpAndSettle();

      expect(find.byType(ProgrammeCard), findsOneWidget);
      expect(find.text('B.Sc. Computer Science'), findsOneWidget);
      expect(find.text('1 available'), findsOneWidget);
    });

    testWidgets('says why the list is empty, naming the query', (tester) async {
      await pumpBrowser(tester);

      await tester.enterText(find.byType(TextField), 'nursing');
      await tester.pumpAndSettle();

      expect(find.byType(ProgrammeCard), findsNothing);
      expect(find.byType(EmptyView), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(EmptyView),
          matching: find.textContaining('nursing'),
        ),
        findsOneWidget,
        reason: 'the message has to point at the control to undo',
      );
    });

    testWidgets('the count in the header agrees with the list', (tester) async {
      await pumpBrowser(tester);

      await tester.tap(find.text('Science (2)'));
      await tester.pumpAndSettle();

      expect(find.text('2 available'), findsOneWidget);
      expect(find.byType(ProgrammeCard), findsNWidgets(2));
    });
  });

  group('the three evaluation states', () {
    testWidgets('an eligible programme is green and offers an application', (
      tester,
    ) async {
      await pumpBrowser(tester);

      expect(find.text('You meet the requirements'), findsOneWidget);
      expect(
        find.textContaining('UTME cutoff met — 312 against a cutoff of 200 ✓'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Verified eligible'), findsNothing);
    });

    testWidgets('an unverified requirement is amber, not a failure', (
      tester,
    ) async {
      await pumpBrowser(tester);

      expect(find.text('Some requirements need checking'), findsNWidgets(3));
      expect(find.byIcon(Icons.warning), findsNWidgets(3));
      expect(
        find.textContaining("You don't yet meet"),
        findsNothing,
        reason: 'the bursary module is missing; nobody has refused anything',
      );
      expect(
        inCard('Diploma in Law', 'Apply'),
        findsOneWidget,
        reason:
            'an unverified requirement still allows an application — the '
            'README says so, and the diploma has one',
      );
    });

    testWidgets('the closed programme says so and cannot be applied to', (
      tester,
    ) async {
      await pumpBrowser(tester);

      expect(find.text('Applications have closed'), findsOneWidget);
      expect(find.text('Archived session'), findsOneWidget);
      expect(inCard('B.Sc. Law', 'View details'), findsOneWidget);
      expect(inCard('B.Sc. Law', 'Apply'), findsNothing);
      expect(find.text('Closed on 31 Jan 2027'), findsOneWidget);
    });
  });

  group('whether a card offers to apply', () {
    testWidgets('only where the candidate has nothing live in the category', (
      tester,
    ) async {
      await pumpBrowser(tester);

      // The record holds an undergraduate offer and an undergraduate draft
      // for this session, so every undergraduate card is spoken for and says
      // so; the diploma is the one card that still offers an application.
      expect(find.text('Apply'), findsOneWidget);
      expect(inCard('Diploma in Law', 'Apply'), findsOneWidget);
      expect(find.text('Already applied this cycle'), findsNWidgets(3));
      for (final title in [
        'B.Sc. Computer Science',
        'B.Sc. Accounting',
        'B.A. English',
      ]) {
        expect(inCard(title, 'Already applied this cycle'), findsOneWidget);
        expect(inCard(title, 'View details'), findsOneWidget);
      }
      expect(
        inCard('B.Sc. Law', 'Already applied this cycle'),
        findsNothing,
        reason: 'closed is closed for everybody; it outranks the record',
      );
    });

    testWidgets('on every open card once nothing live is on the record', (
      tester,
    ) async {
      clearRecord();
      await pumpBrowser(tester);

      expect(find.text('Apply'), findsNWidgets(4));
      expect(find.text('Already applied this cycle'), findsNothing);
      expect(
        find.text('View details'),
        findsOneWidget,
        reason: 'Law alone, because it is closed',
      );
    });

    testWidgets('a settled application does not count against the candidate', (
      tester,
    ) async {
      cubit.load();
      cubit.emit(
        cubit.state.copyWith(
          applications: [
            AdmissionsFixtures.withdrawnApplication,
            AdmissionsFixtures.rejectedApplication,
            AdmissionsFixtures.expiredApplication,
            AdmissionsFixtures.matriculatedApplication,
          ],
        ),
      );
      await pumpBrowser(tester);

      expect(find.text('Apply'), findsNWidgets(4));
      expect(find.text('Already applied this cycle'), findsNothing);
    });

    testWidgets('a live application in another session does not count', (
      tester,
    ) async {
      cubit.load();
      cubit.emit(
        cubit.state.copyWith(
          applications: [
            ApplicationSummary(
              id: 'app-00900',
              programmeName: 'B.Sc. Accounting',
              department: 'Department of Accounting',
              category: ProgrammeCategory.undergraduate,
              status: ApplicationStatus.offered,
              submittedOn: DateTime(2025, 9),
              updatedOn: DateTime(2026, 1),
              cycleName: '2025/2026 Undergraduate Admissions',
              cycleSession: '2025/2026',
            ),
          ],
        ),
      );
      await pumpBrowser(tester);

      expect(find.text('Apply'), findsNWidgets(4));
    });

    testWidgets('not under a cycle that has closed', (tester) async {
      await pumpBrowser(tester);

      // The postgraduate cycle shut on 31 January.
      await tester.tap(find.text('Switch cycle'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2026/2027 Postgraduate Admissions'));
      await tester.pumpAndSettle();

      expect(find.text('Closed 31 Jan 2027'), findsOneWidget);
      expect(find.text('Apply'), findsNothing);
    });

    testWidgets('not once the window has passed', (tester) async {
      clearRecord();
      // 1 March 2027: the undergraduate cycle closed the night before.
      await pumpBrowser(tester, at: DateTime(2027, 3));

      expect(find.text('Apply'), findsNothing);
      expect(find.text('View details'), findsNWidgets(5));
    });

    testWidgets(
      'not for a programme whose own deadline has passed inside the cycle',
      (tester) async {
        clearRecord();
        // 20 February: English closed on the 14th, the cycle runs to the 28th.
        await pumpBrowser(tester, at: DateTime(2027, 2, 20));

        expect(inCard('B.A. English', 'Apply'), findsNothing);
        expect(inCard('B.A. English', 'View details'), findsOneWidget);
        expect(inCard('B.Sc. Computer Science', 'Apply'), findsOneWidget);
      },
    );
  });

  group('deadlines on the cards', () {
    testWidgets('warns when a programme closes before the cycle', (
      tester,
    ) async {
      await pumpBrowser(tester);

      expect(
        find.byType(ProgrammeDeadlineNotice),
        findsOneWidget,
        reason:
            'only English closes before the cycle; Law closed before it and '
            'already carries a "Closed on" tag',
      );
      expect(
        find.text('Applications close 14 Feb 2027, ahead of the cycle'),
        findsOneWidget,
      );
    });

    testWidgets('counts down inside the closing fortnight', (tester) async {
      // Urgency is for a candidate who can still act on it.
      clearRecord();
      await pumpBrowser(tester);

      expect(find.text('Closes in 10 days'), findsOneWidget);
      expect(
        find.text('Admissions active'),
        findsNWidgets(3),
        reason: 'the three programmes closing with the cycle',
      );
    });

    testWidgets('stays calm while the deadline is still far off', (
      tester,
    ) async {
      clearRecord();
      // English is 30 days out here, well outside the closing fortnight.
      await pumpBrowser(tester, at: DateTime(2027, 1, 15));

      expect(find.text('Closes in 30 days'), findsNothing);
      expect(
        find.text('Admissions active'),
        findsNWidgets(4),
        reason: 'nothing is urgent yet, so nothing is coloured as if it were',
      );
    });

    testWidgets('does not count down at a candidate who has already applied', (
      tester,
    ) async {
      await pumpBrowser(tester);

      // English closes in ten days, but his draft is already on it.
      expect(find.text('Closes in 10 days'), findsNothing);
      expect(
        inCard('B.A. English', 'Already applied this cycle'),
        findsOneWidget,
      );
    });
  });

  group('card content', () {
    testWidgets('names the faculty, duration, mode and fee', (tester) async {
      await pumpBrowser(tester);

      expect(find.text('SCIENCE'), findsNWidgets(2));
      expect(find.text('Department of Computer Science'), findsOneWidget);
      expect(find.text('5 years'), findsNWidgets(2));
      expect(find.text('Full-time undergraduate'), findsNWidgets(3));
      expect(find.text('4 years'), findsOneWidget);
      expect(find.text('3 years'), findsOneWidget);
      expect(find.text('2 years'), findsOneWidget);
      expect(find.text('Direct Entry / Full-time'), findsOneWidget);
      expect(find.text('Full-time diploma'), findsOneWidget);
      expect(find.text('₦6,000.00'), findsOneWidget);
      expect(find.text('₦5,000.00'), findsOneWidget);
    });

    testWidgets('view details says the service is not live yet', (
      tester,
    ) async {
      await pumpBrowser(tester);

      await tester.tap(find.text('View details').first);
      await tester.pumpAndSettle();

      expect(
        find.text('This service goes live with the next release.'),
        findsOneWidget,
      );
    });

    testWidgets('the chip strip is one tap target tall', (tester) async {
      await pumpBrowser(tester);

      expect(find.byType(FacultyFilterChips), findsOneWidget);
      expect(
        tester.getSize(find.byType(FacultyFilterChips)).height,
        AppDimensions.filterChipRowHeight,
      );
      expect(
        find.byType(FacultyChip),
        findsAtLeast(2),
        reason: 'built lazily, so only the visible ones exist',
      );
    });
  });

  group('actions', () {
    testWidgets('a closing-soon programme and an open one differ', (
      tester,
    ) async {
      await pumpBrowser(tester);

      final actions = tester
          .widgetList<ProgrammeCardActions>(find.byType(ProgrammeCardActions))
          .toList();

      expect(actions, hasLength(5));
      // Only Law is closed; the other four could be applied to on their own
      // terms...
      expect(
        actions.where((action) => action.programme.canApply),
        hasLength(4),
      );
      // ...but the record decides what the card offers.
      expect(
        actions.map((action) => action.availability),
        unorderedEquals([
          ApplyAvailability.alreadyApplied,
          ApplyAvailability.alreadyApplied,
          ApplyAvailability.alreadyApplied,
          ApplyAvailability.unavailable,
          ApplyAvailability.available,
        ]),
      );
    });
  });

  group('applying', () {
    testWidgets('opens a draft to the programme and moves to it', (
      tester,
    ) async {
      await pumpBrowserWithRouter(tester);
      expect(cubit.state.applications, hasLength(6));

      await tester.ensureVisible(find.text('Apply'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // A new draft, at the top of the record, filed to the diploma under
      // the cycle the browser was showing...
      final draft = cubit.state.applications.first;
      expect(cubit.state.applications, hasLength(7));
      expect(draft.status, ApplicationStatus.draft);
      expect(draft.programmeName, 'Diploma in Law');
      expect(draft.cycleName, '2026/2027 Undergraduate Admissions');
      expect(draft.submittedOn, designDay);
      expect(cubit.state.detailFor(draft.id), isNotNull);

      // ...and the browser has left for it.
      expect(find.text('detail:${draft.id}'), findsOneWidget);
      expect(find.byType(ProgrammeCard), findsNothing);
    });

    testWidgets('the card has no button left once the draft exists', (
      tester,
    ) async {
      await pumpBrowser(tester);
      cubit.startApplication(ProgrammeFixtures.diplomaInLaw.id, now: designDay);
      await tester.pumpAndSettle();

      expect(find.text('Apply'), findsNothing);
      expect(
        inCard('Diploma in Law', 'Already applied this cycle'),
        findsOneWidget,
      );
    });
  });
}
