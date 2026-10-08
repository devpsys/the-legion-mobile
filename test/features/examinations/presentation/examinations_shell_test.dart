import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/features/examinations/presentation/widgets/examinations_shell.dart';
import 'package:the_legion_mobile/features/examinations/presentation/widgets/staff/exam_office_shell.dart';

void main() {
  group('examinationsBackTarget', () {
    test('leaves the results tab for the student hub', () {
      expect(examinationsBackTarget(Routes.examinations), Routes.homeName);
    });

    test('unwinds the card and resits tabs to results', () {
      for (final location in [
        Routes.examinationsCard,
        Routes.examinationsResits,
      ]) {
        expect(
          examinationsBackTarget(location),
          Routes.examinationsName,
          reason: location,
        );
      }
    });
  });

  group('examOfficeBackTarget', () {
    test('leaves every list for the student hub', () {
      for (final location in [
        Routes.examOfficeResults,
        Routes.examOfficeSessions,
        Routes.examOfficeGrading,
        Routes.examOfficeIncidents,
        Routes.examOfficeResits,
        Routes.examOfficeBroadsheets,
      ]) {
        expect(
          examOfficeBackTarget(location).name,
          Routes.homeName,
          reason: location,
        );
      }
    });

    test('unwinds a course sheet to the results queue', () {
      expect(
        examOfficeBackTarget(Routes.examOfficeResultsCourse('RB-2026-00412'))
            .name,
        Routes.examOfficeResultsName,
      );
    });

    test('unwinds a session to the sessions list', () {
      expect(
        examOfficeBackTarget(Routes.examOfficeSession('ses-2025-2')).name,
        Routes.examOfficeSessionsName,
      );
    });

    test('unwinds a paper to its own session, not the list', () {
      final target = examOfficeBackTarget(
        Routes.examOfficePaper('ses-2025-2', 'p-csc301'),
      );

      expect(target.name, Routes.examOfficeSessionName);
      expect(target.pathParameters, {
        Routes.examOfficeSessionIdParam: 'ses-2025-2',
      });
    });

    test('unwinds a scale to the grading list', () {
      expect(
        examOfficeBackTarget(Routes.examOfficeGradingScale('sc-pg')).name,
        Routes.examOfficeGradingName,
      );
    });

    test('unwinds the import and an incident to the incidents list', () {
      expect(
        examOfficeBackTarget(Routes.examOfficeIncidentImport).name,
        Routes.examOfficeIncidentsName,
      );
      expect(
        examOfficeBackTarget(Routes.examOfficeIncident('EI-2026-00042')).name,
        Routes.examOfficeIncidentsName,
      );
    });

    test('unwinds the open-a-window form to the resit windows', () {
      expect(
        examOfficeBackTarget(Routes.examOfficeResitsOpen).name,
        Routes.examOfficeResitsName,
      );
    });

    test('unwinds a dossier to the broadsheets', () {
      expect(
        examOfficeBackTarget(Routes.examOfficeDossier('25/CSC/0104')).name,
        Routes.examOfficeBroadsheetsName,
      );
    });
  });
}
