import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/pages/applications_page.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_tab_bar.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/application_list_card.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/applications_empty_state.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/striped_card.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';

import '../../../helpers/signed_in_auth_cubit.dart';

void main() {
  late AdmissionsCubit cubit;
  late AuthCubit auth;

  /// 3 October 2026, mid-afternoon. The offer's record was last changed at
  /// noon the same day, so the card reads "3 hours ago" — exactly the stamp
  /// the `admissions_my_applications` design draws.
  final designDay = DateTime(2026, 10, 3, 15);

  setUp(() async {
    cubit = AdmissionsCubit();
    auth = await signedInAuthCubit();
  });
  tearDown(() async {
    await cubit.close();
    await auth.close();
  });

  Future<void> pumpApplications(
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
          home: ApplicationsPage(now: at ?? designDay),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('chrome', () {
    testWidgets('titles the record and floats the one action', (tester) async {
      await pumpApplications(tester);

      expect(find.text('My applications'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('New application'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('keeps Applications selected in the portal tab bar', (
      tester,
    ) async {
      await pumpApplications(tester);

      final tabBar = tester.widget<AdmissionsTabBar>(
        find.byType(AdmissionsTabBar),
      );
      expect(tabBar.selectedIndex, 2);
    });

    testWidgets('shares the bell and the count with the rest of the portal', (
      tester,
    ) async {
      await pumpApplications(tester);

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(
        find.text('${NotificationFixtures.entries.length}'),
        findsOneWidget,
        reason: 'one centre, so the badge matches the overview exactly',
      );
    });
  });

  group('the outstanding offer', () {
    testWidgets('carries the reference, the status and the cycle', (
      tester,
    ) async {
      await pumpApplications(tester);

      expect(find.text('APP/2026/00042'), findsOneWidget);
      expect(find.text('Admission offered'), findsOneWidget);
      expect(find.text('2026/2027 Undergraduate Admissions'), findsOneWidget);
      expect(find.text('B.Sc. Computer Science'), findsOneWidget);
      expect(
        find.text('Second choice: B.Sc. Data Science'),
        findsOneWidget,
        reason:
            'the second choice is a fact of the record, not a detail screen',
      );
    });

    testWidgets('quotes the deadline and stamps how fresh it is', (
      tester,
    ) async {
      await pumpApplications(tester);

      expect(find.text('Respond by Feb 28, 2027'), findsOneWidget);
      expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
      expect(
        find.text('3 hours ago'),
        findsOneWidget,
        reason: 'a change from this morning reads as an event, not a date',
      );
    });

    testWidgets('falls back to a date once the change is no longer fresh', (
      tester,
    ) async {
      // A week later: the same update, no longer an event.
      await pumpApplications(tester, at: DateTime(2026, 10, 10, 15));

      expect(
        find.text('Updated Oct 3, 2026'),
        findsOneWidget,
        reason: '"168 hours ago" is arithmetic the candidate did not ask for',
      );
      expect(find.text('Respond by Feb 28, 2027'), findsOneWidget);
    });
  });

  group('a rejection that explains itself', () {
    testWidgets('says when it was last touched and why nothing more will be', (
      tester,
    ) async {
      await pumpApplications(tester);

      expect(find.text('APP/2025/00918'), findsOneWidget);
      expect(find.text('Rejected'), findsOneWidget);
      expect(find.text('B.A. English'), findsOneWidget);
      expect(find.text('Updated Sep 14, 2026'), findsOneWidget);
      expect(
        find.text('Admissions for this cycle closed on Feb 28, 2026.'),
        findsOneWidget,
      );
    });

    testWidgets('keeps that reason outside the card it belongs to', (
      tester,
    ) async {
      await pumpApplications(tester);

      // Drawn *under* the card rather than in it: a refusal whose reason sits
      // on the surface reads as a verdict on the candidate.
      expect(
        find.ancestor(
          of: find.text('Admissions for this cycle closed on Feb 28, 2026.'),
          matching: find.byType(StripedCard),
        ),
        findsNothing,
      );
    });
  });

  group('the matriculated application', () {
    testWidgets('hands over to the student portal instead of a detail', (
      tester,
    ) async {
      await pumpApplications(tester);

      expect(find.text('APP/2024/00377'), findsOneWidget);
      expect(find.text('Matriculated'), findsOneWidget, reason: 'the status');
      expect(
        find.text('MATRICULATION'),
        findsOneWidget,
        reason: 'the label above the number, drawn in spaced capitals',
      );
      expect(find.text('25/ACC/0087'), findsOneWidget);
      expect(find.text('Open the student portal'), findsOneWidget);
      expect(
        find.byIcon(Icons.arrow_outward),
        findsOneWidget,
        reason: 'the card has somewhere to go, so it does not offer a chevron',
      );
    });

    testWidgets('is the one card without a tap-through', (tester) async {
      await pumpApplications(tester);

      // Two chevrons: the offer and the rejection. The third card is finished.
      expect(find.byIcon(Icons.chevron_right), findsNWidgets(2));
    });
  });

  group('opening a card', () {
    testWidgets('says the detail screen is not live in this release', (
      tester,
    ) async {
      await pumpApplications(tester);

      await tester.tap(find.text('B.A. English'));
      await tester.pumpAndSettle();

      expect(
        find.text('This service goes live with the next release.'),
        findsOneWidget,
      );
    });
  });

  group('an empty record', () {
    testWidgets('explains itself and points at the browser', (tester) async {
      cubit.load();
      cubit.emit(cubit.state.copyWith(applications: []));

      await pumpApplications(tester);

      expect(find.byType(ApplicationsEmptyState), findsOneWidget);
      expect(find.text('No applications yet'), findsOneWidget);
      expect(find.byType(ApplicationListCard), findsNothing);
      expect(
        find.byType(FloatingActionButton),
        findsOneWidget,
        reason: 'the way to start is the one thing an empty record still needs',
      );
    });
  });

  group('layout', () {
    for (final width in [320.0, 390.0, 430.0, 768.0, 1280.0]) {
      testWidgets('fits a $width px viewport without overflowing', (
        tester,
      ) async {
        // 320px is the narrowest phone the app claims to support; 1280 is a
        // desktop window, where the canvas is centred rather than full width.
        await pumpApplications(tester, size: Size(width, 2400));

        expect(
          tester.takeException(),
          isNull,
          reason: 'an overflow here is one a candidate would see',
        );
      });
    }

    testWidgets('renders in dark mode too', (tester) async {
      await pumpApplications(tester, dark: true);

      expect(tester.takeException(), isNull);
      expect(find.byType(ApplicationListCard), findsNWidgets(3));
    });

    testWidgets('leaves the last card\'s action under no part of the FAB', (
      tester,
    ) async {
      await pumpApplications(tester);

      final fab = tester.getRect(find.byType(FloatingActionButton));
      final portalAction = tester.getRect(
        find
            .ancestor(
              of: find.text('Open the student portal'),
              matching: find.byType(OutlinedButton),
            )
            .first,
      );

      expect(
        fab.overlaps(portalAction),
        isFalse,
        reason: 'the door to the student portal must stay tappable',
      );
    });
  });
}
