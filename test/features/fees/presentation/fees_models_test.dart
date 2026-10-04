import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/theme/app_tone.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fees_state.dart';
import 'package:the_legion_mobile/features/fees/presentation/mock/fees_fixtures.dart';
import 'package:the_legion_mobile/features/fees/presentation/models/fees_models.dart';

/// An invoice with the fields a test does not care about filled in.
Invoice invoice({
  required String id,
  required InvoiceStatus status,
  required int total,
  required int paid,
  DateTime? dueOn,
}) => Invoice(
  id: id,
  reference: id.toUpperCase(),
  title: id,
  subtitle: id,
  shortLabel: id,
  lineLabel: id,
  session: '2026/2027',
  status: status,
  totalMinorUnits: total,
  paidMinorUnits: paid,
  dueOn: dueOn ?? DateTime(2027, 3, 15),
);

void main() {
  group('InvoiceStatus', () {
    test('owes money only while open or part paid', () {
      expect(InvoiceStatus.open.isOutstanding, isTrue);
      expect(InvoiceStatus.partiallyPaid.isOutstanding, isTrue);
      expect(InvoiceStatus.paid.isOutstanding, isFalse);
      expect(InvoiceStatus.cancelled.isOutstanding, isFalse);
    });

    test('colours urgency the way the rest of the app does', () {
      expect(InvoiceStatus.open.tone, AppTone.danger);
      expect(InvoiceStatus.partiallyPaid.tone, AppTone.warning);
      expect(InvoiceStatus.paid.tone, AppTone.success);
      expect(InvoiceStatus.cancelled.tone, AppTone.neutral);
    });
  });

  group('PaymentStatus', () {
    test('keeps an unconfirmed payment amber', () {
      expect(PaymentStatus.pending.tone, AppTone.warning);
      expect(PaymentStatus.succeeded.tone, AppTone.success);
    });
  });

  group('Invoice', () {
    test('derives the balance and the progress from billed and paid', () {
      final tuition = FeesFixtures.tuition;

      expect(tuition.balanceMinorUnits, 5000000);
      expect(tuition.paidFraction, closeTo(115 / 165, 0.0001));
      expect(tuition.paidPercent, 70);
    });

    test('never reports a negative balance', () {
      // An overpayment goes to the wallet, not against the bill.
      final overpaid = invoice(
        id: 'over',
        status: InvoiceStatus.paid,
        total: 100000,
        paid: 150000,
      );

      expect(overpaid.balanceMinorUnits, 0);
      expect(overpaid.paidFraction, 1);
      expect(overpaid.paidPercent, 100);
    });

    test('treats a bill of nothing as nothing paid', () {
      final empty = invoice(
        id: 'empty',
        status: InvoiceStatus.open,
        total: 0,
        paid: 0,
      );

      expect(empty.paidFraction, 0);
      expect(empty.paidPercent, 0);
    });
  });

  group('FeesState', () {
    final ledger = FeesFixtures.ledger;
    final ready = FeesState(
      status: FeesStatus.ready,
      student: ledger.student,
      session: ledger.session,
      invoices: ledger.invoices,
      payments: ledger.payments,
      terms: ledger.terms,
    );

    test('sums the outstanding total over the open invoices', () {
      expect(ready.outstandingInvoices, hasLength(2));
      expect(ready.outstandingMinorUnits, 6600000);
      expect(ready.hasOutstanding, isTrue);
    });

    test('leaves settled and cancelled invoices out of the total', () {
      final state = ready.copyWith(
        invoices: [
          ...ledger.invoices,
          invoice(
            id: 'settled',
            status: InvoiceStatus.paid,
            total: 1000000,
            paid: 1000000,
          ),
          invoice(
            id: 'cancelled',
            status: InvoiceStatus.cancelled,
            total: 1000000,
            paid: 0,
          ),
        ],
      );

      expect(state.outstandingInvoices.map((i) => i.id), [
        'inv-08821',
        'inv-09104',
      ]);
      expect(state.outstandingMinorUnits, 6600000);
    });

    test('quotes the earliest open deadline, or none', () {
      expect(ready.nextDueOn, DateTime(2027, 3, 15));

      final staggered = ready.copyWith(
        invoices: [
          invoice(
            id: 'later',
            status: InvoiceStatus.open,
            total: 100,
            paid: 0,
            dueOn: DateTime(2027, 6, 1),
          ),
          invoice(
            id: 'sooner',
            status: InvoiceStatus.open,
            total: 100,
            paid: 0,
            dueOn: DateTime(2027, 2, 1),
          ),
        ],
      );
      expect(staggered.nextDueOn, DateTime(2027, 2, 1));

      expect(ready.copyWith(invoices: const []).nextDueOn, isNull);
      expect(ready.copyWith(invoices: const []).hasOutstanding, isFalse);
    });

    test('resolves a checkout to all open invoices when none are named', () {
      expect(ready.outstandingInvoicesFor(const []), ready.outstandingInvoices);
    });

    test('resolves a checkout to the named open invoices, in ledger order', () {
      expect(
        ready
            .outstandingInvoicesFor(['inv-09104', 'inv-08821'])
            .map((i) => i.id),
        ['inv-08821', 'inv-09104'],
      );
      expect(ready.outstandingInvoicesFor(['inv-09104']).map((i) => i.id), [
        'inv-09104',
      ]);
    });

    test('drops an id that is not an open invoice', () {
      // A stale link must not put a settled bill back on the till.
      expect(ready.outstandingInvoicesFor(['nope']), isEmpty);

      final settled = ready.copyWith(
        invoices: [
          invoice(
            id: 'inv-08821',
            status: InvoiceStatus.paid,
            total: 100,
            paid: 100,
          ),
        ],
      );
      expect(settled.outstandingInvoicesFor(['inv-08821']), isEmpty);
    });
  });
}
