import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/admissions_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/pages/admissions_overview_page.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_tab_bar.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admissions_task_bar.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/announcements_section.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/applicant_strip.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/application_summary_card.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/applications_empty_state.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/applications_section.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/email_confirmation_banner.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/jamb_claim_card.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/overview_body.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';

import '../../../helpers/signed_in_auth_cubit.dart';

void main() {
  late AdmissionsCubit cubit;
  late AuthCubit auth;

  /// 1 October 2026, mid-afternoon: two cycles open, afternoon greeting.
  final now = DateTime(2026, 10, 1, 14, 20);

  setUp(() async {
    cubit = AdmissionsCubit();
    auth = await signedInAuthCubit();
  });
  tearDown(() async {
    await cubit.close();
    await auth.close();
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    Size size = const Size(390, 1500),
    DateTime? at,
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
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AdmissionsOverviewPage(now: at ?? now),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('chrome', () {
    testWidgets('names the cycle in the bar and badges the bell', (
      tester,
    ) async {
      await pumpPage(tester);

      expect(find.byType(AdmissionsTaskBar), findsOneWidget);
      expect(find.text('2026/2027 Cycle'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('offers the four portal tabs, with overview selected', (
      tester,
    ) async {
      await pumpPage(tester);

      expect(find.byType(AdmissionsTabBar), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Programmes'), findsOneWidget);
      expect(find.text('Applications'), findsOneWidget);
      expect(find.text('JAMB'), findsOneWidget);
    });

    testWidgets('badges the JAMB tab while a claim is pending', (tester) async {
      await pumpPage(tester);

      final jambTab = tester.widget<AdmissionsTab>(
        find
            .ancestor(
              of: find.text('JAMB'),
              matching: find.byType(AdmissionsTab),
            )
            .first,
      );

      expect(jambTab.hasBadge, isTrue);
    });
  });

  group('identity', () {
    testWidgets('greets the candidate and shows the address', (tester) async {
      await pumpPage(tester);

      expect(find.byType(ApplicantStrip), findsOneWidget);
      expect(find.text('APPLICANT'), findsOneWidget);
      expect(find.text('Good afternoon, Musa'), findsOneWidget);
      expect(find.text('amusa.ibrahim@example.com'), findsOneWidget);
    });
  });

  group('the confirmation gate', () {
    testWidgets('appears with the address spelled out', (tester) async {
      await pumpPage(tester);

      expect(find.byType(EmailConfirmationBanner), findsOneWidget);
      expect(
        find.textContaining('amusa.ibrahim@example.com'),
        findsWidgets,
        reason: 'the banner names the address it is about',
      );
      expect(find.text('Resend link'), findsOneWidget);
    });

    testWidgets('can be dismissed for the session', (tester) async {
      await pumpPage(tester);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(EmailConfirmationBanner), findsNothing);
      expect(cubit.state.needsEmailConfirmation, isFalse);
    });

    testWidgets('confirms itself once the link is sent', (tester) async {
      await pumpPage(tester);

      await tester.tap(find.text('Resend link'));
      await tester.pumpAndSettle();

      expect(
        find.text('Confirmation link sent. Check your inbox.'),
        findsOneWidget,
      );
      expect(cubit.state.hasSentEmailLink, isTrue);
    });
  });

  group('applications', () {
    testWidgets('offers Apply and explains the empty state', (tester) async {
      // The fixture carries the candidate's three applications; the empty
      // state is what the section shows when there are none, so the list is
      // cleared to reach it.
      cubit.load();
      cubit.emit(cubit.state.copyWith(applications: []));

      await pumpPage(tester);

      expect(find.byType(ApplicationsSection), findsOneWidget);
      expect(find.text('Your applications'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);
      expect(find.byType(ApplicationsEmptyState), findsOneWidget);
      expect(find.text('No applications yet'), findsOneWidget);
      expect(
        find.text('2 admission cycles are open. Browse programmes to apply.'),
        findsOneWidget,
      );
      expect(find.text('Browse programmes'), findsOneWidget);
    });

    testWidgets('uses the singular when one cycle is open', (tester) async {
      // 10 February: the postgraduate cycle has closed, the undergraduate has not.
      cubit.load();
      cubit.emit(cubit.state.copyWith(applications: []));

      await pumpPage(tester, at: DateTime(2027, 2, 10));

      expect(
        find.text('1 admission cycle is open. Browse programmes to apply.'),
        findsOneWidget,
      );
    });

    testWidgets('lists every application on the record', (tester) async {
      await pumpPage(tester);

      expect(
        find.byType(ApplicationSummaryCard),
        findsNWidgets(4),
        reason: 'the overview is a summary of the same record the tab lists',
      );
      expect(find.text('Admission offered'), findsOneWidget);
      // The draft sits second: a record in progress is as much a record as
      // one that has been answered.
      expect(find.text('Draft'), findsOneWidget);
      expect(find.text('Rejected'), findsOneWidget);
      expect(find.text('Matriculated'), findsOneWidget);
      expect(find.byType(ApplicationsEmptyState), findsNothing);
    });

    testWidgets('carries the reference each card is filed under', (
      tester,
    ) async {
      cubit.load();
      cubit.emit(
        cubit.state.copyWith(
          applications: [AdmissionsFixtures.sampleApplication],
        ),
      );

      await pumpPage(tester);

      expect(find.byType(ApplicationSummaryCard), findsOneWidget);
      expect(find.text('Under review'), findsOneWidget);
      expect(find.text('APP/2026/00014'), findsOneWidget);
    });
  });

  group('the JAMB claim', () {
    testWidgets('is the screen\'s primary action', (tester) async {
      await pumpPage(tester);

      expect(find.byType(JambClaimCard), findsOneWidget);
      expect(find.text('JAMB CAPS IMPORT'), findsOneWidget);
      expect(find.text('You chose us in JAMB'), findsOneWidget);
      expect(find.text('Claim your result'), findsOneWidget);
    });
  });

  group('bulletins', () {
    testWidgets('renders both with their category stripes', (tester) async {
      await pumpPage(tester, size: const Size(390, 2400));

      expect(find.byType(AnnouncementsSection), findsOneWidget);
      expect(find.text('Extended application deadline'), findsOneWidget);
      expect(find.text('JAMB results received'), findsOneWidget);
      expect(find.text('See all'), findsOneWidget);
      expect(find.text('Read more'), findsNWidgets(2));
    });
  });

  group('the loaded body', () {
    testWidgets('renders every section in the design\'s order', (tester) async {
      await pumpPage(tester, size: const Size(390, 2400));

      expect(find.byType(OverviewBody), findsOneWidget);

      double y(Type type) => tester.getTopLeft(find.byType(type)).dy;
      expect(
        y(ApplicantStrip),
        lessThan(y(ApplicationsSection)),
        reason: 'identity first',
      );
      expect(
        y(EmailConfirmationBanner),
        lessThan(y(ApplicationsSection)),
        reason: 'the gate explains what is blocked, above the list',
      );
      expect(
        y(JambClaimCard),
        lessThan(y(AnnouncementsSection)),
        reason: 'the pending claim outranks the bulletin board',
      );
    });

    testWidgets('hides the JAMB card once nothing is pending', (tester) async {
      cubit.load();
      cubit.emit(cubit.state.copyWith(jambResultPending: false));

      await pumpPage(tester);

      expect(find.byType(JambClaimCard), findsNothing);
      expect(find.byType(AnnouncementsSection), findsOneWidget);
    });
  });
}
