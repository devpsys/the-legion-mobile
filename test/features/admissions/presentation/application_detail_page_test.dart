import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/programme_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/application_detail_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/programme_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/pages/application_detail_page.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_tab_bar.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/application_checklist_row.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/referee_invite_form.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/withdraw_application_sheet.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';

import '../../../helpers/signed_in_auth_cubit.dart';

void main() {
  late AdmissionsCubit cubit;
  late AuthCubit auth;

  /// The draft: the only record on the portal with a detail screen.
  const draftId = 'app-00057';

  setUp(() async {
    cubit = AdmissionsCubit();
    auth = await signedInAuthCubit();
  });
  tearDown(() async {
    await cubit.close();
    await auth.close();
  });

  Future<void> pumpDetail(
    WidgetTester tester, {
    String applicationId = draftId,
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
          home: ApplicationDetailPage(applicationId: applicationId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The declaration's own line, matched by its opening words rather than the
  /// whole sentence.
  Finder declaration() => find.textContaining('I confirm that the information');

  /// The submit button, found through its label.
  Finder submitButton() => find.ancestor(
    of: find.text('Submit application'),
    matching: find.byType(FilledButton),
  );

  group('the bar and the header', () {
    testWidgets('names the record by its reference and its screen', (
      tester,
    ) async {
      await pumpDetail(tester);

      // Twice: once in the bar, once on the header, because a candidate
      // quoting the number to the registry should not have to look for it.
      expect(find.text('APP/2026/00057'), findsNWidgets(2));
      expect(find.text('APPLICATION DETAIL'), findsOneWidget);
      expect(find.text('Application'), findsOneWidget);
      expect(find.text('2026/2027 Undergraduate Admissions'), findsOneWidget);
      expect(find.text('Draft'), findsOneWidget);
    });

    testWidgets('quotes the deadline this application is actually against', (
      tester,
    ) async {
      await pumpDetail(tester);

      // The filed first choice closes a fortnight before the cycle does, so
      // quoting the cycle's date here would promise time the portal will not
      // give him.
      expect(find.text('Submit by 14 Feb 2027, 23:59'), findsOneWidget);
    });

    testWidgets('carries the portal\'s chrome and no tab bar', (tester) async {
      await pumpDetail(tester);

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
      expect(
        find.byType(AdmissionsTabBar),
        findsNothing,
        reason: 'reading one file is not a fourth section of the portal',
      );
    });
  });

  group('the readiness checklist', () {
    testWidgets('draws every item and counts the ones that are done', (
      tester,
    ) async {
      await pumpDetail(tester);

      expect(find.byType(ApplicationChecklistRow), findsNWidgets(9));
      expect(find.text('3 of 9 complete'), findsOneWidget);
      expect(
        find.text('Before you submit'),
        findsOneWidget,
        reason: 'the card is named after what it is for',
      );

      final progress = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progress.value, closeTo(3 / 9, 0.001));
    });

    testWidgets('shows the two items nobody could answer as untracked', (
      tester,
    ) async {
      await pumpDetail(tester);

      // Amber, labelled in words as well as by colour: a requirement the
      // bursary cannot check must not read as one the candidate failed.
      expect(find.text('Not tracked'), findsNWidgets(2));
      expect(find.text('JAMB result from CAPS'), findsOneWidget);
      expect(find.text('Application form fee'), findsOneWidget);
    });

    testWidgets('offers an action on every row that has one', (tester) async {
      await pumpDetail(tester);

      expect(find.text('Complete'), findsOneWidget);
      expect(find.text('Claim'), findsOneWidget);
      expect(find.text('Upload'), findsOneWidget);
      expect(find.text('Invite'), findsOneWidget);
      expect(find.text('Check'), findsOneWidget);
      // The checklist's resend, and the referee's — two different rows that
      // happen to share a verb.
      expect(find.text('Resend'), findsNWidgets(2));
      // The rows that are finished offer nothing to tap.
      expect(
        find.descendant(
          of: find.text("O'level results"),
          matching: find.byType(TextButton),
        ),
        findsNothing,
      );
    });

    testWidgets('sends a fresh confirmation link from the card', (
      tester,
    ) async {
      await pumpDetail(tester);

      expect(find.text('Resend confirmation email'), findsOneWidget);
      await tester.tap(find.text('Resend confirmation email'));
      await tester.pumpAndSettle();

      expect(
        find.text('Confirmation link sent. Check your inbox.'),
        findsOneWidget,
      );
      expect(cubit.state.hasSentEmailLink, isTrue);
    });

    testWidgets('brings the candidate to the referee form from its row', (
      tester,
    ) async {
      // A phone, so the form starts well below the fold: the action has
      // somewhere to scroll to, which is the only reason it exists.
      await pumpDetail(tester, size: const Size(390, 844));

      final formRect = tester.getRect(find.byType(RefereeInviteForm));
      expect(
        formRect.top,
        greaterThan(tester.view.physicalSize.height / 2),
        reason: 'the form is not on screen before the tap',
      );

      await tester.ensureVisible(find.text('Invite'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invite'));
      await tester.pumpAndSettle();

      expect(
        tester.getRect(find.byType(RefereeInviteForm)).top,
        lessThan(tester.view.physicalSize.height),
        reason: 'the row must land the candidate on the thing it names',
      );
    });
  });

  group('submit', () {
    testWidgets('stays off while the checklist has known gaps', (tester) async {
      await pumpDetail(tester);

      expect(
        find.text('Complete the checklist first. 4 items are outstanding'),
        findsOneWidget,
        reason: 'the disabled button says which items, and how many',
      );
      expect(tester.widget<FilledButton>(submitButton()).onPressed, isNull);

      // Ticking the declaration cannot make the gaps go away.
      await tester.ensureVisible(declaration());
      await tester.pumpAndSettle();
      await tester.tap(declaration());
      await tester.pumpAndSettle();

      expect(tester.widget<FilledButton>(submitButton()).onPressed, isNull);
      expect(
        find.text('Complete the checklist first. 4 items are outstanding'),
        findsOneWidget,
      );
    });

    testWidgets('opens once the checklist is complete and the box is ticked', (
      tester,
    ) async {
      // The same record with every row green: the state the candidate reaches
      // on the last afternoon, not the one the fixture ships with.
      cubit.load();
      final detail = cubit.state.detailFor(draftId)!;
      cubit.emit(
        cubit.state.copyWith(
          applicationDetails: {
            draftId: ApplicationDetail(
              application: detail.application,
              cycleId: detail.cycleId,
              firstChoiceProgrammeId: detail.firstChoiceProgrammeId,
              secondChoiceProgrammeId: detail.secondChoiceProgrammeId,
              checklist: [
                for (final item in detail.checklist)
                  ChecklistItem(
                    id: item.id,
                    state: RequirementState.met,
                    title: item.title,
                    detail: item.detail,
                    action: item.action,
                  ),
              ],
              referees: detail.referees,
              history: detail.history,
            ),
          },
        ),
      );

      await pumpDetail(tester);

      expect(find.text('9 of 9 complete'), findsOneWidget);
      expect(
        find.text('Tick the confirmation above to submit.'),
        findsOneWidget,
        reason: 'the gaps are gone, so the only thing left is the tick',
      );
      expect(tester.widget<FilledButton>(submitButton()).onPressed, isNull);

      await tester.ensureVisible(declaration());
      await tester.pumpAndSettle();
      await tester.tap(declaration());
      await tester.pumpAndSettle();

      expect(tester.widget<FilledButton>(submitButton()).onPressed, isNotNull);

      await tester.tap(submitButton());
      await tester.pumpAndSettle();

      expect(
        find.text('This service goes live with the next release.'),
        findsOneWidget,
        reason: 'the gate is real; the submission service is not here yet',
      );
    });
  });

  group('programme choices', () {
    testWidgets('quotes the fee for the choice on screen', (tester) async {
      await pumpDetail(tester);

      expect(find.text('B.A. English'), findsOneWidget);
      expect(find.text('None'), findsOneWidget, reason: 'no second choice');
      expect(
        find.textContaining(
          'Form fee for your first choice',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('₦6,000.00', findRichText: true),
        findsNWidgets(2),
        reason: 'the choices line and the checklist row quote the same fee',
      );

      await tester.ensureVisible(find.text('B.A. English'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B.A. English'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B.Sc. Computer Science'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('₦7,500.00', findRichText: true),
        findsOneWidget,
        reason: 'the line follows the menu, not the record it was filed under',
      );
      expect(
        find.textContaining('₦6,000.00', findRichText: true),
        findsOneWidget,
        reason: 'while the checklist keeps quoting the fee already filed',
      );
    });

    testWidgets('does not offer a programme that has closed', (tester) async {
      await pumpDetail(tester);

      await tester.ensureVisible(find.text('B.A. English'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B.A. English'));
      await tester.pumpAndSettle();

      expect(find.text('Law'), findsNothing);
      expect(find.text('B.A. English'), findsWidgets);
    });
  });

  group('referees', () {
    testWidgets('names who was invited and what they have not done yet', (
      tester,
    ) async {
      await pumpDetail(tester);

      expect(
        find.text(
          'At least 2 required. Each receives an emailed link to a short confidential form.',
        ),
        findsOneWidget,
      );
      expect(find.text('Dr Amina Yusuf'), findsOneWidget);
      expect(find.text('AY'), findsOneWidget, reason: 'the monogram');
      expect(find.text('amina.yusuf@uniabuja.edu.ng'), findsOneWidget);
      expect(find.text('Awaiting'), findsOneWidget);
      expect(find.text('Invite a referee'), findsOneWidget);
    });

    testWidgets('validates the invitation before offering to send it', (
      tester,
    ) async {
      await pumpDetail(tester);

      await tester.ensureVisible(find.text('Send invitation'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Send invitation'));
      await tester.pumpAndSettle();
      expect(find.text('This field is required.'), findsNWidgets(2));

      await tester.enterText(
        find.byType(TextFormField).first,
        'Dr Nneka Okafor',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'not-an-email');
      await tester.tap(find.text('Send invitation'));
      await tester.pumpAndSettle();

      expect(find.text('This field is required.'), findsNothing);
      expect(find.text('Enter a valid email address.'), findsOneWidget);

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'nneka@uniabuja.edu.ng',
      );
      await tester.tap(find.text('Send invitation'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address.'), findsNothing);
      expect(
        find.text('This service goes live with the next release.'),
        findsOneWidget,
        reason: 'a valid invitation is still one nobody has built',
      );
    });
  });

  group('history', () {
    testWidgets('tells the log newest first, with the note called out', (
      tester,
    ) async {
      await pumpDetail(tester);

      expect(find.text('History'), findsOneWidget);
      expect(find.text('Append-only record'), findsOneWidget);
      expect(find.text('Screening note'), findsOneWidget);
      expect(
        find.text('Awaiting your WAEC/NECO result to be verified.'),
        findsOneWidget,
      );
      expect(find.text('Application started'), findsOneWidget);
      expect(find.text('Referee invited: Dr Amina Yusuf'), findsOneWidget);
      // Two events landed on the 18th; the date is printed on both lines.
      expect(find.text('18 Sep'), findsNWidgets(2));
      expect(find.text('20 Sep'), findsOneWidget);
    });
  });

  group('withdrawing', () {
    testWidgets('asks first, and does nothing until it is told to', (
      tester,
    ) async {
      await pumpDetail(tester);

      await tester.ensureVisible(find.text('Withdraw application'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Withdraw application'));
      await tester.pumpAndSettle();

      expect(find.byType(WithdrawApplicationSheet), findsOneWidget);
      expect(find.text('Withdraw this application?'), findsOneWidget);
      expect(
        find.text(
          'The application is closed for good and cannot be reopened. '
          'You can start another while the cycle is still open.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('This service goes live with the next release.'),
        findsNothing,
        reason: 'asking is not answering',
      );

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(WithdrawApplicationSheet), findsNothing);
      expect(
        find.text('This service goes live with the next release.'),
        findsNothing,
      );
    });

    testWidgets('confirms from the sheet, and reports the outcome', (
      tester,
    ) async {
      await pumpDetail(tester);

      await tester.ensureVisible(find.text('Withdraw application'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Withdraw application'));
      await tester.pumpAndSettle();

      // The sheet repeats the button it is confirming, so it is found inside
      // the sheet rather than by walking into the screen behind it.
      await tester.tap(
        find.descendant(
          of: find.byType(WithdrawApplicationSheet),
          matching: find.text('Withdraw application'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WithdrawApplicationSheet), findsNothing);
      expect(
        find.text('This service goes live with the next release.'),
        findsOneWidget,
      );
    });
  });

  group('a draft just opened from the browser', () {
    /// The design day: the cycle and the diploma are both open.
    final designDay = DateTime(2027, 2, 4);

    testWidgets('is a full record the moment it exists', (tester) async {
      cubit.load();
      final id = cubit.startApplication(
        ProgrammeFixtures.diplomaInLaw.id,
        now: designDay,
      )!;

      await pumpDetail(tester, applicationId: id);

      // The bar and the header name it like any record...
      expect(find.text('APP/2026/00919'), findsNWidgets(2));
      expect(find.text('Draft'), findsOneWidget);
      expect(find.text('2026/2027 Undergraduate Admissions'), findsOneWidget);
      // ...against the deadline it is actually filed under: the diploma
      // closes with the cycle.
      expect(find.text('Submit by 28 Feb 2027, 23:59'), findsOneWidget);

      // The checklist is the candidate's standing, with nothing of another
      // application's on it.
      expect(find.text('3 of 9 complete'), findsOneWidget);
      expect(find.text('0 of 2 invited | 0 responded.'), findsOneWidget);
      expect(find.textContaining('₦5,000.00'), findsWidgets);
      expect(find.text('Dr Amina Yusuf'), findsNothing);

      // The choice made on the card is the first choice here, and the log
      // says so.
      expect(find.text('Diploma in Law'), findsWidgets);
      expect(find.text('First choice set to Diploma in Law'), findsOneWidget);
      expect(find.text('Application started'), findsOneWidget);
    });
  });

  group('a record that is not there', () {
    testWidgets('explains itself instead of drawing an empty screen', (
      tester,
    ) async {
      await pumpDetail(tester, applicationId: 'app-99999');

      expect(
        find.text('This application is no longer on your record.'),
        findsOneWidget,
      );
      expect(find.byType(ApplicationChecklistRow), findsNothing);
    });
  });

  group('layout', () {
    for (final width in [320.0, 390.0, 430.0, 768.0, 1280.0]) {
      testWidgets('fits a $width px viewport without overflowing', (
        tester,
      ) async {
        await pumpDetail(tester, size: Size(width, 2400));

        expect(
          tester.takeException(),
          isNull,
          reason: 'an overflow here is one a candidate would see',
        );
      });
    }

    testWidgets('renders in dark mode too', (tester) async {
      await pumpDetail(tester, dark: true);

      expect(tester.takeException(), isNull);
      expect(find.byType(ApplicationChecklistRow), findsNWidgets(9));
      expect(find.text('Not tracked'), findsNWidgets(2));
    });
  });
}
