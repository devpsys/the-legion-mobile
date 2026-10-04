import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fees_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fees_state.dart';
import 'package:the_legion_mobile/features/fees/presentation/mock/fees_fixtures.dart';
import 'package:the_legion_mobile/features/fees/presentation/models/fees_models.dart';

void main() {
  group('FeesCubit', () {
    test('starts with nothing loaded', () {
      final cubit = FeesCubit();
      addTearDown(cubit.close);

      expect(cubit.state, const FeesState());
      expect(cubit.state.student, isNull);
      expect(cubit.state.hasOutstanding, isFalse);
    });

    blocTest<FeesCubit, FeesState>(
      'load reads the ledger into a ready state',
      build: FeesCubit.new,
      act: (cubit) => cubit.load(),
      expect: () => [
        const FeesState(status: FeesStatus.loading),
        FeesState(
          status: FeesStatus.ready,
          student: FeesFixtures.student,
          session: FeesFixtures.session,
          invoices: FeesFixtures.invoices,
          payments: FeesFixtures.payments,
          terms: FeesFixtures.terms,
        ),
      ],
    );

    blocTest<FeesCubit, FeesState>(
      'load is idempotent once ready',
      build: FeesCubit.new,
      seed: () => FeesState(
        status: FeesStatus.ready,
        student: FeesFixtures.student,
        session: FeesFixtures.session,
        invoices: FeesFixtures.invoices,
        payments: FeesFixtures.payments,
        terms: FeesFixtures.terms,
      ),
      act: (cubit) => cubit.load(),
      expect: () => <FeesState>[],
    );

    test('reads whatever ledger it is handed', () {
      final ledger = FeesLedger(
        student: FeesFixtures.student,
        session: '2027/2028',
        invoices: const [],
        payments: const [],
        terms: FeesFixtures.terms,
      );
      final cubit = FeesCubit(ledger: ledger);
      addTearDown(cubit.close);

      cubit.load();

      expect(cubit.state.status, FeesStatus.ready);
      expect(cubit.state.session, '2027/2028');
      expect(cubit.state.invoices, isEmpty);
      expect(cubit.state.outstandingMinorUnits, 0);
    });
  });
}
