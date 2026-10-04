import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_state.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/admissions_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/application_detail_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/jamb_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/programme_models.dart';

void main() {
  late AdmissionsCubit cubit;

  setUp(() => cubit = AdmissionsCubit());
  tearDown(() => cubit.close());

  void load() => cubit.load();

  group('loading', () {
    test('starts empty', () {
      expect(cubit.state.status, AdmissionsStatus.initial);
      expect(cubit.state.candidate, isNull);
      expect(cubit.state.needsEmailConfirmation, isFalse);
    });

    test('loads the candidate and the portal content', () {
      load();

      expect(cubit.state.status, AdmissionsStatus.ready);
      expect(cubit.state.candidate, isNotNull);
      expect(cubit.state.candidate!.displayName, 'Musa Ibrahim');
      expect(cubit.state.cycles, isNotEmpty);
      expect(cubit.state.bulletins, isNotEmpty);
      expect(cubit.state.jambResultPending, isTrue);
    });

    test('is idempotent', () {
      load();
      final first = cubit.state;
      load();

      expect(cubit.state, first, reason: 'a second load must not reset');
    });

    test('counts the cycles open now', () {
      load();

      expect(cubit.state.openCyclesAt(DateTime(2026, 10)), hasLength(2));
    });

    test('names the first cycle, or falls back while loading', () {
      expect(cubit.state.cycleLabelFor('Admissions'), 'Admissions');
      load();
      expect(cubit.state.cycleLabelFor('Admissions'), '2026/2027 Cycle');
    });
  });

  group('the email confirmation gate', () {
    setUp(load);

    test('is shown because the address is unconfirmed', () {
      expect(cubit.state.needsEmailConfirmation, isTrue);
    });

    test('hides when the candidate dismisses it', () {
      cubit.dismissEmailBanner();

      expect(cubit.state.needsEmailConfirmation, isFalse);
      expect(
        cubit.state.emailConfirmation,
        EmailConfirmationStatus.idle,
        reason: 'dismissing is not the same as sending',
      );
    });

    test('comes back through restore', () {
      cubit
        ..dismissEmailBanner()
        ..resendEmailLink()
        ..restoreEmailBanner();

      expect(cubit.state.needsEmailConfirmation, isTrue);
      expect(cubit.state.emailConfirmation, EmailConfirmationStatus.idle);
    });

    test('resending moves through sending to sent', () async {
      final seen = <EmailConfirmationStatus>[];
      // Subscribe first: a cubit only delivers states emitted after the
      // listener exists, so registering afterwards would see nothing.
      final subscription = cubit.stream.listen(
        (state) => seen.add(state.emailConfirmation),
      );
      addTearDown(subscription.cancel);

      cubit.resendEmailLink();
      // `Cubit.stream` delivers on a microtask; let one pass before reading.
      await Future<void>.delayed(Duration.zero);

      expect(seen, [
        EmailConfirmationStatus.sending,
        EmailConfirmationStatus.sent,
      ]);
      expect(cubit.state.emailConfirmation, EmailConfirmationStatus.sent);
    });

    test(
      'a sent link stays visible so the candidate sees the confirmation',
      () {
        cubit.resendEmailLink();

        expect(cubit.state.hasSentEmailLink, isTrue);
        expect(cubit.state.needsEmailConfirmation, isTrue);
      },
    );

    test('the banner is not a nag while it is sending', () {
      expect(cubit.state.isSendingEmailLink, isFalse);
      cubit.resendEmailLink();
      expect(
        cubit.state.isSendingEmailLink,
        isFalse,
        reason: 'settles at once',
      );
    });
  });

  group('the JAMB result', () {
    setUp(load);

    final result = AdmissionsFixtures.jambResult;

    ChecklistItem jambRow() => cubit.state
        .detailFor(AdmissionsFixtures.draftApplication.id)!
        .checklist
        .singleWhere((item) => item.id == 'jamb-caps');

    test('is pending, and bound for the draft, once loaded', () {
      expect(cubit.state.jambResultPending, isTrue);
      expect(cubit.state.hasLinkedJambResult, isFalse);
      expect(
        cubit.state.jambLinkApplication?.trackingCode,
        'APP/2026/00057',
        reason: 'the draft is the record still waiting on a score',
      );
      expect(jambRow().state, RequirementState.notTracked);
      expect(jambRow().action, ChecklistAction.claimJamb);
    });

    test('linking puts it on the record and clears what was pending', () {
      cubit.linkJambResult(result);

      expect(cubit.state.linkedJambResult, result);
      expect(cubit.state.hasLinkedJambResult, isTrue);
      expect(
        cubit.state.jambResultPending,
        isFalse,
        reason: 'the badge and the overview card have nothing left to say',
      );
    });

    test('linking ticks the checklist row that was waiting on it', () {
      cubit.linkJambResult(result);

      final row = jambRow();
      expect(row.state, RequirementState.met);
      expect(row.action, ChecklistAction.none);
      expect(row.title, 'JAMB result from CAPS', reason: 'same row, now met');
      expect(row.detail, contains('312'));

      // The rest of the checklist is untouched.
      final detail = cubit.state.detailFor(
        AdmissionsFixtures.draftApplication.id,
      )!;
      expect(detail.checklist, hasLength(9));
      expect(detail.completedCount, 4);
      expect(detail.outstandingCount, 4);
    });

    test('cannot be linked twice', () {
      cubit.linkJambResult(result);
      final linked = cubit.state;

      cubit.linkJambResult(
        JambResult(
          registrationNumber: '000000000000ZZ',
          candidateName: 'Somebody Else',
          surname: 'Else',
          dateOfBirth: DateTime(2007),
          examinationYear: 2025,
          aggregateScore: 200,
          subjects: const [],
        ),
      );

      expect(cubit.state, linked, reason: 'the screen says it is permanent');
    });

    test('leaves the other records alone', () {
      final before = cubit.state.applicationDetails;
      cubit.linkJambResult(result);

      for (final id in before.keys) {
        if (id == AdmissionsFixtures.draftApplication.id) continue;
        expect(cubit.state.applicationDetails[id], before[id]);
      }
    });
  });

  group('reset', () {
    test('returns the cubit to its initial state', () {
      load();
      cubit
        ..dismissEmailBanner()
        ..reset();

      expect(cubit.state, const AdmissionsState());
    });
  });
}
