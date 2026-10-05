import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/registration/presentation/bloc/registration_cubit.dart';
import 'package:the_legion_mobile/features/registration/presentation/bloc/registration_state.dart';
import 'package:the_legion_mobile/features/registration/presentation/mock/registration_fixtures.dart';
import 'package:the_legion_mobile/features/registration/presentation/models/registration_models.dart';

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
        ),
      ],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'load is idempotent once ready',
      build: RegistrationCubit.new,
      seed: () => RegistrationState(
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
      ),
      act: (cubit) => cubit.load(),
      expect: () => <RegistrationState>[],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'requestDrop opens the minimum sheet when at the floor',
      build: RegistrationCubit.new,
      seed: () => RegistrationState(
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
      ),
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
      seed: () => RegistrationState(
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
      ),
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
      seed: () => RegistrationState(
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
      ),
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
      seed: () => RegistrationState(
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
      ),
      act: (cubit) => cubit.requestReadd('reg-csc405'),
      expect: () => <RegistrationState>[],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'submitForm records a course form when the declaration is accepted',
      build: RegistrationCubit.new,
      seed: () => RegistrationState(
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
        declarationAccepted: true,
      ),
      act: (cubit) => cubit.submitForm(),
      verify: (cubit) {
        expect(cubit.state.formStatus, CourseFormStatus.submitted);
        expect(cubit.state.forms, isNotEmpty);
        expect(cubit.state.canSubmitForm, isFalse);
      },
    );
  });
}
