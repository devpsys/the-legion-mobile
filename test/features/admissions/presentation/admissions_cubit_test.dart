import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_state.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/admissions_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/programme_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/admissions_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/application_detail_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/jamb_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/programme_models.dart';

void main() {
  late AdmissionsCubit cubit;

  setUp(() => cubit = AdmissionsCubit());
  tearDown(() => cubit.close());

  void load() => cubit.load();

  /// 4 February 2027, the day the Programmes design was drawn on: both cycles
  /// have opened, the postgraduate one has already closed.
  final designDay = DateTime(2027, 2, 4);

  /// The JAMB row of the draft [id].
  ChecklistItem jambRowOf(String id) => cubit.state
      .detailFor(id)!
      .checklist
      .singleWhere((item) => item.id == 'jamb-caps');

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

    ChecklistItem jambRow() =>
        jambRowOf(AdmissionsFixtures.draftApplication.id);

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

  group('whether a programme can be applied to', () {
    setUp(load);

    ApplyAvailability availabilityOf(Programme programme, [DateTime? at]) =>
        cubit.state.applyAvailabilityFor(programme, at ?? designDay);

    test('the undergraduate cards are spoken for this session', () {
      // An offer on Computer Science and a draft on English are both live,
      // so every undergraduate programme is one application too many.
      for (final programme in [
        ProgrammeFixtures.computerScience,
        ProgrammeFixtures.accounting,
        ProgrammeFixtures.english,
      ]) {
        expect(
          availabilityOf(programme),
          ApplyAvailability.alreadyApplied,
          reason: programme.code,
        );
      }
    });

    test('the diploma is the one card still offering an application', () {
      expect(
        availabilityOf(ProgrammeFixtures.diplomaInLaw),
        ApplyAvailability.available,
        reason: 'nothing on the record is a diploma application',
      );
    });

    test('a closed programme is closed before it is already applied to', () {
      expect(
        availabilityOf(ProgrammeFixtures.law),
        ApplyAvailability.unavailable,
        reason: 'the strip says "Archived session", not "Already applied"',
      );
    });

    test('a record with nothing live in the category frees the cards', () {
      // Withdrawn, refused, lapsed and matriculated have all let go of the
      // session; none of them is a second application.
      cubit.emit(
        cubit.state.copyWith(
          applications: [
            AdmissionsFixtures.withdrawnApplication,
            AdmissionsFixtures.rejectedApplication,
            AdmissionsFixtures.expiredApplication,
            AdmissionsFixtures.matriculatedApplication,
          ],
        ),
      );

      expect(
        availabilityOf(ProgrammeFixtures.computerScience),
        ApplyAvailability.available,
      );
      expect(
        availabilityOf(ProgrammeFixtures.law),
        ApplyAvailability.unavailable,
        reason: 'still closed',
      );
    });

    test('an application in another session does not count', () {
      cubit.emit(
        cubit.state.copyWith(
          applications: [
            // The refusal is undergraduate, but from 2025/2026.
            AdmissionsFixtures.rejectedApplication,
            // A live undergraduate application, filed last session.
            ApplicationSummary(
              id: 'app-00900',
              programmeName: 'B.Sc. Accounting',
              department: 'Department of Accounting',
              category: ProgrammeCategory.undergraduate,
              status: ApplicationStatus.offered,
              submittedOn: DateTime(2025, 9),
              updatedOn: DateTime(2026, 1),
              cycleName: '2025/2026 Undergraduate Admissions',
              cycleSession: '2025/2026',
            ),
          ],
        ),
      );

      expect(
        availabilityOf(ProgrammeFixtures.computerScience),
        ApplyAvailability.available,
      );
    });

    test('nothing is offered under a cycle that has closed', () {
      // The postgraduate cycle shut on 31 January.
      cubit.selectCycle(AdmissionsFixtures.postgraduateCycle.id);

      expect(
        availabilityOf(ProgrammeFixtures.diplomaInLaw),
        ApplyAvailability.unavailable,
      );
    });

    test('nothing is offered once the undergraduate cycle has closed', () {
      expect(
        availabilityOf(ProgrammeFixtures.diplomaInLaw, DateTime(2027, 3)),
        ApplyAvailability.unavailable,
      );
    });

    test('a programme whose own window has shut is not offered', () {
      cubit.emit(cubit.state.copyWith(applications: const []));
      // 20 February: English closed on the 14th, the cycle runs to the 28th.
      final late = DateTime(2027, 2, 20);

      expect(
        availabilityOf(ProgrammeFixtures.english, late),
        ApplyAvailability.unavailable,
      );
      expect(
        availabilityOf(ProgrammeFixtures.computerScience, late),
        ApplyAvailability.available,
      );
    });

    test('nothing is offered before a cycle is chosen', () {
      expect(
        const AdmissionsState().applyAvailabilityFor(
          ProgrammeFixtures.diplomaInLaw,
          designDay,
        ),
        ApplyAvailability.unavailable,
        reason: 'there is nothing to file the application under',
      );
    });
  });

  group('starting an application', () {
    setUp(load);

    final diploma = ProgrammeFixtures.diplomaInLaw;

    test('opens a draft at the top of the record', () {
      final id = cubit.startApplication(diploma.id, now: designDay);

      expect(id, 'app-00919', reason: 'one above the highest serial, 00918');
      final application = cubit.state.applications.first;
      expect(application.id, id);
      expect(application.trackingCode, 'APP/2026/00919');
      expect(application.status, ApplicationStatus.draft);
      expect(application.programmeName, 'Diploma in Law');
      expect(application.department, 'Department of Law');
      expect(application.category, ProgrammeCategory.diploma);
      expect(application.cycleName, '2026/2027 Undergraduate Admissions');
      expect(application.cycleSession, '2026/2027');
      expect(application.submittedOn, designDay);
      expect(application.updatedOn, designDay);
      expect(cubit.state.applications, hasLength(7));
    });

    test('puts the detail screen\'s content behind the draft', () {
      final id = cubit.startApplication(diploma.id, now: designDay)!;

      final detail = cubit.state.detailFor(id)!;
      expect(detail.application.id, id);
      expect(detail.cycleId, AdmissionsFixtures.currentCycle.id);
      expect(detail.firstChoiceProgrammeId, diploma.id);
      expect(detail.secondChoiceProgrammeId, isNull);
      expect(detail.referees, isEmpty);
      expect(detail.offer, isNull);

      // The candidate's own standing, with the two rows that belong to the
      // application reset: nobody invited, the diploma's own fee.
      expect(detail.checklist, hasLength(9));
      expect(detail.completedCount, 3);
      expect(detail.outstandingCount, 4);
      final referees = detail.checklist.singleWhere((i) => i.id == 'referees');
      expect(referees.detail, '0 of 2 invited | 0 responded.');
      final fee = detail.checklist.singleWhere((i) => i.id == 'form-fee');
      expect(fee.detail, startsWith('₦5,000.00'));

      expect(detail.history.map((event) => event.title), [
        'First choice set to Diploma in Law',
        'Application started',
      ]);
      expect(
        detail.history.map((event) => event.occurredOn),
        everyElement(designDay),
      );
    });

    test('a second application in the category is refused', () {
      cubit.startApplication(diploma.id, now: designDay);
      final after = cubit.state;

      expect(
        cubit.state.applyAvailabilityFor(diploma, designDay),
        ApplyAvailability.alreadyApplied,
        reason: 'the card loses its button the moment the draft exists',
      );
      expect(cubit.startApplication(diploma.id, now: designDay), isNull);
      expect(cubit.state, after);
    });

    test('refuses what the card would not offer', () {
      final before = cubit.state;

      expect(
        cubit.startApplication(
          ProgrammeFixtures.computerScience.id,
          now: designDay,
        ),
        isNull,
        reason: 'already applied',
      );
      expect(
        cubit.startApplication(ProgrammeFixtures.law.id, now: designDay),
        isNull,
        reason: 'closed',
      );
      expect(
        cubit.startApplication(diploma.id, now: DateTime(2027, 3)),
        isNull,
        reason: 'the cycle has closed',
      );
      expect(
        cubit.startApplication('nursing', now: designDay),
        isNull,
        reason: 'not in the catalogue',
      );
      expect(cubit.state, before, reason: 'a refusal changes nothing');
    });

    test('a draft opened after the JAMB result is linked starts with it', () {
      cubit.linkJambResult(AdmissionsFixtures.jambResult);

      final id = cubit.startApplication(diploma.id, now: designDay)!;

      final row = jambRowOf(id);
      expect(row.state, RequirementState.met);
      expect(row.action, ChecklistAction.none);
      expect(row.detail, contains('312'));
      expect(cubit.state.detailFor(id)!.completedCount, 4);
    });

    test('a draft opened before the link is ticked by it too', () {
      final id = cubit.startApplication(diploma.id, now: designDay)!;
      expect(jambRowOf(id).state, RequirementState.notTracked);

      cubit.linkJambResult(AdmissionsFixtures.jambResult);

      expect(jambRowOf(id).state, RequirementState.met);
      expect(
        jambRowOf(AdmissionsFixtures.draftApplication.id).state,
        RequirementState.met,
        reason: 'one result, on every draft that was waiting for it',
      );
    });

    test('the draft is an application like any other on the record', () {
      cubit.startApplication(diploma.id, now: designDay);

      expect(
        cubit.state.hasActiveApplication(
          category: ProgrammeCategory.diploma,
          session: '2026/2027',
        ),
        isTrue,
      );
      expect(
        cubit.state.jambLinkApplication?.id,
        AdmissionsFixtures.draftApplication.id,
        reason: 'the result still binds to the draft that was waiting on it',
      );
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
