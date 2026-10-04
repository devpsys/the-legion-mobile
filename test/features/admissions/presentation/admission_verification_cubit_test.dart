import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admission_verification_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admission_verification_state.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/admissions_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/admissions_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/application_detail_models.dart';

void main() {
  group('normaliseVerificationCode', () {
    test('upper-cases and strips the spaces and hyphens people add', () {
      expect(normaliseVerificationCode(' 7kq2-m9xw 4hpa '), '7KQ2M9XW4HPA');
    });

    test('knows the shape of a complete code', () {
      expect(isCompleteVerificationCode('7KQ2 M9XW 4HPA'), isTrue);
      expect(isCompleteVerificationCode('7KQ2M9XW'), isFalse);
      expect(isCompleteVerificationCode(''), isFalse);
    });
  });

  group('AdmissionsFixtures.verify', () {
    test('answers the code on every issued letter, however it is typed', () {
      final offered = AdmissionsFixtures.verify(
        AdmissionsFixtures.offeredLetter.verificationCode.toLowerCase(),
      );
      expect(offered, isNotNull);
      expect(offered!.status, ApplicationStatus.offered);
      expect(offered.matricNumber, isNull);

      final matriculated = AdmissionsFixtures.verify(
        AdmissionsFixtures.matriculatedLetter.verificationCode,
      );
      expect(matriculated!.status, ApplicationStatus.matriculated);
      expect(matriculated.matricNumber, isNotNull);
    });

    test('has nothing for a code it never issued', () {
      expect(AdmissionsFixtures.verify('AAAAAAAAAAAA'), isNull);
    });
  });

  group('AdmissionVerificationCubit', () {
    late AdmissionVerificationCubit cubit;

    setUp(() => cubit = AdmissionVerificationCubit());
    tearDown(() => cubit.close());

    test('starts idle with nothing typed', () {
      expect(cubit.state.status, AdmissionVerificationStatus.idle);
      expect(cubit.state.code, isEmpty);
      expect(cubit.state.canVerify, isFalse);
    });

    test('will not look up a code that is not yet complete', () {
      cubit
        ..codeChanged('7KQ2')
        ..verify();

      expect(cubit.state.status, AdmissionVerificationStatus.idle);
      expect(cubit.state.result, isNull);
    });

    test('verifies a genuine code and keeps what the letter prints', () {
      cubit
        ..codeChanged('7kq2 m9xw 4hpa')
        ..verify();

      expect(cubit.state.status, AdmissionVerificationStatus.verified);
      expect(cubit.state.result?.candidateName, 'Musa Ibrahim');
      expect(cubit.state.result?.session, '2026/2027');
    });

    test('reports a code the register does not know', () {
      cubit
        ..codeChanged('ZZZZZZZZZZZZ')
        ..verify();

      expect(cubit.state.status, AdmissionVerificationStatus.notFound);
      expect(cubit.state.result, isNull);
    });

    test('voids the last answer as soon as the code changes', () {
      cubit
        ..codeChanged('7KQ2M9XW4HPA')
        ..verify();
      expect(cubit.state.status, AdmissionVerificationStatus.verified);

      cubit.codeChanged('7KQ2M9XW4HP');

      expect(cubit.state.status, AdmissionVerificationStatus.idle);
      expect(cubit.state.result, isNull);
    });

    test('checks a code that arrived in the link in one step', () {
      cubit.verifyCode('P3HD7VQ2TM8K');

      expect(cubit.state.code, 'P3HD7VQ2TM8K');
      expect(cubit.state.status, AdmissionVerificationStatus.verified);
      expect(cubit.state.result?.matricNumber, '25/ACC/0087');
    });

    test('consults whatever register it is given', () async {
      final seen = <String>[];
      final custom = AdmissionVerificationCubit(
        lookup: (code) {
          seen.add(code);
          return null;
        },
      );
      addTearDown(custom.close);

      custom.verifyCode('ABCDEFGHJKLM');

      expect(seen, ['ABCDEFGHJKLM']);
      expect(custom.state.status, AdmissionVerificationStatus.notFound);
    });
  });
}
