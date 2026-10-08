import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/examinations/presentation/bloc/staff/exam_office_cubit.dart';
import 'package:the_legion_mobile/features/examinations/presentation/mock/staff/exam_office_fixtures.dart';
import 'package:the_legion_mobile/features/examinations/presentation/models/staff/exam_office_models.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_broadsheets_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_course_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_dossier_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_grading_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_incident_import_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_incident_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_incidents_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_open_resit_window_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_paper_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_resits_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_results_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_scale_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_session_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/pages/staff/exam_office_sessions_page.dart';
import 'package:the_legion_mobile/features/examinations/presentation/widgets/staff/exam_office_shell.dart';

void main() {
  Future<ExamOfficeCubit> pumpAt(WidgetTester tester, String location) async {
    tester.view
      ..physicalSize = const Size(390, 4000) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final cubit = ExamOfficeCubit();
    addTearDown(cubit.close);

    GoRoute route(
      String path,
      String name,
      Widget Function(GoRouterState s) b,
    ) {
      return GoRoute(path: path, name: name, builder: (_, s) => b(s));
    }

    final router = GoRouter(
      initialLocation: location,
      routes: [
        ShellRoute(
          builder: (context, state, child) => ExamOfficeShell(
            location: state.matchedLocation,
            child: BlocProvider<ExamOfficeCubit>.value(
              value: cubit,
              child: child,
            ),
          ),
          routes: [
            route(
              Routes.examOfficeResults,
              Routes.examOfficeResultsName,
              (_) => const ExamOfficeResultsPage(),
            ),
            route(
              Routes.examOfficeResultsCourseTemplate,
              Routes.examOfficeResultsCourseName,
              (s) => ExamOfficeCoursePage(
                batchId: s.pathParameters[Routes.examOfficeBatchIdParam]!,
              ),
            ),
            route(
              Routes.examOfficeSessions,
              Routes.examOfficeSessionsName,
              (_) => const ExamOfficeSessionsPage(),
            ),
            route(
              Routes.examOfficeSessionTemplate,
              Routes.examOfficeSessionName,
              (s) => ExamOfficeSessionPage(
                sessionId: s.pathParameters[Routes.examOfficeSessionIdParam]!,
              ),
            ),
            route(
              Routes.examOfficePaperTemplate,
              Routes.examOfficePaperName,
              (s) => ExamOfficePaperPage(
                sessionId: s.pathParameters[Routes.examOfficeSessionIdParam]!,
                paperId: s.pathParameters[Routes.examOfficePaperIdParam]!,
              ),
            ),
            route(
              Routes.examOfficeGrading,
              Routes.examOfficeGradingName,
              (_) => const ExamOfficeGradingPage(),
            ),
            route(
              Routes.examOfficeGradingScaleTemplate,
              Routes.examOfficeGradingScaleName,
              (s) => ExamOfficeScalePage(
                scaleId: s.pathParameters[Routes.examOfficeScaleIdParam]!,
              ),
            ),
            route(
              Routes.examOfficeIncidents,
              Routes.examOfficeIncidentsName,
              (_) => const ExamOfficeIncidentsPage(),
            ),
            route(
              Routes.examOfficeIncidentImport,
              Routes.examOfficeIncidentImportName,
              (_) => const ExamOfficeIncidentImportPage(),
            ),
            route(
              Routes.examOfficeIncidentTemplate,
              Routes.examOfficeIncidentName,
              (s) => ExamOfficeIncidentPage(
                incidentId: s.pathParameters[Routes.examOfficeIncidentIdParam]!,
              ),
            ),
            route(
              Routes.examOfficeResits,
              Routes.examOfficeResitsName,
              (_) => const ExamOfficeResitsPage(),
            ),
            route(
              Routes.examOfficeResitsOpen,
              Routes.examOfficeResitsOpenName,
              (_) => const ExamOfficeOpenResitWindowPage(),
            ),
            route(
              Routes.examOfficeBroadsheets,
              Routes.examOfficeBroadsheetsName,
              (_) => const ExamOfficeBroadsheetsPage(),
            ),
            route(
              Routes.examOfficeDossierTemplate,
              Routes.examOfficeDossierName,
              (s) => ExamOfficeDossierPage(
                matric: s.pathParameters[Routes.examOfficeMatricParam]!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: Routes.home,
          name: Routes.homeName,
          builder: (_, _) => const Text('home'),
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
    return cubit;
  }

  group('every staff screen renders', () {
    final locations = <String, String>{
      'results queue': Routes.examOfficeResults,
      'course sheet': Routes.examOfficeResultsCourse('RB-2026-00412'),
      'sent-back sheet': Routes.examOfficeResultsCourse('RB-2026-00389'),
      'locked sheet': Routes.examOfficeResultsCourse('RB-2026-00405'),
      'published sheet': Routes.examOfficeResultsCourse('RB-2026-00301'),
      'sessions': Routes.examOfficeSessions,
      'session': Routes.examOfficeSession('ses-2025-2'),
      'paper': Routes.examOfficePaper('ses-2025-2', 'p-csc305'),
      'grading': Routes.examOfficeGrading,
      'incidents': Routes.examOfficeIncidents,
      'import': Routes.examOfficeIncidentImport,
      'incident': Routes.examOfficeIncident('EI-2026-00042'),
      'resit windows': Routes.examOfficeResits,
      'open a window': Routes.examOfficeResitsOpen,
      'broadsheets': Routes.examOfficeBroadsheets,
      'dossier': Routes.examOfficeDossier('25/CSC/0104'),
    };

    for (final entry in locations.entries) {
      testWidgets(entry.key, (tester) async {
        await pumpAt(tester, entry.value);

        expect(tester.takeException(), isNull);
        expect(find.text('Examinations office'), findsOneWidget);
      });
    }
  });

  group('results', () {
    testWidgets('sending with unmarked students is blocked and says who', (
      tester,
    ) async {
      final cubit = await pumpAt(
        tester,
        Routes.examOfficeResultsCourse('RB-2026-00412'),
      );

      await tester.ensureVisible(find.text('Send for approval'));
      await tester.tap(find.text('Send for approval'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send').last);
      await tester.pumpAndSettle();

      expect(
        cubit.state.batchById('RB-2026-00412')!.stage,
        ResultsStage.beingMarked,
      );
      expect(cubit.state.blockedSendBatchId, 'RB-2026-00412');
      expect(find.text('4 students have no mark'), findsOneWidget);
    });

    testWidgets('a sent-back course shows the head of department note', (
      tester,
    ) async {
      await pumpAt(tester, Routes.examOfficeResultsCourse('RB-2026-00389'));

      expect(find.textContaining('sent this back'), findsOneWidget);
    });

    testWidgets('a course with the approvers is locked', (tester) async {
      await pumpAt(tester, Routes.examOfficeResultsCourse('RB-2026-00405'));

      expect(find.textContaining('The marks are locked'), findsOneWidget);
      expect(find.text('Send for approval'), findsNothing);
    });
  });

  group('papers', () {
    testWidgets('a partly seated paper offers a room to add', (tester) async {
      await pumpAt(tester, Routes.examOfficePaper('ses-2025-2', 'p-csc305'));

      expect(find.textContaining('have no seat'), findsOneWidget);
      expect(find.textContaining('Add Faculty LT-1'), findsOneWidget);
    });

    testWidgets('a paper that has been sat cannot be cancelled', (
      tester,
    ) async {
      await pumpAt(tester, Routes.examOfficePaper('ses-2025-2', 'p-phy201'));

      expect(find.textContaining('can no longer be cancelled'), findsOneWidget);
      final cancel = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Cancel the paper'),
      );
      expect(cancel.onPressed, isNull);
    });
  });

  group('sessions', () {
    testWidgets('a semester with no session offers to open one', (
      tester,
    ) async {
      final cubit = await pumpAt(tester, Routes.examOfficeSessions);

      await tester.tap(find.text(ExamOfficeFixtures.emptyTerm));
      await tester.pumpAndSettle();

      expect(find.textContaining('No session for'), findsOneWidget);
      expect(find.text('Open a session'), findsOneWidget);
      expect(cubit.state.sessionsForTerm, isEmpty);
    });

    testWidgets('the session detail shows its clashes', (tester) async {
      await pumpAt(tester, Routes.examOfficeSession('ses-2025-2'));

      expect(find.text('Clashes'), findsWidgets);
      expect(find.textContaining('at the same time'), findsWidgets);
    });
  });

  group('grading', () {
    testWidgets('the broken scale says marks have no grade', (tester) async {
      await pumpAt(
        tester,
        Routes.examOfficeGradingScale(
          ExamOfficeFixtures.ledger.scales.firstWhere((s) => s.hasGap).id,
        ),
      );

      expect(find.text('Some marks have no grade'), findsOneWidget);
    });
  });

  group('incidents', () {
    testWidgets('a dry run shows row errors and writes nothing', (
      tester,
    ) async {
      final cubit = await pumpAt(tester, Routes.examOfficeIncidentImport);
      final before = cubit.state.incidents.length;

      await tester.ensureVisible(find.text('Run a dry run'));
      await tester.tap(find.text('Run a dry run'));
      await tester.pumpAndSettle();

      expect(cubit.state.importStatus, ImportStatus.dryRun);
      expect(find.textContaining('nothing is written yet'), findsOneWidget);
      expect(find.text('Leave out'), findsWidgets);
      expect(cubit.state.incidents, hasLength(before));
    });

    testWidgets('an incident holding a mark says so', (tester) async {
      await pumpAt(tester, Routes.examOfficeIncident('EI-2026-00042'));

      expect(find.text('A mark is held back'), findsOneWidget);
    });
  });

  group('resits', () {
    testWidgets('lists the open and the closed window', (tester) async {
      await pumpAt(tester, Routes.examOfficeResits);

      expect(find.text('Open'), findsWidgets);
      expect(find.text('Closed'), findsWidgets);
    });

    testWidgets('the form refuses a close date before the open date', (
      tester,
    ) async {
      final cubit = await pumpAt(tester, Routes.examOfficeResitsOpen);
      final before = cubit.state.windows.length;

      await tester.enterText(find.byType(TextField).first, 'Harmattan resits');
      await tester.enterText(find.byType(TextField).last, '2000');
      await tester.tap(find.text('Open a window').last);
      await tester.pumpAndSettle();

      expect(find.text('Choose a date.'), findsWidgets);
      expect(cubit.state.windows, hasLength(before));
    });
  });

  group('broadsheet', () {
    testWidgets('a student with a dossier leads to it', (tester) async {
      await pumpAt(tester, Routes.examOfficeBroadsheets);

      expect(tester.takeException(), isNull);
      expect(find.text('Pass rate'), findsOneWidget);
    });

    testWidgets('the dossier calls a held mark provisional', (tester) async {
      await pumpAt(tester, Routes.examOfficeDossier('25/CSC/0104'));

      expect(find.text('Provisional result'), findsOneWidget);
    });
  });

  group('back', () {
    testWidgets('a list leaves for the hub', (tester) async {
      await pumpAt(tester, Routes.examOfficeResults);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('a paper unwinds to its session, then to the list', (
      tester,
    ) async {
      await pumpAt(tester, Routes.examOfficePaper('ses-2025-2', 'p-csc305'));

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Papers'), findsWidgets);
      expect(find.text('Seating'), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Examination sessions'), findsWidgets);
    });
  });
}
