import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/theme/app_tone.dart';
import 'package:the_legion_mobile/features/home/presentation/mock/hub_fixtures.dart';
import 'package:the_legion_mobile/features/home/presentation/models/hub_models.dart';

void main() {
  group('HubTerm', () {
    final term = HubTerm(
      session: '2025/2026',
      semesterShort: '2nd Sem',
      semesterLong: '2nd Semester',
      startsOn: DateTime(2026, 9),
      endsOn: DateTime(2026, 11),
    );

    test('reports no progress on the first day', () {
      expect(term.progressAt(DateTime(2026, 9)), 0);
    });

    test('reports half a term at its midpoint', () {
      final progress = term.progressAt(DateTime(2026, 10, 1));

      expect(progress, closeTo(0.5, 0.02));
    });

    test('clamps progress to the term window', () {
      expect(term.progressAt(DateTime(2026, 1)), 0, reason: 'before the term');
      expect(term.progressAt(DateTime(2027)), 1, reason: 'after the term');
    });

    test('counts whole days left', () {
      // 61 days from 1 September to 1 November.
      expect(term.daysRemainingAt(DateTime(2026, 9, 1)), 61);
    });

    test('never reports a negative count after the term ends', () {
      expect(term.daysRemainingAt(DateTime(2027, 3)), 0);
    });

    test('survives a zero-length term', () {
      final instant = HubTerm(
        session: 'x',
        semesterShort: 'x',
        semesterLong: 'x',
        startsOn: DateTime(2026),
        endsOn: DateTime(2026),
      );

      expect(instant.progressAt(DateTime(2026, 6)), 0);
    });
  });

  group('HubStanding', () {
    test('joins the level and the programme the way the hero shows them', () {
      expect(
        const HubStanding(level: '300 Level', programme: 'B.Sc. CS').summary,
        '300 Level · B.Sc. CS',
      );
    });
  });

  group('tone mapping', () {
    test('each timeline state keeps its own colour family', () {
      expect(TimelineStepState.actionable.tone, AppTone.warning);
      expect(TimelineStepState.blocked.tone, AppTone.danger);
      expect(TimelineStepState.waiting.tone, AppTone.info);
      expect(TimelineStepState.done.tone, AppTone.success);
    });

    test('bulletin categories map to urgency, notice and information', () {
      expect(AnnouncementCategory.urgent.tone, AppTone.danger);
      expect(AnnouncementCategory.notice.tone, AppTone.warning);
      expect(AnnouncementCategory.information.tone, AppTone.info);
    });
  });

  group('fixtures', () {
    test('the directory holds thirteen portals in three clusters', () {
      expect(HubFixtures.clusters, hasLength(3));
      expect(ModuleCluster.countOf(HubFixtures.clusters), 13);
    });

    test('the flow ends with the completed step anchored last', () {
      expect(HubFixtures.nextSteps.last.state, TimelineStepState.done);
      expect(HubFixtures.nextSteps.last.isInteractive, isFalse);
    });

    test('only the first step is actionable', () {
      final actionable = HubFixtures.nextSteps.where(
        (step) => step.state == TimelineStepState.actionable,
      );

      expect(actionable, hasLength(1));
      expect(actionable.first.dueOn, isNotNull);
    });

    test('every step has a title and at least one detail run', () {
      for (final step in HubFixtures.nextSteps) {
        expect(step.title, isNotEmpty, reason: step.id);
        expect(step.detail, isNotEmpty, reason: step.id);
      }
    });

    test('only the profile shortcut points at a real route', () {
      final routed = HubFixtures.accountUtilities.where(
        (utility) => utility.routeName != null,
      );

      expect(routed, hasLength(1));
      expect(routed.single.id, 'profile');
    });
  });
}
