import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/registration/presentation/bloc/registration_cubit.dart';
import 'package:the_legion_mobile/features/registration/presentation/bloc/registration_state.dart';
import 'package:the_legion_mobile/features/registration/presentation/mock/registration_fixtures.dart';
import 'package:the_legion_mobile/features/registration/presentation/models/registration_models.dart';

RegistrationState _ready({
  bool declarationAccepted = false,
  IdCardRecord? idCard,
  List<AcademicRequest>? academicRequests,
  DisciplineRecord? discipline,
}) {
  return RegistrationState(
    status: RegistrationStatus.ready,
    student: RegistrationFixtures.student,
    window: RegistrationFixtures.window,
    gate: RegistrationFixtures.gate,
    minimumUnits: RegistrationFixtures.minimumUnits,
    maximumUnits: RegistrationFixtures.maximumUnits,
    courses: RegistrationFixtures.courses,
    catalogue: RegistrationFixtures.catalogue,
    week: RegistrationFixtures.week,
    studyPlan: RegistrationFixtures.studyPlan,
    idCard: idCard ?? RegistrationFixtures.idCard,
    academicRequests:
        academicRequests ?? RegistrationFixtures.academicRequests,
    discipline: discipline ?? RegistrationFixtures.discipline,
    declarationAccepted: declarationAccepted,
  );
}

void main() {
  group('RegistrationCubit', () {
    test('starts with nothing loaded', () {
      final cubit = RegistrationCubit();
      addTearDown(cubit.close);

      expect(cubit.state, const RegistrationState());
      expect(cubit.state.student, isNull);
      expect(cubit.state.canSubmitForm, isFalse);
    });

    blocTest<RegistrationCubit, RegistrationState>(
      'load reads the ledger into a ready state',
      build: RegistrationCubit.new,
      act: (cubit) => cubit.load(),
      expect: () => [
        const RegistrationState(status: RegistrationStatus.loading),
        RegistrationState(
          status: RegistrationStatus.ready,
          student: RegistrationFixtures.student,
          window: RegistrationFixtures.window,
          gate: RegistrationFixtures.gate,
          minimumUnits: RegistrationFixtures.minimumUnits,
          maximumUnits: RegistrationFixtures.maximumUnits,
          courses: RegistrationFixtures.courses,
          catalogue: RegistrationFixtures.catalogue,
          week: RegistrationFixtures.week,
          formStatus: CourseFormStatus.notSubmitted,
          forms: const [],
          studyPlan: RegistrationFixtures.studyPlan,
          idCard: RegistrationFixtures.idCard,
          academicRequests: RegistrationFixtures.academicRequests,
          discipline: RegistrationFixtures.discipline,
        ),
      ],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'load is idempotent once ready',
      build: RegistrationCubit.new,
      seed: _ready,
      act: (cubit) => cubit.load(),
      expect: () => <RegistrationState>[],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'requestDrop opens the minimum sheet when at the floor',
      build: RegistrationCubit.new,
      seed: _ready,
      act: (cubit) => cubit.requestDrop('reg-csc311'),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.sheet, 'sheet', RegistrationSheet.dropBelowMinimum)
            .having((s) => s.sheetCourseId, 'sheetCourseId', 'reg-csc311'),
      ],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'requestAdd opens the clash sheet for a clashing catalogue course',
      build: RegistrationCubit.new,
      seed: _ready,
      act: (cubit) => cubit.requestAdd('cat-csc405a'),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.sheet, 'sheet', RegistrationSheet.timetableClash)
            .having((s) => s.sheetCourseId, 'sheetCourseId', 'cat-csc405a'),
      ],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'requestReadd restores a dropped course to awaiting approval',
      build: RegistrationCubit.new,
      seed: _ready,
      act: (cubit) => cubit.requestReadd('reg-csc305'),
      verify: (cubit) {
        final course = cubit.state.registeredById('reg-csc305');
        expect(course?.status, CourseApprovalStatus.pending);
        expect(course?.canDrop, isTrue);
        expect(
          cubit.state.registeredById('reg-csc405')?.status,
          CourseApprovalStatus.rejected,
        );
      },
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'requestReadd ignores rejected courses',
      build: RegistrationCubit.new,
      seed: _ready,
      act: (cubit) => cubit.requestReadd('reg-csc405'),
      expect: () => <RegistrationState>[],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'submitForm records a course form when the declaration is accepted',
      build: RegistrationCubit.new,
      seed: () => _ready(declarationAccepted: true),
      act: (cubit) => cubit.submitForm(),
      verify: (cubit) {
        expect(cubit.state.formStatus, CourseFormStatus.submitted);
        expect(cubit.state.forms, isNotEmpty);
        expect(cubit.state.canSubmitForm, isFalse);
      },
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'cancel ID card clears the active request after confirmation',
      build: RegistrationCubit.new,
      seed: _ready,
      act: (cubit) {
        cubit.requestCancelIdCard();
        cubit.confirmCancelIdCard();
      },
      verify: (cubit) {
        expect(cubit.state.idCard?.activeRequest, isNull);
        expect(cubit.state.sheet, isNull);
      },
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'submitIdCardRequest is locked while an active request exists',
      build: RegistrationCubit.new,
      seed: _ready,
      act: (cubit) {
        cubit.setIdCardDraftReason(IdCardReason.damaged);
        cubit.submitIdCardRequest();
      },
      verify: (cubit) {
        expect(cubit.state.idCard?.canSubmitRequest, isFalse);
        expect(
          cubit.state.idCard?.activeRequest?.serial,
          'LG/ID/2026/00892',
        );
      },
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'submitIdCardRequest creates a first-issue request when unlocked',
      build: RegistrationCubit.new,
      seed: () => _ready(idCard: RegistrationFixtures.idCardFirstIssue),
      act: (cubit) => cubit.submitIdCardRequest(),
      verify: (cubit) {
        final active = cubit.state.idCard?.activeRequest;
        expect(active, isNotNull);
        expect(active?.feePayment, IdCardFeePayment.notRequired);
        expect(active?.reason, IdCardReason.firstCard);
        expect(cubit.state.idCard?.canSubmitRequest, isFalse);
      },
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'withdraw academic request marks it withdrawn',
      build: RegistrationCubit.new,
      seed: _ready,
      act: (cubit) {
        cubit.requestWithdrawAcademic('req-waive-csc405');
        cubit.confirmWithdrawAcademic();
      },
      verify: (cubit) {
        final request = cubit.state.academicRequestById('req-waive-csc405');
        expect(request?.status, AcademicRequestStatus.withdrawn);
        expect(request?.canWithdraw, isFalse);
      },
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'requestLodgeAppeal opens the confirm sheet when grounds are long enough',
      build: RegistrationCubit.new,
      seed: _ready,
      act: (cubit) {
        cubit.setDisciplineAppealDraft(
          'The attendance sheet listed more names than seats in the room, '
          'so another candidate may have been recorded in my place.',
        );
        cubit.requestLodgeAppeal('case-dc-2026-00031');
      },
      verify: (cubit) {
        expect(cubit.state.sheet, RegistrationSheet.lodgeDisciplineAppeal);
        expect(cubit.state.sheetCourseId, 'case-dc-2026-00031');
      },
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'confirmLodgeAppeal marks the case under appeal',
      build: RegistrationCubit.new,
      seed: _ready,
      act: (cubit) {
        cubit.setDisciplineAppealDraft(
          'The attendance sheet listed more names than seats in the room, '
          'so another candidate may have been recorded in my place.',
        );
        cubit.requestLodgeAppeal('case-dc-2026-00031');
        cubit.confirmLodgeAppeal();
      },
      verify: (cubit) {
        final item = cubit.state.disciplineCaseById('case-dc-2026-00031');
        expect(item?.status, DisciplineCaseStatus.underAppeal);
        expect(item?.hasAppealLodged, isTrue);
        expect(cubit.state.discipline?.appealDraft, isEmpty);
        expect(cubit.state.sheet, isNull);
      },
    );
  });
}
