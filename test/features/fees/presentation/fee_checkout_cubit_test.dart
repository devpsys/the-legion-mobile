import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_checkout_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_checkout_state.dart';
import 'package:the_legion_mobile/features/fees/presentation/mock/fees_fixtures.dart';
import 'package:the_legion_mobile/features/fees/presentation/models/fees_models.dart';

void main() {
  late FeeCheckoutCubit cubit;

  setUp(() => cubit = FeeCheckoutCubit());
  tearDown(() => cubit.close());

  /// Starts a visit for every open invoice on the fixture ledger.
  void startAll() =>
      cubit.start(invoices: FeesFixtures.invoices, terms: FeesFixtures.terms);

  group('before the visit starts', () {
    test('has nothing to pay and cannot proceed', () {
      expect(cubit.state.isStarted, isFalse);
      expect(cubit.state.balanceMinorUnits, 0);
      expect(cubit.state.payableMinorUnits, 0);
      expect(cubit.state.canProceed, isFalse);
      expect(cubit.state.allowsInstalment, isFalse);
    });
  });

  group('start', () {
    test('copies the invoices and terms in, with the full balance chosen', () {
      startAll();

      expect(cubit.state.isStarted, isTrue);
      expect(cubit.state.invoices, FeesFixtures.invoices);
      expect(cubit.state.amountMode, PaymentAmountMode.full);
      expect(cubit.state.method, PaymentMethod.gateway);
      expect(cubit.state.instalmentMinorUnits, isNull);
    });

    test('derives every figure from the invoices and the terms', () {
      startAll();

      expect(cubit.state.balanceMinorUnits, 6600000);
      expect(cubit.state.gatewayChargeMinorUnits, 35000);
      expect(cubit.state.fullPayableMinorUnits, 6635000);
      expect(cubit.state.amountMinorUnits, 6600000);
      expect(cubit.state.payableMinorUnits, 6635000);
      expect(cubit.state.canProceed, isTrue);
    });

    test('resets the last visit\'s choices', () {
      startAll();
      cubit
        ..amountModeChanged(PaymentAmountMode.instalment)
        ..instalmentChanged('30000')
        ..methodChanged(PaymentMethod.bankBranch);

      cubit.start(invoices: [FeesFixtures.ictLevy], terms: FeesFixtures.terms);

      expect(cubit.state.invoices, [FeesFixtures.ictLevy]);
      expect(cubit.state.amountMode, PaymentAmountMode.full);
      expect(cubit.state.method, PaymentMethod.gateway);
      expect(cubit.state.instalmentMinorUnits, isNull);
    });

    test('cannot proceed on invoices with nothing owed', () {
      cubit.start(
        invoices: [
          Invoice(
            id: 'settled',
            reference: 'INV-0',
            title: 'Settled',
            subtitle: 'Settled',
            shortLabel: 'Settled',
            lineLabel: 'Settled',
            session: '2026/2027',
            status: InvoiceStatus.paid,
            totalMinorUnits: 100,
            paidMinorUnits: 100,
            dueOn: DateTime(2027),
          ),
        ],
        terms: FeesFixtures.terms,
      );

      expect(cubit.state.balanceMinorUnits, 0);
      expect(cubit.state.canProceed, isFalse);
    });
  });

  group('the instalment option', () {
    test('is offered only while the balance is above the minimum', () {
      startAll();
      expect(cubit.state.allowsInstalment, isTrue);

      // The levy alone is ₦16,000.00, under the ₦25,000.00 minimum: the only
      // permitted instalment would be the whole balance.
      cubit.start(invoices: [FeesFixtures.ictLevy], terms: FeesFixtures.terms);
      expect(cubit.state.allowsInstalment, isFalse);
    });

    test('has no amount until one is typed', () {
      startAll();
      cubit.amountModeChanged(PaymentAmountMode.instalment);

      expect(cubit.state.amountMinorUnits, isNull);
      expect(cubit.state.payableMinorUnits, isNull);
      expect(cubit.state.instalmentProblem, InstalmentProblem.missing);
      expect(cubit.state.canProceed, isFalse);
    });

    test('takes a typed amount and adds the charge on top', () {
      startAll();
      cubit
        ..amountModeChanged(PaymentAmountMode.instalment)
        ..instalmentChanged('30,000.00');

      expect(cubit.state.instalmentMinorUnits, 3000000);
      expect(cubit.state.amountMinorUnits, 3000000);
      expect(cubit.state.payableMinorUnits, 3035000);
      expect(cubit.state.instalmentProblem, isNull);
      expect(cubit.state.canProceed, isTrue);
    });

    test('names an amount under the minimum', () {
      startAll();
      cubit
        ..amountModeChanged(PaymentAmountMode.instalment)
        ..instalmentChanged('24,999.99');

      expect(cubit.state.instalmentProblem, InstalmentProblem.belowMinimum);
      expect(cubit.state.canProceed, isFalse);

      cubit.instalmentChanged('25,000.00');
      expect(cubit.state.instalmentProblem, isNull);
      expect(cubit.state.canProceed, isTrue);
    });

    test('names an amount over the balance', () {
      startAll();
      cubit
        ..amountModeChanged(PaymentAmountMode.instalment)
        ..instalmentChanged('66,000.01');

      expect(cubit.state.instalmentProblem, InstalmentProblem.aboveBalance);
      expect(cubit.state.canProceed, isFalse);

      cubit.instalmentChanged('66,000.00');
      expect(cubit.state.instalmentProblem, isNull);
    });

    test('clears the figure when the text stops being an amount', () {
      startAll();
      cubit
        ..amountModeChanged(PaymentAmountMode.instalment)
        ..instalmentChanged('30000');
      expect(cubit.state.instalmentMinorUnits, 3000000);

      cubit.instalmentChanged('30000.123');
      expect(
        cubit.state.instalmentMinorUnits,
        isNull,
        reason: 'the button must never offer a figure no longer in the field',
      );
      expect(cubit.state.canProceed, isFalse);
    });

    test('is ignored while the full balance is chosen', () {
      startAll();
      cubit.instalmentChanged('1');

      expect(cubit.state.instalmentMinorUnits, 100);
      expect(cubit.state.instalmentProblem, isNull);
      expect(cubit.state.payableMinorUnits, 6635000);
      expect(cubit.state.canProceed, isTrue);
    });

    test('does not emit for a choice already made', () {
      startAll();
      final states = <FeeCheckoutState>[];
      final subscription = cubit.stream.listen(states.add);
      addTearDown(subscription.cancel);

      cubit
        ..amountModeChanged(PaymentAmountMode.full)
        ..methodChanged(PaymentMethod.gateway)
        ..instalmentChanged('')
        ..instalmentChanged('abc');

      expect(states, isEmpty);
    });
  });

  group('the method', () {
    test('is recorded and does not touch the amount', () {
      startAll();
      cubit.methodChanged(PaymentMethod.virtualAccount);

      expect(cubit.state.method, PaymentMethod.virtualAccount);
      expect(cubit.state.payableMinorUnits, 6635000);
    });
  });
}
