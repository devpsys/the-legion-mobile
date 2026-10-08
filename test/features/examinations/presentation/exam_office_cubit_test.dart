import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/examinations/presentation/bloc/staff/exam_office_cubit.dart';
import 'package:the_legion_mobile/features/examinations/presentation/bloc/staff/exam_office_state.dart';
import 'package:the_legion_mobile/features/examinations/presentation/mock/staff/exam_office_fixtures.dart';
import 'package:the_legion_mobile/features/examinations/presentation/models/staff/exam_office_models.dart';

void main() {
  ExamOfficeCubit started() => ExamOfficeCubit()..load();

  const markedCourse = 'RB-2026-00412';

  test('loads the office with the live semester selected', () {
    final cubit = started();

    expect(cubit.state.status, ExamOfficeStatus.ready);
    expect(cubit.state.selectedTerm, ExamOfficeFixtures.term);
    expect(cubit.state.batches, isNotEmpty);
  });

  group('sending marks', () {
    test('cannot send while a student has no mark', () {
      final cubit = started();
      final batch = cubit.state.batchById(markedCourse)!;
      expect(batch.unmarkedCount, greaterThan(0));

      expect(cubit.sendForApproval(markedCourse), isFalse);

      expect(
        cubit.state.batchById(markedCourse)!.stage,
        ResultsStage.beingMarked,
      );
      expect(cubit.state.blockedSendBatchId, markedCourse);
      expect(cubit.state.notice, ExamOfficeNotice.sendBlocked);
    });

    test('can send once every student has a mark or a hold', () {
      final cubit = started();
      final unmarked = cubit.state.batchById(markedCourse)!.unmarkedEntries;

      for (var i = 0; i < unmarked.length; i++) {
        final entry = unmarked[i];
        if (i.isEven) {
          cubit.setMarks(markedCourse, entry.matric, coursework: 20, exam: 40);
        } else {
          cubit.holdMark(markedCourse, entry.matric, 'Awaiting a hearing');
        }
      }

      expect(cubit.sendForApproval(markedCourse), isTrue);
      expect(
        cubit.state.batchById(markedCourse)!.stage,
        ResultsStage.withApprovers,
      );
      expect(cubit.state.notice, ExamOfficeNotice.sentForApproval);
    });

    test('a half-entered mark still counts as missing', () {
      final cubit = started();
      final unmarked = cubit.state.batchById(markedCourse)!.unmarkedEntries;

      for (final entry in unmarked) {
        cubit.setMarks(markedCourse, entry.matric, coursework: 20);
      }

      expect(cubit.sendForApproval(markedCourse), isFalse);
    });

    test('refuses a mark outside its range', () {
      final cubit = started();
      final entry = cubit.state.batchById(markedCourse)!.unmarkedEntries.first;

      expect(
        cubit.setMarks(markedCourse, entry.matric, coursework: 31, exam: 10),
        isFalse,
      );
      expect(
        cubit.setMarks(markedCourse, entry.matric, coursework: 10, exam: 71),
        isFalse,
      );
    });

    test('locks the marks once they are with the approvers', () {
      final cubit = started();
      final batch = cubit.state.batches.firstWhere(
        (entry) => entry.stage == ResultsStage.withApprovers,
      );

      expect(
        cubit.setMarks(batch.id, batch.entries.first.matric, coursework: 1),
        isFalse,
      );
      expect(cubit.sendForApproval(batch.id), isFalse);
    });
  });

  group('papers', () {
    ExamPaper paper(ExamOfficeCubit cubit, String id) =>
        cubit.state.sessionById('ses-2025-2')!.paperById(id)!;

    test('a paper that has been sat cannot be cancelled', () {
      final cubit = started();

      final cancelled = cubit.setPaperStatus(
        'ses-2025-2',
        'p-phy201',
        PaperStatus.cancelled,
        reason: 'Venue flooded',
      );

      expect(cancelled, isFalse);
      expect(paper(cubit, 'p-phy201').status, PaperStatus.sat);
      expect(cubit.state.notice, ExamOfficeNotice.cancelLocked);
    });

    test('cancelling needs a reason', () {
      final cubit = started();

      expect(
        cubit.setPaperStatus('ses-2025-2', 'p-mth201', PaperStatus.cancelled),
        isFalse,
      );
      expect(cubit.state.notice, ExamOfficeNotice.cancelReasonRequired);
    });

    test('a paper that has not been sat can be cancelled', () {
      final cubit = started();

      expect(
        cubit.setPaperStatus(
          'ses-2025-2',
          'p-mth201',
          PaperStatus.cancelled,
          reason: 'Examiner unavailable',
        ),
        isTrue,
      );
      expect(paper(cubit, 'p-mth201').status, PaperStatus.cancelled);
    });

    test('adding a room seats the candidates who had no seat', () {
      final cubit = started();
      final before = paper(cubit, 'p-csc305');
      expect(before.seating, SeatingStatus.partial);

      final room = cubit.state.overflowRooms.first;
      expect(cubit.addRoom('ses-2025-2', 'p-csc305', room.name), isTrue);

      final after = paper(cubit, 'p-csc305');
      expect(after.seated, greaterThan(before.seated));
      expect(
        after.rooms.take(before.rooms.length).map((room) => room.seated),
        before.rooms.map((room) => room.seated),
        reason: 'nobody already seated moves',
      );
    });
  });

  group('incidents', () {
    test('closing an incident that holds a mark releases it', () {
      final cubit = started();
      final holding = cubit.state.incidents.firstWhere(
        (incident) =>
            incident.holdsMark &&
            incident.isOpen &&
            !cubit.state.isResultLocked(incident.courseCode),
      );

      expect(cubit.closeIncident(holding.id), isTrue);

      final closed = cubit.state.incidentById(holding.id)!;
      expect(closed.status, IncidentStatus.closed);
      expect(closed.holdsMark, isFalse);
    });

    test('cannot release a mark once the results are with the approvers', () {
      final cubit = started();
      final locked = cubit.state.incidents.firstWhere(
        (incident) =>
            incident.holdsMark &&
            incident.isOpen &&
            cubit.state.isResultLocked(incident.courseCode),
      );

      expect(cubit.closeIncident(locked.id), isFalse);
      expect(cubit.state.notice, ExamOfficeNotice.releaseLocked);
      expect(cubit.state.incidentById(locked.id)!.holdsMark, isTrue);
    });

    test('a dry run writes nothing', () {
      final cubit = started();
      final before = cubit.state.incidents.length;

      cubit.runImportDryRun();

      expect(cubit.state.importStatus, ImportStatus.dryRun);
      expect(
        cubit.state.importReport,
        hasLength(cubit.state.importRows.length),
      );
      expect(cubit.state.incidents, hasLength(before));
      expect(
        cubit.state.importReport.any(
          (report) => report.action == ImportAction.leave,
        ),
        isTrue,
        reason: 'the file has rows that cannot be imported',
      );
    });

    test('committing writes the rows the dry run accepted', () {
      final cubit = started();
      final before = cubit.state.incidents.length;
      cubit.runImportDryRun();
      final accepted = cubit.state.importReport
          .where((report) => report.action != ImportAction.leave)
          .length;

      expect(cubit.commitImport(), isTrue);

      expect(cubit.state.incidents, hasLength(before + accepted));
      expect(cubit.state.importStatus, ImportStatus.imported);
    });

    test('cannot commit before a dry run', () {
      final cubit = started();

      expect(cubit.commitImport(), isFalse);
    });
  });

  group('forms', () {
    test('a resit window must close after it opens', () {
      final cubit = started();
      final before = cubit.state.windows.length;

      final errors = cubit.openResitWindow(
        ResitWindowDraft(
          name: 'Harmattan resits',
          opensOn: DateTime(2027, 1, 20),
          closesOn: DateTime(2027, 1, 10),
          feePerUnitMinorUnits: 200000,
        ),
      );

      expect(errors, contains(ResitDraftError.closeBeforeOpen));
      expect(cubit.state.windows, hasLength(before));
    });

    test('a valid resit window opens', () {
      final cubit = started();
      final before = cubit.state.windows.length;

      final errors = cubit.openResitWindow(
        ResitWindowDraft(
          name: 'Harmattan resits',
          opensOn: DateTime(2027, 1, 10),
          closesOn: DateTime(2027, 1, 20),
          feePerUnitMinorUnits: 200000,
          unitCap: 6,
        ),
      );

      expect(errors, isEmpty);
      expect(cubit.state.windows, hasLength(before + 1));
    });

    test('a session needs dates in order', () {
      final cubit = started();

      final errors = cubit.openSession(
        SessionDraft(
          name: 'Main examinations',
          termLabel: ExamOfficeFixtures.emptyTerm,
          startsOn: DateTime(2027, 6, 10),
          endsOn: DateTime(2027, 6, 1),
          cardsOpenOn: DateTime(2027, 5, 25),
        ),
      );

      expect(errors, contains(SessionDraftError.endBeforeStart));
    });
  });

  group('grading', () {
    test('the postgraduate scale has marks with no grade', () {
      final cubit = started();
      final broken = cubit.state.scales.where((scale) => scale.hasGap);

      expect(broken, hasLength(1));
      expect(broken.single.unmappedTop, greaterThan(0));
      expect(broken.single.bandFor(10), isNull);
    });

    test('withdrawal must sit under the probation CGPA', () {
      final cubit = started();

      expect(cubit.saveThresholds(probation: 1.4, withdrawal: 2.0), isFalse);
      expect(cubit.state.notice, ExamOfficeNotice.thresholdsInvalid);
      expect(cubit.saveThresholds(probation: 2.5, withdrawal: 1.6), isTrue);
      expect(cubit.state.probationCgpa, 2.5);
    });
  });
}
