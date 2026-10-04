import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_state.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/jamb_claim_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/jamb_claim_state.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/admissions_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/pages/jamb_claim_page.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_tab_bar.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_task_bar.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/jamb_claim_form.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/jamb_record_card.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/section_surface.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/tone_callout.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';

import '../../../helpers/signed_in_auth_cubit.dart';

/// The JAMB tab, over the in-memory import.
void main() {
  late AdmissionsCubit admissions;
  late JambClaimCubit claim;
  late AuthCubit auth;

  /// 3 October 2026: the picker's upper bound, and 80 years back its lower.
  final designDay = DateTime(2026, 10, 3, 15);
  final born = DateTime(2008, 5, 2);

  setUp(() async {
    admissions = AdmissionsCubit();
    claim = JambClaimCubit();
    auth = await signedInAuthCubit();
  });
  tearDown(() async {
    await admissions.close();
    await claim.close();
    await auth.close();
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    Size size = const Size(390, 1800),
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = size * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AdmissionsCubit>.value(value: admissions),
          BlocProvider<JambClaimCubit>.value(value: claim),
          BlocProvider<AuthCubit>.value(value: auth),
          BlocProvider<NotificationCubit>.value(
            value: NotificationCubit(entries: NotificationFixtures.entries),
          ),
        ],
        child: MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: JambClaimPage(now: designDay),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The fields in the design's order: number, surname, date.
  Finder fieldAt(int index) => find.byType(TextField).at(index);

  /// Types the candidate's own facts. The date is set on the cubit, as the
  /// picker would; opening the dialog is tested on its own.
  Future<void> fillOwnFacts(
    WidgetTester tester, {
    String surname = 'Ibrahim',
  }) async {
    await tester.enterText(fieldAt(0), '202630112233ab');
    await tester.enterText(fieldAt(1), surname);
    claim.dateOfBirthChanged(born);
    await tester.pumpAndSettle();
  }

  Future<void> tapPrimary(WidgetTester tester, String label) async {
    await tester.ensureVisible(find.text(label));
    await tester.pumpAndSettle();
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  group('chrome', () {
    testWidgets('wears the portal\'s own bar, like the other three tabs', (
      tester,
    ) async {
      await pumpPage(tester);

      expect(find.byType(AdmissionsTaskBar), findsOneWidget);
      expect(find.text('2026/2027 Cycle'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(
        find.text('${NotificationFixtures.entries.length}'),
        findsOneWidget,
        reason: 'one centre, so the badge matches the overview exactly',
      );
      // No chevron: a tab is a section, and back is the system gesture.
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('keeps JAMB selected in the portal tab bar, badged', (
      tester,
    ) async {
      await pumpPage(tester);

      final tabBar = tester.widget<AdmissionsTabBar>(
        find.byType(AdmissionsTabBar),
      );
      expect(tabBar.selectedIndex, 3);
      expect(tabBar.jambBadge, isTrue);
    });

    testWidgets('loads the portal itself when opened cold', (tester) async {
      expect(admissions.state.status, AdmissionsStatus.initial);

      await pumpPage(tester);

      expect(admissions.state.status, AdmissionsStatus.ready);
      expect(find.byType(JambClaimForm), findsOneWidget);
    });
  });

  group('the form', () {
    testWidgets('introduces the import before asking anything', (tester) async {
      await pumpPage(tester);

      expect(find.text('CAPS RESULT IMPORT'), findsOneWidget);
      expect(find.text('Claim your JAMB result'), findsOneWidget);
      expect(
        find.textContaining('Central Admissions Processing System (CAPS)'),
        findsOneWidget,
      );
    });

    testWidgets('asks for the three facts, each marked required', (
      tester,
    ) async {
      await pumpPage(tester);

      final labels = tester
          .widgetList<JambFormField>(find.byType(JambFormField))
          .map((field) => field.label)
          .toList();
      expect(labels, ['JAMB registration number', 'Surname', 'Date of birth']);
      expect(find.text('*'), findsNothing, reason: 'the marker is a span');

      final theme = Theme.of(tester.element(find.byType(JambClaimForm)));
      final markers = tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(JambFormField),
              matching: find.byType(Text),
            ),
          )
          .map((text) => text.textSpan)
          .whereType<TextSpan>()
          .map((span) => span.children!.last as TextSpan)
          .toList();
      expect(markers, hasLength(3));
      for (final marker in markers) {
        expect(marker.text, '*');
        expect(marker.style?.color, theme.colorScheme.error);
      }

      expect(
        find.text(
          '12-digit number followed by 2 letters, as printed on your JAMB '
          'slip.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Must match exactly as registered with JAMB.'),
        findsOneWidget,
      );
      expect(
        find.text('Used to verify you are the legitimate candidate.'),
        findsOneWidget,
      );
    });

    testWidgets('warns that linking is permanent', (tester) async {
      await pumpPage(tester);

      final callout = tester.widget<ToneCallout>(find.byType(ToneCallout));
      expect(callout.body, contains('permanent and cannot be undone'));
      expect(find.byIcon(Icons.warning_rounded), findsOneWidget);
    });

    testWidgets('capitalises the number as typed and ticks it when complete', (
      tester,
    ) async {
      await pumpPage(tester);

      await tester.enterText(fieldAt(0), '2026301122');
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_circle), findsNothing);
      expect(claim.state.isRegistrationNumberComplete, isFalse);

      await tester.enterText(fieldAt(0), '202630112233ab');
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(fieldAt(0)).controller!.text,
        '202630112233AB',
      );
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(claim.state.isRegistrationNumberComplete, isTrue);
    });

    testWidgets('opens a date picker for the birthday and shows the pick', (
      tester,
    ) async {
      await pumpPage(tester);

      expect(find.text('DD / MM / YYYY'), findsOneWidget);
      await tester.ensureVisible(fieldAt(2));
      await tester.pumpAndSettle();
      await tester.tap(fieldAt(2));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
      expect(find.text('Your date of birth'), findsOneWidget);
      // Opens eighteen years back, the age most candidates are.
      expect(find.text('October 2008'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsNothing);

      // The picked date reaches the field in the slip's digit-by-digit form.
      claim.dateOfBirthChanged(born);
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(fieldAt(2)).controller!.text,
        '02 / 05 / 2008',
      );
    });

    testWidgets('keeps the button disabled until every fact is in', (
      tester,
    ) async {
      await pumpPage(tester);

      FilledButton primary() =>
          tester.widget<FilledButton>(find.byType(FilledButton));
      expect(find.text('Find my result'), findsOneWidget);
      expect(primary().onPressed, isNull);

      await tester.enterText(fieldAt(0), '202630112233AB');
      await tester.enterText(fieldAt(1), 'IBRAHIM');
      await tester.pumpAndSettle();
      expect(primary().onPressed, isNull, reason: 'no date yet');

      claim.dateOfBirthChanged(born);
      await tester.pumpAndSettle();
      expect(primary().onPressed, isNotNull);
    });
  });

  group('matching', () {
    testWidgets('shows the CAPS record and asks for confirmation', (
      tester,
    ) async {
      await pumpPage(tester);
      await fillOwnFacts(tester);
      await tapPrimary(tester, 'Find my result');

      expect(claim.state.status, JambClaimStatus.matched);
      expect(find.byType(JambRecordCard), findsOneWidget);
      expect(find.text('VERIFICATION STATUS'), findsOneWidget);
      expect(find.text('Official CAPS record'), findsOneWidget);
      expect(find.text('Record found'), findsOneWidget);
      expect(find.text('Musa Ibrahim'), findsOneWidget);
      expect(find.text('2026 UTME'), findsOneWidget);
      expect(find.text('Aggregate score'), findsOneWidget);
      expect(find.text('312'), findsOneWidget);
      expect(find.text('SUBJECT BREAKDOWN'), findsOneWidget);
      for (final subject in [
        'English',
        'Mathematics',
        'Physics',
        'Chemistry',
      ]) {
        expect(find.text(subject), findsOneWidget);
      }
      expect(find.text('74'), findsOneWidget);
      expect(find.text('82'), findsOneWidget);
      expect(find.text('78'), findsNWidgets(2));

      // Bound for the draft, in the future tense.
      expect(
        find.textContaining('will be permanently linked to'),
        findsOneWidget,
      );
      expect(find.textContaining('APP/2026/00057'), findsOneWidget);

      // The one button now asks the other question.
      expect(find.text('Confirm and link result'), findsOneWidget);
      expect(find.text('Find my result'), findsNothing);
    });

    testWidgets('lays the subjects out two to a row', (tester) async {
      await pumpPage(tester);
      await fillOwnFacts(tester);
      await tapPrimary(tester, 'Find my result');

      final tiles = find.byType(JambSubjectTile);
      expect(tiles, findsNWidgets(4));
      final english = tester.getTopLeft(tiles.at(0));
      final maths = tester.getTopLeft(tiles.at(1));
      final physics = tester.getTopLeft(tiles.at(2));
      expect(maths.dy, english.dy, reason: 'same row');
      expect(maths.dx, greaterThan(english.dx));
      expect(
        physics.dx,
        english.dx,
        reason: 'second row starts under the first',
      );
      expect(physics.dy, greaterThan(english.dy));
    });

    testWidgets('says so when the facts match nothing', (tester) async {
      await pumpPage(tester);
      await fillOwnFacts(tester, surname: 'Adeyemi');
      await tapPrimary(tester, 'Find my result');

      expect(claim.state.status, JambClaimStatus.notFound);
      expect(find.byType(JambRecordCard), findsNothing);
      expect(find.text('No record matches these details'), findsOneWidget);
      expect(
        find.textContaining('CAPS has not sent us your result yet'),
        findsOneWidget,
      );
      // Two callouts now: the caution on the form, and the refusal.
      expect(find.byType(ToneCallout), findsNWidgets(2));
      expect(find.text('Find my result'), findsOneWidget);
    });

    testWidgets('drops the record the moment a fact changes', (tester) async {
      await pumpPage(tester);
      await fillOwnFacts(tester);
      await tapPrimary(tester, 'Find my result');
      expect(find.byType(JambRecordCard), findsOneWidget);

      await tester.enterText(fieldAt(1), 'IBRAHI');
      await tester.pumpAndSettle();

      expect(find.byType(JambRecordCard), findsNothing);
      expect(find.text('Find my result'), findsOneWidget);
    });
  });

  group('linking', () {
    testWidgets('puts the result on the record and retires the form', (
      tester,
    ) async {
      await pumpPage(tester);
      await fillOwnFacts(tester);
      await tapPrimary(tester, 'Find my result');
      await tapPrimary(tester, 'Confirm and link result');

      expect(admissions.state.linkedJambResult, AdmissionsFixtures.jambResult);
      expect(admissions.state.jambResultPending, isFalse);
      expect(
        find.text('Your JAMB result is now on your record.'),
        findsOneWidget,
      );

      // The form is gone; the record stays, in the present tense.
      expect(find.byType(JambClaimForm), findsNothing);
      expect(find.byType(FilledButton), findsNothing);
      expect(find.byType(JambRecordCard), findsOneWidget);
      expect(find.text('Linked'), findsOneWidget);
      expect(find.byIcon(Icons.link), findsOneWidget);
      expect(find.textContaining('is permanently linked to'), findsOneWidget);
      expect(find.text('312'), findsOneWidget);

      // The badge on the tab goes with it.
      final tabBar = tester.widget<AdmissionsTabBar>(
        find.byType(AdmissionsTabBar),
      );
      expect(tabBar.jambBadge, isFalse);
    });

    testWidgets('moves on to the linked application after a pause', (
      tester,
    ) async {
      const pause = Duration(seconds: 2);
      tester.view
        ..physicalSize = const Size(390, 1800) * 2
        ..devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      // A router with just two stops: this page, and a stand-in for the
      // detail the page is expected to leave for.
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) =>
                JambClaimPage(now: designDay, linkedPause: pause),
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
        MultiBlocProvider(
          providers: [
            BlocProvider<AdmissionsCubit>.value(value: admissions),
            BlocProvider<JambClaimCubit>.value(value: claim),
            BlocProvider<AuthCubit>.value(value: auth),
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
      await tester.pumpAndSettle();
      await fillOwnFacts(tester);
      await tapPrimary(tester, 'Find my result');
      await tester.ensureVisible(find.text('Confirm and link result'));
      await tester.pumpAndSettle();
      // The pause starts at the tap, so the clock is read from here: one
      // frame, not a settle, which would eat into it.
      await tester.tap(find.text('Confirm and link result'));
      await tester.pump();

      // The linked record is left on screen to be read...
      expect(find.text('Linked'), findsOneWidget);
      await tester.pump(pause - const Duration(milliseconds: 200));
      expect(find.text('Linked'), findsOneWidget);
      expect(find.textContaining('detail:'), findsNothing);

      // ...and then the page leaves for the draft it was linked to.
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(find.text('detail:app-00057'), findsOneWidget);
      expect(find.byType(JambRecordCard), findsNothing);
    });

    testWidgets('does not leave if the candidate already has', (tester) async {
      await pumpPage(tester);
      await fillOwnFacts(tester);
      await tapPrimary(tester, 'Find my result');
      await tapPrimary(tester, 'Confirm and link result');

      // Replacing the page before the pause ends disposes it; the pending
      // move must go with it rather than fire into a tree that has no router.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(JambClaimPage.defaultLinkedPause);

      expect(tester.takeException(), isNull);
    });

    testWidgets('opens straight onto the record when already linked', (
      tester,
    ) async {
      admissions
        ..load()
        ..linkJambResult(AdmissionsFixtures.jambResult);

      await pumpPage(tester);

      expect(find.byType(JambClaimForm), findsNothing);
      expect(find.byType(JambRecordCard), findsOneWidget);
      expect(find.text('Linked'), findsOneWidget);
      expect(find.byType(HubSectionSurface), findsOneWidget);
    });

    testWidgets('still offers the registry\'s help', (tester) async {
      await pumpPage(tester);

      await tester.ensureVisible(find.textContaining('Need help claiming?'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Need help claiming?'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });

  group('layout', () {
    for (final width in [320.0, 390.0, 768.0, 1280.0]) {
      testWidgets('lays out at ${width.toInt()}px with the record shown', (
        tester,
      ) async {
        await pumpPage(tester, size: Size(width, 2000));
        await fillOwnFacts(tester);
        await tapPrimary(tester, 'Find my result');

        expect(tester.takeException(), isNull);
        expect(find.byType(JambRecordCard), findsOneWidget);
      });
    }

    testWidgets('renders in the dark theme', (tester) async {
      await pumpPage(tester, dark: true);
      await fillOwnFacts(tester);
      await tapPrimary(tester, 'Find my result');

      expect(tester.takeException(), isNull);
    });
  });
}
