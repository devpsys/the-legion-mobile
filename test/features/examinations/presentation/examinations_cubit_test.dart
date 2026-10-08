import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/examinations/presentation/bloc/examinations_cubit.dart';
import 'package:the_legion_mobile/features/examinations/presentation/bloc/examinations_state.dart';
import 'package:the_legion_mobile/features/examinations/presentation/mock/examinations_fixtures.dart';
import 'package:the_legion_mobile/features/examinations/presentation/models/examinations_models.dart';

void main() {
  ExaminationsCubit started([ExaminationsLedger? ledger]) =>
      ExaminationsCubit(ledger: ledger)..load();

  test('loads Amaka in good standing with a published term', () {
    final cubit = started();

    expect(cubit.state.status, ExaminationsStatus.ready);
    expect(cubit.state.results?.status, ResultsStatus.published);
    expect(cubit.state.results?.cgpa, 3.62);
    expect(cubit.state.results?.standing, StandingKind.good);
  });

  test('the probation ledger puts the same student on probation', () {
    final cubit = started(ExaminationsFixtures.probationLedger);

    expect(cubit.state.results?.cgpa, 1.84);
    expect(cubit.state.results?.standing, StandingKind.probation);
  });

  test('the unpublished ledger has no results to show', () {
    final cubit = started(ExaminationsFixtures.unpublishedLedger);

    expect(cubit.state.results?.status, ResultsStatus.unpublished);
  });

  group('registerResit', () {
    test('moves the failure to registered and spends the units', () {
      final cubit = started();
      final before = cubit.state.resits!;

      expect(cubit.registerResit('CSC 211'), isTrue);

      final after = cubit.state.resits!;
      expect(after.unitsUsed, before.unitsUsed + 3);
      expect(after.failureFor('CSC 211'), isNull);
      expect(
        after.registrations.map((entry) => entry.code),
        contains('CSC 211'),
      );
      expect(cubit.state.notice, ExaminationsNotice.resitRegistered);
    });

    test('invoices the fee per unit rather than charging it', () {
      final cubit = started();

      cubit.registerResit('CSC 211');

      final registration = cubit.state.resits!.registrations.last;
      expect(
        registration.feeMinorUnits,
        3 * ExaminationsFixtures.resitFeePerUnitMinorUnits,
      );
      expect(registration.invoiceReference, startsWith('RS-'));
    });

    test('refuses a course that is not on the failure list', () {
      final cubit = started();

      expect(cubit.registerResit('CSC 999'), isFalse);
    });

    test('refuses once the window is closed', () {
      final cubit = started(ExaminationsFixtures.resitsClosedLedger);

      expect(cubit.registerResit('CSC 211'), isFalse);
      expect(cubit.state.notice, ExaminationsNotice.resitWindowClosed);
    });

    test('refuses a course that would pass the unit allowance', () {
      final cubit = started();

      // 3 of 6 units are already registered, so one more course fits and the
      // next does not.
      expect(cubit.registerResit('CSC 211'), isTrue);
      expect(cubit.state.resits!.unitsLeft, 0);

      expect(cubit.registerResit('PHY 201'), isFalse);
      expect(cubit.state.notice, ExaminationsNotice.resitOverBudget);
      expect(cubit.state.resits!.failureFor('PHY 201'), isNotNull);
    });
  });
}
