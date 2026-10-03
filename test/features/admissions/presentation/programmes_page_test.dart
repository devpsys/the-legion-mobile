

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/core/utils/responsive.dart';
import 'package:the_legion_mobile/core/widgets/state_views.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
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

  Future<void> pumpBrowser(
    WidgetTester tester, {
    DateTime? at,
    Size size = const Size(390, 2400),
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = size * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AdmissionsCubit>.value(value: cubit),
          BlocProvider<AuthCubit>.value(value: auth),
          // The bell reads the session's notification centre, which the app
          // provides above the router.
          BlocProvider<NotificationCubit>.value(
            value: NotificationCubit(entries: NotificationFixtures.entries),
          ),
        ],
        child: MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProgrammesPage(now: at ?? designDay),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

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
      expect(find.text('4 available'), findsOneWidget);
      expect(find.text('All faculties (4)'), findsOneWidget);
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
      expect(find.text('Closes Feb 28, 2027'), findsOneWidget);
      expect(
        find.text('₦7,500.00'),
        findsNWidgets(4),
        reason: 'the cycle fee plus the three programmes priced at it',
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
        find.text('Closed Jan 31, 2027'),
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
      expect(find.byType(ProgrammeCard), findsNWidgets(4));
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
        'All faculties (4)',
        'Science (2)',
        'Arts (1)',
        'Law (1)',
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
        findsNWidgets(4),
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

      expect(find.text('Some requirements need checking'), findsNWidgets(2));
      expect(find.byIcon(Icons.warning), findsNWidgets(2));
      expect(
        find.textContaining("You don't yet meet"),
        findsNothing,
        reason: 'the bursary module is missing; nobody has refused anything',
      );
      expect(
        find.text('View programme & apply'),
        findsNWidgets(3),
        reason:
            'an unverified requirement still allows an application — the '
            'README says so, and three of the four cards must offer it',
      );
    });

    testWidgets('the closed programme says so and cannot be applied to', (
      tester,
    ) async {
      await pumpBrowser(tester);

      expect(find.text('Applications have closed'), findsOneWidget);
      expect(find.text('Archived session'), findsOneWidget);
      expect(find.text('View details'), findsOneWidget);
      expect(find.text('Closed on Jan 31, 2027'), findsOneWidget);
    });
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
        find.text('Applications close Feb 14, 2027, ahead of the cycle'),
        findsOneWidget,
      );
    });

    testWidgets('counts down inside the closing fortnight', (tester) async {
      await pumpBrowser(tester);

      expect(find.text('Closes in 10 days'), findsOneWidget);
      expect(
        find.text('Admissions active'),
        findsNWidgets(2),
        reason: 'the two programmes closing with the cycle',
      );
    });

    testWidgets('stays calm while the deadline is still far off', (
      tester,
    ) async {
      // English is 30 days out here, well outside the closing fortnight.
      await pumpBrowser(tester, at: DateTime(2027, 1, 15));

      expect(find.text('Closes in 30 days'), findsNothing);
      expect(
        find.text('Admissions active'),
        findsNWidgets(3),
        reason: 'nothing is urgent yet, so nothing is coloured as if it were',
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
      expect(find.text('Direct Entry / Full-time'), findsOneWidget);
      expect(find.text('₦6,000.00'), findsOneWidget);
    });

    testWidgets('tapping apply says the service is not live yet', (
      tester,
    ) async {
      await pumpBrowser(tester);

      await tester.tap(find.text('View programme & apply').first);
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

      expect(actions, hasLength(4));
      // Only Law is closed, so only it offers details instead of an application.
      expect(
        actions.where((action) => action.programme.canApply),
        hasLength(3),
      );
    });
  });
}
