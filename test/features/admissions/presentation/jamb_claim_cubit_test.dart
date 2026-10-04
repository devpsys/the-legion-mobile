import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/jamb_claim_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/jamb_claim_state.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/admissions_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/jamb_models.dart';

void main() {
  final record = AdmissionsFixtures.jambResult;
  final born = DateTime(2008, 5, 2);

  group('normaliseJambRegistrationNumber', () {
    test('upper-cases and strips the spaces and hyphens people add', () {
      expect(
        normaliseJambRegistrationNumber(' 2026 3011-2233 ab '),
        '202630112233AB',
      );
    });

    test('knows the shape of a complete number', () {
      expect(isCompleteJambRegistrationNumber('202630112233AB'), isTrue);
      expect(isCompleteJambRegistrationNumber('2026 3011 2233 ab'), isTrue);
      expect(isCompleteJambRegistrationNumber('20263011223AB'), isFalse);
      expect(isCompleteJambRegistrationNumber('202630112233A'), isFalse);
      expect(isCompleteJambRegistrationNumber('202630112233ABC'), isFalse);
      expect(isCompleteJambRegistrationNumber(''), isFalse);
    });
  });

  group('JambResult.matches', () {
    JambClaimRequest request({
      String number = '202630112233AB',
      String surname = 'IBRAHIM',
      DateTime? dateOfBirth,
    }) => JambClaimRequest(
      registrationNumber: number,
      surname: surname,
      dateOfBirth: dateOfBirth ?? born,
    );

    test(
      'matches the number however it is typed and the surname in any case',
      () {
        expect(record.matches(request()), isTrue);
        expect(
          record.matches(
            request(number: '2026 3011 2233 ab', surname: ' ibrahim '),
          ),
          isTrue,
        );
      },
    );

    test('is strict about the number, the surname and the day', () {
      expect(record.matches(request(number: '202630112233AC')), isFalse);
      expect(record.matches(request(surname: 'IBRAHIMS')), isFalse);
      expect(
        record.matches(request(dateOfBirth: DateTime(2008, 5, 3))),
        isFalse,
      );
    });

    test('ignores the time of day on the birthday', () {
      expect(
        record.matches(request(dateOfBirth: DateTime(2008, 5, 2, 14, 30))),
        isTrue,
      );
    });
  });

  group('AdmissionsFixtures.matchJambResult', () {
    test('answers the candidate\'s own facts', () {
      final found = AdmissionsFixtures.matchJambResult(
        JambClaimRequest(
          registrationNumber: '202630112233AB',
          surname: 'Ibrahim',
          dateOfBirth: born,
        ),
      );

      expect(found, record);
      expect(found!.candidateName, 'Musa Ibrahim');
      expect(found.aggregateScore, 312);
      expect(found.subjects.map((s) => s.score).toList(), [74, 82, 78, 78]);
    });

    test('has nothing for somebody else\'s facts', () {
      expect(
        AdmissionsFixtures.matchJambResult(
          JambClaimRequest(
            registrationNumber: '202630112233AB',
            surname: 'Adeyemi',
            dateOfBirth: born,
          ),
        ),
        isNull,
      );
    });

    test('links the result to the draft, whose checklist waits on it', () {
      expect(
        AdmissionsFixtures.jambLinkApplicationId,
        AdmissionsFixtures.draftApplication.id,
      );
    });
  });

  group('JambClaimCubit', () {
    late JambClaimCubit cubit;

    setUp(() => cubit = JambClaimCubit());
    tearDown(() => cubit.close());

    void fillValid({String surname = 'IBRAHIM'}) {
      cubit
        ..registrationNumberChanged('202630112233AB')
        ..surnameChanged(surname)
        ..dateOfBirthChanged(born);
    }

    test('starts idle with nothing typed', () {
      expect(cubit.state.status, JambClaimStatus.idle);
      expect(cubit.state.isComplete, isFalse);
      expect(cubit.state.canMatch, isFalse);
      expect(cubit.state.canConfirm, isFalse);
      expect(cubit.state.request, isNull);
    });

    test('will not match until all three facts are in', () {
      cubit
        ..registrationNumberChanged('202630112233AB')
        ..surnameChanged('IBRAHIM')
        ..match();
      expect(cubit.state.status, JambClaimStatus.idle);

      cubit
        ..surnameChanged('   ')
        ..dateOfBirthChanged(born)
        ..match();
      expect(cubit.state.status, JambClaimStatus.idle, reason: 'blank surname');

      cubit
        ..surnameChanged('IBRAHIM')
        ..registrationNumberChanged('2026301122')
        ..match();
      expect(
        cubit.state.status,
        JambClaimStatus.idle,
        reason: 'number not yet the right shape',
      );
    });

    test('knows when the number is complete', () {
      cubit.registrationNumberChanged('2026301122');
      expect(cubit.state.isRegistrationNumberComplete, isFalse);

      cubit.registrationNumberChanged('202630112233AB');
      expect(cubit.state.isRegistrationNumberComplete, isTrue);
    });

    test('matches the candidate\'s record and keeps what CAPS holds', () {
      fillValid();
      cubit.match();

      expect(cubit.state.status, JambClaimStatus.matched);
      expect(cubit.state.result, record);
      expect(cubit.state.canConfirm, isTrue);
    });

    test('reports facts the import does not know', () {
      fillValid(surname: 'ADEYEMI');
      cubit.match();

      expect(cubit.state.status, JambClaimStatus.notFound);
      expect(cubit.state.result, isNull);
      expect(cubit.state.canConfirm, isFalse);
      expect(cubit.state.canMatch, isTrue, reason: 'the candidate may retry');
    });

    test('voids the last answer as soon as any fact changes', () {
      fillValid();
      cubit.match();
      expect(cubit.state.status, JambClaimStatus.matched);

      cubit.surnameChanged('IBRAHI');
      expect(cubit.state.status, JambClaimStatus.idle);
      expect(cubit.state.result, isNull);

      cubit
        ..surnameChanged('IBRAHIM')
        ..match();
      expect(cubit.state.status, JambClaimStatus.matched);

      cubit.dateOfBirthChanged(DateTime(2008, 5, 3));
      expect(cubit.state.status, JambClaimStatus.idle);

      cubit
        ..dateOfBirthChanged(born)
        ..match();
      cubit.registrationNumberChanged('202630112233A');
      expect(cubit.state.status, JambClaimStatus.idle);
    });

    test('ignores a change to the same value', () async {
      fillValid();
      cubit.match();
      final matched = cubit.state;

      cubit
        ..surnameChanged('IBRAHIM')
        ..dateOfBirthChanged(born)
        ..registrationNumberChanged('202630112233AB');

      expect(cubit.state, matched, reason: 'nothing changed, nothing voided');
    });

    test('passes through matching on the way to an answer', () async {
      final seen = <JambClaimStatus>[];
      final subscription = cubit.stream.listen((s) => seen.add(s.status));
      addTearDown(subscription.cancel);

      fillValid();
      cubit.match();
      await Future<void>.delayed(Duration.zero);

      expect(seen.where((s) => s == JambClaimStatus.matching), hasLength(1));
      expect(seen.last, JambClaimStatus.matched);
    });

    test('consults whatever import it is given', () {
      final seen = <JambClaimRequest>[];
      final custom = JambClaimCubit(
        lookup: (request) {
          seen.add(request);
          return null;
        },
      );
      addTearDown(custom.close);

      custom
        ..registrationNumberChanged('202630112233AB')
        ..surnameChanged('IBRAHIM')
        ..dateOfBirthChanged(born)
        ..match();

      expect(seen, hasLength(1));
      expect(seen.single.surname, 'IBRAHIM');
      expect(custom.state.status, JambClaimStatus.notFound);
    });
  });
}
