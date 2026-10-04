import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/core/theme/app_tone.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/admissions_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/admissions_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/application_detail_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/pages/application_detail_page.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/application_checklist_row.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/application_detail_header.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/application_faq_card.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/application_history_card.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/application_next_cycle_card.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/application_rejection_audit_card.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/closed_state_cards.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/matriculated_card.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/offer_card.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';

import '../../../helpers/signed_in_auth_cubit.dart';

/// The detail screen for every status that is not a draft: the offer, the
/// refusal, and the endings that carry no decision.
void main() {
  late AdmissionsCubit cubit;
  late AuthCubit auth;

  /// A day inside the current cycle, so the refusal's way forward is open.
  final openDay = DateTime(2026, 10, 3, 14);

  /// A day after every cycle has closed.
  final closedDay = DateTime(2027, 6);

  const offeredId = 'app-00042';
  const rejectedId = 'app-00918';
  const matriculatedId = 'app-00377';
  const expiredId = 'app-00611';
  const withdrawnId = 'app-00733';

  const comingSoon = 'This service goes live with the next release.';

  setUp(() async {
    cubit = AdmissionsCubit();
    auth = await signedInAuthCubit();
  });
  tearDown(() async {
    await cubit.close();
    await auth.close();
  });

  Future<void> pumpDetail(
    WidgetTester tester,
    String applicationId, {
    DateTime? now,
    Size size = const Size(390, 3600),
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
          BlocProvider<NotificationCubit>.value(
            value: NotificationCubit(entries: NotificationFixtures.entries),
          ),
        ],
        child: MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ApplicationDetailPage(
            applicationId: applicationId,
            now: now ?? openDay,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// [text] inside the card of type [T]: the history logs the same event the
  /// card's headline announces, so the bare string names two widgets.
  Finder titleIn<T extends Widget>(String text) =>
      find.descendant(of: find.byType(T), matching: find.text(text));

  /// The detail of [id] with [change] applied, swapped into the portal before
  /// the page is pumped.
  void replaceDetail(
    String id,
    ApplicationDetail Function(ApplicationDetail) change,
  ) {
    cubit.load();
    final details = {...cubit.state.applicationDetails};
    details[id] = change(details[id]!);
    cubit.emit(cubit.state.copyWith(applicationDetails: details));
  }

  /// A copy of [detail] with a different status and the outcome-specific
  /// fields dropped, as a record with no design yet would arrive.
  ApplicationDetail withStatus(
    ApplicationDetail detail,
    ApplicationStatus status,
  ) => ApplicationDetail(
    application: ApplicationSummary(
      id: detail.application.id,
      programmeName: detail.application.programmeName,
      department: detail.application.department,
      status: status,
      submittedOn: detail.application.submittedOn,
      cycleName: detail.application.cycleName,
      cycleSession: detail.application.cycleSession,
      updatedOn: detail.application.updatedOn,
      trackingCode: detail.application.trackingCode,
    ),
    cycleId: detail.cycleId,
    firstChoiceProgrammeId: detail.firstChoiceProgrammeId,
    history: detail.history,
  );

  group('the offer', () {
    testWidgets('keeps the header and gives the offer one card', (
      tester,
    ) async {
      await pumpDetail(tester, offeredId);

      // Header: the same block a draft opens with, minus the countdown.
      expect(find.byType(ApplicationDetailHeader), findsOneWidget);
      expect(find.text('Admission offered'), findsOneWidget);
      expect(find.text('2026/2027 Undergraduate Admissions'), findsOneWidget);
      expect(find.textContaining('Submit by'), findsNothing);

      expect(find.byType(ApplicationOfferCard), findsOneWidget);
      expect(find.text('ADMISSION OFFERED'), findsOneWidget);
      expect(find.text('B.Sc. Computer Science'), findsOneWidget);
      expect(
        find.text('Department of Computer Science, Faculty of Science'),
        findsOneWidget,
      );
    });

    testWidgets('lists the terms and what has and has not been paid', (
      tester,
    ) async {
      await pumpDetail(tester, offeredId);

      expect(find.text('100 Level'), findsOneWidget);
      expect(find.text('2026/2027'), findsOneWidget);
      expect(find.text('₦7,500.00'), findsOneWidget, reason: 'the form fee');
      expect(find.text('(paid 12 September 2026)'), findsOneWidget);
      expect(find.text('₦5,000.00'), findsOneWidget, reason: 'to be paid');
      expect(find.text('(due after you accept)'), findsOneWidget);
    });

    testWidgets('makes the deadline the loudest block and says what it costs', (
      tester,
    ) async {
      await pumpDetail(tester, offeredId);

      expect(find.byType(OfferDeadlineNotice), findsOneWidget);
      expect(find.text('Accept by 28 February 2027'), findsOneWidget);
      expect(
        find.text(
          'After that date the offer lapses and the place is offered to '
          'somebody else.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('pay the acceptance fee of ₦5,000.00'),
        findsOneWidget,
      );
    });

    testWidgets('offers accept, the letter and decline, and nothing else', (
      tester,
    ) async {
      await pumpDetail(tester, offeredId);

      expect(find.text('Accept offer'), findsOneWidget);
      expect(find.text('Read the admission letter first'), findsOneWidget);
      expect(find.text('Decline offer'), findsOneWidget);
      expect(find.text('Admission letter'), findsOneWidget);

      // An offer is not a form: nothing to tick, upload or withdraw.
      expect(find.byType(ApplicationChecklistRow), findsNothing);
      expect(find.text('Withdraw application'), findsNothing);
      expect(find.byType(ApplicationHistoryCard), findsNothing);
    });

    for (final action in [
      'Accept offer',
      'Decline offer',
      'Read the admission letter first',
      'Admission letter',
    ]) {
      testWidgets('says "$action" is not live yet', (tester) async {
        await pumpDetail(tester, offeredId);

        await tester.tap(find.text(action));
        await tester.pumpAndSettle();

        expect(find.text(comingSoon), findsOneWidget);
      });
    }

    testWidgets('tints the deadline amber', (tester) async {
      await pumpDetail(tester, offeredId);

      final icon = tester.widget<Icon>(
        find.descendant(
          of: find.byType(OfferDeadlineNotice),
          matching: find.byIcon(Icons.schedule_outlined),
        ),
      );
      final context = tester.element(find.byType(OfferDeadlineNotice));
      expect(
        icon.color,
        AppTone.warning.foreground(Theme.of(context).brightness),
      );
    });
  });

  group('the refusal', () {
    testWidgets('opens with its own headline instead of the header', (
      tester,
    ) async {
      await pumpDetail(tester, rejectedId);

      expect(find.byType(ApplicationDetailHeader), findsNothing);
      expect(find.text('CANDIDATE PORTAL • FINAL DECISION'), findsOneWidget);
      // The strip carries the short session; the notice quotes the full name.
      expect(find.text('Cycle 2025/2026'), findsOneWidget);
      expect(
        find.textContaining('2025/2026 Undergraduate Admissions'),
        findsWidgets,
      );
      expect(find.text('PROGRAMME APPLIED'), findsOneWidget);
      expect(find.text('B.A. English'), findsOneWidget);
      expect(
        find.text('Faculty of Arts • Direct Entry / Full-time'),
        findsOneWidget,
        reason: 'the faculty and the mode, not the department',
      );
      expect(
        find.text('Admission unsuccessful'),
        findsOneWidget,
        reason: 'the verdict pill',
      );
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      expect(find.text('Rejected'), findsNothing);
    });

    testWidgets('quotes the facts a candidate gives the registry', (
      tester,
    ) async {
      await pumpDetail(tester, rejectedId);

      expect(find.text('Musa Ibrahim'), findsOneWidget);
      // Twice: once in the bar, once in the banner.
      expect(find.text('APP/2025/00918'), findsNWidgets(2));
      expect(find.text('1 Sep 2025 • 14:22'), findsOneWidget);
      expect(find.text('14 Sep 2026 • 09:00'), findsOneWidget);
    });

    testWidgets('states the finding and the reason in the committee\'s words', (
      tester,
    ) async {
      await pumpDetail(tester, rejectedId);

      expect(
        find.text('Official admissions committee finding'),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'for the 2025/2026 Undergraduate Admissions exercise',
        ),
        findsOneWidget,
      );
      expect(find.text('PRIMARY DETERMINATION'), findsOneWidget);
      expect(
        find.textContaining('Quota capacity exhausted for Department of'),
        findsOneWidget,
      );
    });

    testWidgets('shows each criterion with its outcome and its evidence', (
      tester,
    ) async {
      await pumpDetail(tester, rejectedId);

      expect(find.byType(RejectionCriterionRow), findsNWidgets(3));
      expect(find.text('UTME composite score'), findsOneWidget);
      expect(find.text("O'level English literature"), findsOneWidget);
      expect(find.text('Direct entry accreditation'), findsOneWidget);
      expect(find.text('Below cutoff'), findsOneWidget);
      expect(find.text('Deficit'), findsOneWidget);
      expect(find.text('Incomplete'), findsOneWidget);
      expect(find.text('242 / 400'), findsOneWidget);
      expect(find.text('260'), findsOneWidget);
      expect(find.text('Grade C5'), findsOneWidget);
      expect(find.text('Grade B3'), findsOneWidget);
      expect(
        find.textContaining('Registrar endorsement stamp'),
        findsOneWidget,
        reason: 'a criterion that is not a number quotes the committee',
      );
    });

    testWidgets('draws a bar only for the criterion that is a score', (
      tester,
    ) async {
      await pumpDetail(tester, rejectedId);

      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(bar.value, closeTo(242 / 400, 0.0001));
    });

    testWidgets('attests the notice and says the decision is closed', (
      tester,
    ) async {
      await pumpDetail(tester, rejectedId);

      expect(find.text('Office of the Registrar'), findsOneWidget);
      expect(find.text('SHA256:7b91c...00918e2a'), findsOneWidget);
      expect(find.text('Immutable'), findsOneWidget);
      expect(
        find.textContaining('Re-evaluation within the 2025/2026'),
        findsOneWidget,
      );
    });

    testWidgets('points at the open cycle while there is one', (tester) async {
      await pumpDetail(tester, rejectedId);

      expect(find.byType(ApplicationNextCycleCard), findsOneWidget);
      expect(find.text('2026/2027 CYCLE'), findsOneWidget);
      expect(find.text('Applications are open'), findsOneWidget);
      expect(find.text('Start a new application'), findsOneWidget);
      expect(find.text('Download the decision notice (PDF)'), findsOneWidget);
    });

    testWidgets('drops that card once no cycle is open', (tester) async {
      await pumpDetail(tester, rejectedId, now: closedDay);

      expect(
        find.byType(ApplicationNextCycleCard),
        findsNothing,
        reason: 'a card that says the door is open must not be shown shut',
      );
      expect(find.text('Applications are open'), findsNothing);
    });

    testWidgets('folds the answers until one is asked for', (tester) async {
      await pumpDetail(tester, rejectedId);

      expect(find.byType(ApplicationFaqTile), findsNWidgets(2));
      expect(find.text('Direct entry transcript retrieval'), findsOneWidget);
      expect(
        find.textContaining('remain archived with the Bursary'),
        findsNothing,
      );

      await tester.tap(find.text('Direct entry transcript retrieval'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('remain archived with the Bursary'),
        findsOneWidget,
      );
      expect(
        find.textContaining('falls within the threshold'),
        findsNothing,
        reason: 'the other answer stays folded',
      );
    });

    testWidgets('ends on a way back and a way to a person', (tester) async {
      await pumpDetail(tester, rejectedId);

      expect(find.text('Return to my applications'), findsOneWidget);
      expect(find.text('Admissions help desk'), findsOneWidget);
      expect(find.text('Withdraw application'), findsNothing);
    });

    // "Start a new application" and "Return to my applications" navigate, which
    // a bare `MaterialApp` cannot do; the router test covers them.
    for (final action in [
      'Download the decision notice (PDF)',
      'Admissions help desk',
    ]) {
      testWidgets('says "$action" is not live yet', (tester) async {
        await pumpDetail(tester, rejectedId);

        await tester.ensureVisible(find.text(action));
        await tester.pumpAndSettle();
        await tester.tap(find.text(action));
        await tester.pumpAndSettle();

        expect(find.text(comingSoon), findsOneWidget);
      });
    }

    testWidgets('falls back to the short form without a written decision', (
      tester,
    ) async {
      replaceDetail(
        rejectedId,
        (detail) => withStatus(detail, ApplicationStatus.rejected),
      );

      await pumpDetail(tester, rejectedId);

      expect(find.text('Application not successful'), findsOneWidget);
      expect(
        find.text(
          'Your application to B.A. English was not successful in this round.',
        ),
        findsOneWidget,
      );
      expect(find.text('Browse programmes'), findsOneWidget);
      expect(find.byType(RejectionCriterionRow), findsNothing);
      expect(find.byType(ApplicationHistoryCard), findsOneWidget);
    });
  });

  group('matriculation', () {
    testWidgets('puts the matric number first and the history behind it', (
      tester,
    ) async {
      await pumpDetail(tester, matriculatedId);

      expect(find.byType(ApplicationDetailHeader), findsNothing);
      expect(find.byType(ApplicationMatriculatedCard), findsOneWidget);
      expect(find.text("You're matriculated"), findsOneWidget);
      expect(find.text('25/ACC/0087'), findsOneWidget);
      expect(
        find.text('Use it in all correspondence with the university.'),
        findsOneWidget,
      );
      expect(
        find.text('Your admission is complete. Your student portal is open.'),
        findsOneWidget,
      );
      expect(find.text('Open the student portal'), findsOneWidget);
      expect(find.text('Download your admission letter'), findsOneWidget);
      expect(find.byType(ApplicationHistoryCard), findsOneWidget);
      expect(find.text('Withdraw application'), findsNothing);
    });

    testWidgets('says the letter is not live yet', (tester) async {
      await pumpDetail(tester, matriculatedId);

      await tester.tap(find.text('Download your admission letter'));
      await tester.pumpAndSettle();

      expect(find.text(comingSoon), findsOneWidget);
    });

    testWidgets('sets the number in success green on the badge', (
      tester,
    ) async {
      await pumpDetail(tester, matriculatedId);

      final icon = tester.widget<Icon>(
        find.descendant(
          of: find.byType(ApplicationMatriculatedCard),
          matching: find.byIcon(Icons.school_outlined),
        ),
      );
      final context = tester.element(find.byType(ApplicationMatriculatedCard));
      expect(
        icon.color,
        AppTone.success.foreground(Theme.of(context).brightness),
      );
    });
  });

  group('an offer that expired', () {
    testWidgets('says so in amber, without blaming the candidate', (
      tester,
    ) async {
      await pumpDetail(tester, expiredId);

      expect(find.byType(ApplicationDetailHeader), findsNothing);
      expect(
        titleIn<ApplicationClosedStateCard>('Offer expired'),
        findsOneWidget,
      );
      expect(
        find.text('The offer of B.Sc. Law expired on 28 February 2026.'),
        findsOneWidget,
      );
      expect(
        find.textContaining('The place has been offered to somebody else.'),
        findsOneWidget,
      );
      expect(find.text('Browse programmes'), findsOneWidget);
      expect(find.byType(ApplicationHistoryCard), findsOneWidget);

      final icon = tester.widget<Icon>(
        find.descendant(
          of: find.byType(ApplicationClosedStateCard),
          matching: find.byIcon(Icons.schedule_outlined),
        ),
      );
      final context = tester.element(find.byType(ApplicationClosedStateCard));
      expect(
        icon.color,
        AppTone.warning.foreground(Theme.of(context).brightness),
        reason: 'amber, not red: the deadline passed, nobody did anything',
      );
    });

    testWidgets('quotes no date it was not given', (tester) async {
      replaceDetail(
        expiredId,
        (detail) => withStatus(detail, ApplicationStatus.expired),
      );

      await pumpDetail(tester, expiredId);

      expect(
        titleIn<ApplicationClosedStateCard>('Offer expired'),
        findsOneWidget,
      );
      expect(find.textContaining('expired on'), findsNothing);
    });
  });

  group('a withdrawn application', () {
    testWidgets('restates the decision and quotes the reason', (tester) async {
      await pumpDetail(tester, withdrawnId);

      expect(find.byType(ApplicationDetailHeader), findsNothing);
      expect(
        titleIn<ApplicationClosedStateCard>('Application withdrawn'),
        findsOneWidget,
      );
      expect(
        find.text('You withdrew this application on 14 September 2026.'),
        findsOneWidget,
      );
      expect(
        find.text('“Reason: I accepted a place at another university.”'),
        findsOneWidget,
      );
      expect(
        find.text('You can start a new application in any open cycle.'),
        findsOneWidget,
      );
      expect(find.text('Start a new application'), findsOneWidget);
      expect(find.byType(ApplicationHistoryCard), findsOneWidget);
    });

    testWidgets('offers nothing left to withdraw', (tester) async {
      await pumpDetail(tester, withdrawnId);

      expect(find.text('Withdraw application'), findsNothing);
    });

    testWidgets('leaves the reason out when none was given', (tester) async {
      replaceDetail(
        withdrawnId,
        (detail) => ApplicationDetail(
          application: detail.application,
          cycleId: detail.cycleId,
          firstChoiceProgrammeId: detail.firstChoiceProgrammeId,
          history: detail.history,
          withdrawal: WithdrawalRecord(withdrawnOn: DateTime(2026, 9, 14)),
        ),
      );

      await pumpDetail(tester, withdrawnId);

      expect(find.textContaining('Reason:'), findsNothing);
      expect(
        titleIn<ApplicationClosedStateCard>('Application withdrawn'),
        findsOneWidget,
      );
    });
  });

  group('a status with no design yet', () {
    for (final status in [
      ApplicationStatus.submitted,
      ApplicationStatus.underReview,
      ApplicationStatus.accepted,
      ApplicationStatus.declined,
    ]) {
      testWidgets('shows the header and the history for $status', (
        tester,
      ) async {
        replaceDetail(offeredId, (detail) => withStatus(detail, status));

        await pumpDetail(tester, offeredId);

        expect(find.byType(ApplicationDetailHeader), findsOneWidget);
        expect(find.byType(ApplicationHistoryCard), findsOneWidget);
        expect(find.byType(ApplicationOfferCard), findsNothing);
        expect(find.byType(ApplicationChecklistRow), findsNothing);
      });
    }
  });

  group('every status', () {
    for (final id in [
      offeredId,
      rejectedId,
      matriculatedId,
      expiredId,
      withdrawnId,
    ]) {
      for (final width in [320.0, 390.0, 768.0]) {
        testWidgets('$id fits a $width px viewport without overflowing', (
          tester,
        ) async {
          await pumpDetail(tester, id, size: Size(width, 4200));

          expect(tester.takeException(), isNull);
        });
      }

      testWidgets('$id renders in dark mode too', (tester) async {
        await pumpDetail(tester, id, dark: true);

        expect(tester.takeException(), isNull);
      });
    }

    test('the fixtures give each of those statuses a detail screen', () {
      final statuses = {
        for (final detail in AdmissionsFixtures.applicationDetails.values)
          detail.application.status,
      };

      expect(
        statuses,
        containsAll([
          ApplicationStatus.draft,
          ApplicationStatus.offered,
          ApplicationStatus.rejected,
          ApplicationStatus.matriculated,
          ApplicationStatus.expired,
          ApplicationStatus.withdrawn,
        ]),
      );
    });
  });
}
