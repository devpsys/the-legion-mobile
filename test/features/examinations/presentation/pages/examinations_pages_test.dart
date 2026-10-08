import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:the_legion_mobile/features/examinations/presentation/bloc/exam_card_verification_cubit.dart';
import 'package:the_legion_mobile/features/examinations/presentation/bloc/examinations_cubit.dart';
import 'package:the_legion_mobile/features/examinations/presentation/mock/examinations_fixtures.dart';
import 'package:the_legion_mobile/features/examinations/presentation/models/examinations_models.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/examination_card_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/resits_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/results_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/verify_exam_card_page.dart';

import '../../../../helpers/signed_in_auth_cubit.dart';

void main() {
  late AuthCubit auth;

  setUp(() async {
    auth = await signedInAuthCubit();
  });

  tearDown(() async {
    await auth.close();
  });

  Future<ExaminationsCubit> pumpAt(
    WidgetTester tester,
    String location, {
    ExaminationsLedger? ledger,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 3600) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final cubit = ExaminationsCubit(ledger: ledger);
    addTearDown(cubit.close);

    final router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(
          path: Routes.examinations,
          name: Routes.examinationsName,
          builder: (_, _) => const ResultsPage(),
        ),
        GoRoute(
          path: Routes.examinationsCard,
          name: Routes.examinationsCardName,
          builder: (_, _) => const ExaminationCardPage(),
        ),
        GoRoute(
          path: Routes.examinationsResits,
          name: Routes.examinationsResitsName,
          builder: (_, _) => const ResitsPage(),
        ),
        GoRoute(
          path: Routes.fees,
          name: Routes.feesName,
          builder: (_, _) => const Text('fees'),
        ),
        GoRoute(
          path: Routes.profile,
          name: Routes.profileName,
          builder: (_, _) => const Text('profile'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ExaminationsCubit>.value(value: cubit),
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
    return cubit;
  }

  group('results', () {
    testWidgets('shows the published term, the CGPA and good standing', (
      tester,
    ) async {
      await pumpAt(tester, Routes.examinations);

      expect(tester.takeException(), isNull);
      expect(find.text('Structured Programming'), findsOneWidget);
      expect(find.text('Computer Programming I'), findsOneWidget);
      expect(find.textContaining('3.62'), findsWidgets);
      expect(find.text('Good standing'), findsWidgets);
    });

    testWidgets('marks the held-back and unmarked courses', (tester) async {
      await pumpAt(tester, Routes.examinations);

      expect(find.text('CSC 305'), findsOneWidget);
      expect(find.textContaining('held back'), findsOneWidget);
      expect(find.text('Operating Systems I'), findsOneWidget);
    });

    testWidgets('puts a student on probation at CGPA 1.84', (tester) async {
      await pumpAt(
        tester,
        Routes.examinations,
        ledger: ExaminationsFixtures.probationLedger,
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('1.84'), findsWidgets);
      expect(find.text('On probation'), findsWidgets);
      expect(
        find.textContaining('Speak to your level adviser'),
        findsOneWidget,
      );
      expect(find.text('Dr. Ibrahim Sani'), findsOneWidget);
      expect(find.text('Book urgent advising session'), findsOneWidget);
    });

    testWidgets('shows the empty state while nothing is published', (
      tester,
    ) async {
      await pumpAt(
        tester,
        Routes.examinations,
        ledger: ExaminationsFixtures.unpublishedLedger,
      );

      expect(find.text('No results published yet'), findsOneWidget);
      expect(find.text('Structured Programming'), findsNothing);
    });
  });

  group('examination card', () {
    testWidgets('not issued names the fees as what is in the way', (
      tester,
    ) async {
      await pumpAt(
        tester,
        Routes.examinationsCard,
        ledger: ExaminationsFixtures.cardNotIssuedLedger,
      );

      expect(find.text("You don't have a card yet"), findsOneWidget);
      expect(find.textContaining('Pay at least'), findsWidgets);
      expect(find.text('All clearance gates'), findsOneWidget);
      expect(find.text('Blocking issue'), findsOneWidget);
    });

    testWidgets('issued shows the card number and check code', (tester) async {
      await pumpAt(
        tester,
        Routes.examinationsCard,
        ledger: ExaminationsFixtures.cardIssuedLedger,
      );

      expect(find.text(ExaminationsFixtures.cardNumber), findsWidgets);
      expect(find.text('Timetabled papers'), findsOneWidget);
    });

    testWidgets('print is a coming-soon message', (tester) async {
      await pumpAt(
        tester,
        Routes.examinationsCard,
        ledger: ExaminationsFixtures.cardIssuedLedger,
      );

      await tester.ensureVisible(find.text('Print card'));
      await tester.tap(find.text('Print card'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('revoked says the card is withdrawn', (tester) async {
      await pumpAt(
        tester,
        Routes.examinationsCard,
        ledger: ExaminationsFixtures.cardRevokedLedger,
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Revoked'), findsWidgets);
    });
  });

  group('resits', () {
    testWidgets('open shows the unit allowance and the failed courses', (
      tester,
    ) async {
      await pumpAt(tester, Routes.examinationsResits);

      expect(find.text('Both count'), findsOneWidget);
      expect(find.text('3 of 6 units used'), findsOneWidget);
      expect(find.textContaining('CSC 211'), findsWidgets);
    });

    testWidgets('registering confirms, then moves the course to registered', (
      tester,
    ) async {
      final cubit = await pumpAt(tester, Routes.examinationsResits);

      await tester.ensureVisible(find.text('Register').first);
      await tester.tap(find.text('Register').first);
      await tester.pumpAndSettle();
      expect(find.text('STATUTORY ACADEMIC POLICY'), findsOneWidget);

      await tester.tap(find.text('Register').last);
      await tester.pumpAndSettle();

      expect(cubit.state.resits!.registrations, hasLength(2));
      expect(find.text('3 of 6 units used'), findsNothing);
    });

    testWidgets('closed lists failures as not open', (tester) async {
      await pumpAt(
        tester,
        Routes.examinationsResits,
        ledger: ExaminationsFixtures.resitsClosedLedger,
      );

      expect(find.text('Not open'), findsWidgets);
      expect(find.text('Register'), findsNothing);
    });
  });

  group('public exam card check', () {
    Future<void> pumpVerify(WidgetTester tester, {String? code}) async {
      final cubit = ExamCardVerificationCubit();
      addTearDown(cubit.close);

      final router = GoRouter(
        initialLocation: Routes.verifyExamCard,
        routes: [
          GoRoute(
            path: Routes.verifyExamCard,
            name: Routes.verifyExamCardName,
            builder: (_, _) => BlocProvider<ExamCardVerificationCubit>.value(
              value: cubit,
              child: VerifyExamCardPage(initialCode: code),
            ),
          ),
          GoRoute(
            path: Routes.login,
            name: Routes.loginName,
            builder: (_, _) => const Text('login'),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MaterialApp.router(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('a valid code shows five facts and no photo', (tester) async {
      await pumpVerify(tester, code: ExaminationsFixtures.validCheckCode);

      expect(find.text('Valid card'), findsOneWidget);
      expect(find.text('Amaka Bello'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('an unknown code is not found', (tester) async {
      await pumpVerify(tester, code: 'ZZZZZZZZZZZZ');

      expect(find.text('No card matches this code.'), findsOneWidget);
    });

    testWidgets('no code waits for one', (tester) async {
      await pumpVerify(tester);

      expect(find.text('Check an examination card'), findsOneWidget);
      expect(find.text('Valid card'), findsNothing);
    });
  });
}
