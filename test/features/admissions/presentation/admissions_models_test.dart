import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/theme/app_tone.dart';
import 'package:the_legion_mobile/core/utils/greeting_period.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/admissions_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/admissions_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/programme_models.dart';

void main() {
  group('ApplicationStatus', () {
    test('uses the tone the README specifies', () {
      expect(ApplicationStatus.draft.tone, AppTone.neutral);
      expect(ApplicationStatus.submitted.tone, AppTone.info);
      expect(ApplicationStatus.underReview.tone, AppTone.info);
      expect(ApplicationStatus.offered.tone, AppTone.warning);
      expect(ApplicationStatus.accepted.tone, AppTone.success);
      expect(ApplicationStatus.matriculated.tone, AppTone.success);
      expect(ApplicationStatus.declined.tone, AppTone.danger);
      expect(ApplicationStatus.rejected.tone, AppTone.danger);
      expect(ApplicationStatus.withdrawn.tone, AppTone.danger);
    });

    test('an expired offer is amber, not red', () {
      // The candidate did nothing wrong; the deadline passed while they were
      // away. Red would accuse them.
      expect(ApplicationStatus.expired.tone, AppTone.warning);
    });

    test('only a draft or a submitted application is still open', () {
      expect(ApplicationStatus.draft.isOpen, isTrue);
      expect(ApplicationStatus.submitted.isOpen, isTrue);
      for (final status in [
        ApplicationStatus.underReview,
        ApplicationStatus.offered,
        ApplicationStatus.accepted,
        ApplicationStatus.declined,
        ApplicationStatus.rejected,
        ApplicationStatus.withdrawn,
        ApplicationStatus.expired,
        ApplicationStatus.matriculated,
      ]) {
        expect(status.isOpen, isFalse, reason: status.name);
      }
    });

    test(
      'an application is active until the candidate or the cycle lets go',
      () {
        // Being assembled, waiting on a decision, or holding an offer: each
        // one still claims a place, which is what bars a second application in
        // the same category.
        for (final status in [
          ApplicationStatus.draft,
          ApplicationStatus.submitted,
          ApplicationStatus.underReview,
          ApplicationStatus.offered,
          ApplicationStatus.accepted,
        ]) {
          expect(status.isActive, isTrue, reason: status.name);
        }
        // Refused, withdrawn, lapsed, declined, or finished with.
        for (final status in [
          ApplicationStatus.declined,
          ApplicationStatus.rejected,
          ApplicationStatus.withdrawn,
          ApplicationStatus.expired,
          ApplicationStatus.matriculated,
        ]) {
          expect(status.isActive, isFalse, reason: status.name);
        }
      },
    );
  });

  group('BulletinCategory', () {
    test('each category keeps its own tone', () {
      expect(BulletinCategory.information.tone, AppTone.info);
      expect(BulletinCategory.success.tone, AppTone.success);
      expect(BulletinCategory.warning.tone, AppTone.warning);
    });
  });

  group('AdmissionCycle', () {
    final cycle = AdmissionCycle(
      id: 'ug-2026',
      name: '2026/2027 Undergraduate Admissions',
      label: '2026/2027 Cycle',
      session: '2026/2027',
      opensOn: DateTime(2026, 6),
      closesOn: DateTime(2027, 2, 28),
      formFeeMinorUnits: 750000,
    );

    test('is open inside its window', () {
      expect(cycle.isOpenAt(DateTime(2026, 7)), isTrue);
    });

    test('is closed before it opens and after it closes', () {
      expect(cycle.isOpenAt(DateTime(2026, 1)), isFalse);
      expect(cycle.isOpenAt(DateTime(2028)), isFalse);
    });

    test('counts the days left, never below zero', () {
      expect(cycle.daysUntilClose(DateTime(2027, 2, 1)), 27);
      expect(cycle.daysUntilClose(DateTime(2028)), 0);
    });
  });

  group('CandidateProfile', () {
    test('greet by first name only', () {
      expect(
        const CandidateProfile(
          displayName: 'Musa Ibrahim',
          email: 'm@example.com',
          isEmailConfirmed: true,
        ).firstName,
        'Musa',
      );
    });

    test('falls back to the whole name when there is no space', () {
      expect(
        const CandidateProfile(
          displayName: 'Musa',
          email: 'm@example.com',
          isEmailConfirmed: true,
        ).firstName,
        'Musa',
      );
    });
  });

  group('GreetingPeriod', () {
    test('the clock decides the period', () {
      expect(GreetingPeriod.forHour(0), GreetingPeriod.morning);
      expect(GreetingPeriod.forHour(11), GreetingPeriod.morning);
      expect(GreetingPeriod.forHour(12), GreetingPeriod.afternoon);
      expect(GreetingPeriod.forHour(16), GreetingPeriod.afternoon);
      expect(GreetingPeriod.forHour(17), GreetingPeriod.evening);
      expect(GreetingPeriod.forHour(23), GreetingPeriod.evening);
    });
  });

  group('fixtures', () {
    test('the candidate starts with an unconfirmed address', () {
      expect(AdmissionsFixtures.candidate.isEmailConfirmed, isFalse);
    });

    test('two cycles are open in October 2026', () {
      final open = AdmissionsFixtures.openCyclesAt(DateTime(2026, 10));
      expect(open, hasLength(2));
    });

    test('the postgraduate cycle closes before the undergraduate one', () {
      // 10 February: the postgraduate window shut on 31 January, the
      // undergraduate one runs to 28 February.
      final open = AdmissionsFixtures.openCyclesAt(DateTime(2027, 2, 10));
      expect(open, hasLength(1));
      expect(open.single.id, 'undergraduate-2026');
    });

    test('no cycle is open once both have closed', () {
      expect(AdmissionsFixtures.openCyclesAt(DateTime(2027, 6)), isEmpty);
    });

    test('both cycles admit to the same session', () {
      // The one-per-category rule compares sessions, so the two cycles have
      // to name theirs the same way the applications do.
      expect(AdmissionsFixtures.currentCycle.session, '2026/2027');
      expect(AdmissionsFixtures.postgraduateCycle.session, '2026/2027');
      expect(
        AdmissionsFixtures.draftApplication.cycleSession,
        AdmissionsFixtures.currentCycle.session,
      );
    });

    test('every application on the record is undergraduate', () {
      // Which is why no undergraduate card can offer "Apply" this session,
      // and the diploma is the one that can.
      for (final application in AdmissionsFixtures.applications) {
        expect(
          application.category,
          ProgrammeCategory.undergraduate,
          reason: application.id,
        );
      }
    });

    test('bulletins are not empty, so the board has something to show', () {
      expect(AdmissionsFixtures.bulletins, isNotEmpty);
    });
  });
}
