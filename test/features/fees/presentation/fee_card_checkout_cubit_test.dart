import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_card_checkout_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_card_checkout_state.dart';
import 'package:the_legion_mobile/features/fees/presentation/mock/fees_fixtures.dart';

void main() {
  late FeeCardCheckoutCubit cubit;

  setUp(() => cubit = FeeCardCheckoutCubit());
  tearDown(() => cubit.close());

  void startAll() {
    cubit.start(
      invoices: FeesFixtures.invoices,
      student: FeesFixtures.student,
      session: FeesFixtures.session,
      terms: FeesFixtures.terms,
    );
  }

  test('starts with the schedule and a pending transaction reference', () {
    startAll();

    expect(cubit.state.isStarted, isTrue);
    expect(cubit.state.session?.totalMinorUnits, 6635000);
    expect(
      cubit.state.transactionReference,
      FeesFixtures.pendingTransactionReference,
    );
    expect(cubit.state.canPay, isFalse);
    expect(cubit.payReference(), isNull);
  });

  blocTest<FeeCardCheckoutCubit, FeeCardCheckoutState>(
    'Pay is offered only once the card fields look complete',
    build: FeeCardCheckoutCubit.new,
    act: (cubit) {
      cubit.start(
        invoices: FeesFixtures.invoices,
        student: FeesFixtures.student,
        session: FeesFixtures.session,
        terms: FeesFixtures.terms,
      );
      cubit.cardNumberChanged('5399123456784012');
      cubit.expiryChanged('12/28');
      cubit.cvvChanged('123');
      cubit.pinChanged('1234');
    },
    verify: (cubit) {
      expect(cubit.state.canPay, isTrue);
      expect(cubit.state.problem, isNull);
      expect(cubit.payReference(), FeesFixtures.pendingTransactionReference);
    },
  );

  test('rejects a short card number', () {
    startAll();
    cubit.cardNumberChanged('5399');
    cubit.expiryChanged('12/28');
    cubit.cvvChanged('123');
    cubit.pinChanged('1234');

    expect(cubit.state.problem, CardFieldProblem.cardNumber);
    expect(cubit.state.canPay, isFalse);
  });
}
