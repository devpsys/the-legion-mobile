import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/theme/app_tone.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/programme_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/programme_models.dart';

void main() {
  // The designs were drawn on 4 February 2027: English was ten days from its
  // deadline, everything else had months. Testing on that date is what proves
  // both "closes in 10 days" and "admissions active" can be produced at all.
  final designDay = DateTime(2027, 2, 4);

  group('RequirementState — the three-state rule', () {
    test('met is green and not met is red', () {
      expect(RequirementState.met.tone, AppTone.success);
      expect(RequirementState.notMet.tone, AppTone.danger);
    });

    test('not tracked is amber, never red', () {
      expect(
        RequirementState.notTracked.tone,
        AppTone.warning,
        reason:
            'nobody could answer it; red would tell the candidate they are '
            'blocked when they are not',
      );
    });

    test('only a known failure blocks a submission', () {
      expect(RequirementState.notMet.blocksSubmission, isTrue);
      expect(
        RequirementState.notTracked.blocksSubmission,
        isFalse,
        reason: 'the README is explicit that unverified does not block',
      );
      expect(RequirementState.met.blocksSubmission, isFalse);
    });
  });

  group('ProgrammeVerdict', () {
    test('all met means eligible', () {
      expect(ProgrammeFixtures.accounting.verdict, ProgrammeVerdict.eligible);
    });

    test('an unverified requirement means needs checking, not failure', () {
      expect(
        ProgrammeFixtures.computerScience.verdict,
        ProgrammeVerdict.needsChecking,
      );
      expect(
        ProgrammeFixtures.computerScience.verdict,
        isNot(ProgrammeVerdict.notEligible),
        reason: 'one pending result must not read as a rejection',
      );
    });

    test('a known failure outranks an unverified one', () {
      final programme = Programme(
        id: 'x',
        code: 'X',
        title: 'Test',
        department: 'Test',
        faculty: Faculty.law,
        durationYears: 3,
        studyMode: StudyMode.undergraduateFullTime,
        formFeeMinorUnits: 0,
        closesOn: _farFuture,
        requirements: [
          ProgrammeRequirement(
            id: 'a',
            state: RequirementState.notTracked,
            detail: 'x',
          ),
          ProgrammeRequirement(
            id: 'b',
            state: RequirementState.notMet,
            detail: 'y',
          ),
        ],
      );

      expect(programme.verdict, ProgrammeVerdict.notEligible);
      expect(programme.canApply, isFalse);
    });

    test('a closed programme is closed whatever its requirements say', () {
      expect(
        ProgrammeFixtures.law.verdict,
        ProgrammeVerdict.closed,
        reason: 'the evaluation is no longer why it cannot be applied to',
      );
      expect(ProgrammeFixtures.law.canApply, isFalse);
    });

    test('every verdict has a tone', () {
      for (final verdict in ProgrammeVerdict.values) {
        expect(ProgrammeVerdictTone(verdict).tone, isA<AppTone>());
      }
    });
  });

  group('canApply', () {
    test('an unverified requirement does not stop an application', () {
      expect(
        ProgrammeFixtures.computerScience.canApply,
        isTrue,
        reason: 'the bursary module is missing, not the candidate',
      );
      expect(ProgrammeFixtures.english.canApply, isTrue);
    });

    test('a fully eligible programme can be applied to', () {
      expect(ProgrammeFixtures.accounting.canApply, isTrue);
    });

    test('a closed programme cannot', () {
      expect(ProgrammeFixtures.law.canApply, isFalse);
    });
  });

  group('deadlines', () {
    test('counts whole days, never below zero', () {
      expect(
        ProgrammeFixtures.english.daysUntilClose(designDay),
        10,
        reason: '14 February from 4 February',
      );
      expect(ProgrammeFixtures.law.daysUntilClose(designDay), 0);
      expect(
        ProgrammeFixtures.accounting.daysUntilClose(DateTime(2028)),
        0,
        reason: 'a passed deadline reads as zero, not as a negative count',
      );
    });

    test('English closes ahead of the cycle', () {
      expect(
        ProgrammeFixtures.english.closesOn.isBefore(
          ProgrammeFixtures.cycleDeadline,
        ),
        isTrue,
      );
      expect(
        ProgrammeFixtures.accounting.closesOn.isBefore(
          ProgrammeFixtures.cycleDeadline,
        ),
        isFalse,
      );
    });
  });

  group('evaluationSummary', () {
    test('joins each requirement so each is attributable', () {
      final summary = ProgrammeFixtures.computerScience.evaluationSummary;

      expect(summary, contains('O\'level credits'));
      expect(summary, contains('WAEC results are pending verification'));
      expect(summary, contains('your score is 312 ✓'));
    });
  });

  group('matches', () {
    test('an empty or whitespace query matches everything', () {
      expect(ProgrammeFixtures.law.matches(''), isTrue);
      expect(ProgrammeFixtures.law.matches('   '), isTrue);
    });

    test('finds a programme by name, code, department or faculty', () {
      expect(ProgrammeFixtures.computerScience.matches('computer'), isTrue);
      expect(ProgrammeFixtures.computerScience.matches('CSC'), isTrue);
      expect(ProgrammeFixtures.computerScience.matches('csc'), isTrue);
      expect(ProgrammeFixtures.accounting.matches('Accounting'), isTrue);
      expect(
        ProgrammeFixtures.english.matches('arts'),
        isTrue,
        reason: 'the faculty is searchable too',
      );
    });

    test('a closed programme is still findable', () {
      expect(
        ProgrammeFixtures.law.matches('law'),
        isTrue,
        reason:
            'a closed programme is shown, not hidden — otherwise a candidate '
            'who cannot find it assumes the university does not teach it',
      );
    });

    test('does not match an unrelated query', () {
      expect(ProgrammeFixtures.accounting.matches('nursing'), isFalse);
    });
  });

  group('the catalogue', () {
    test('spans every faculty it claims to', () {
      final faculties = ProgrammeFixtures.programmes
          .map((programme) => programme.faculty)
          .toSet();

      expect(faculties, hasLength(3), reason: 'Science, Arts and Law');
      expect(
        faculties,
        isNot(contains(Faculty.engineering)),
        reason: 'which is why that chip is present and disabled',
      );
    });

    test('the closed programme is still in the list', () {
      expect(
        ProgrammeFixtures.programmes.any((programme) => programme.isClosed),
        isTrue,
      );
    });
  });
}

/// A deadline far enough away that no countdowns in these tests go negative.
final DateTime _farFuture = DateTime(2099);
