import '../models/fees_models.dart';

/// Sample content for the student fees screens.
///
/// Presentation-only placeholders: delete this file once the bursary's
/// endpoints exist and feed the models from a repository. The student, the
/// invoices and the receipts are invented for the mock, in the shapes the
/// designs under `ui-designs/fees/` draw.
abstract final class FeesFixtures {
  /// The session the ledger is for.
  static const String session = '2026/2027';

  static const FeesStudent student = FeesStudent(
    name: 'Amaka Bello',
    matricNumber: '23/CSC/0412',
    level: 300,
    department: 'Computer Science',
    faculty: 'Faculty of Science',
    email: 'amaka.bello@legion.edu.ng',
  );

  /// The one deadline both open bills share.
  static final DateTime dueOn = DateTime(2027, 3, 15);

  /// The composite tuition bill, two thirds cleared.
  static final Invoice tuition = Invoice(
    id: 'inv-08821',
    reference: 'INV-2026-08821',
    title: '300 Level Composite Tuition',
    subtitle: 'Faculty of Science · Computer Science',
    shortLabel: 'Tuition balance',
    lineLabel: 'Tuition balance (300 Level)',
    session: session,
    status: InvoiceStatus.partiallyPaid,
    totalMinorUnits: 16500000,
    paidMinorUnits: 11500000,
    dueOn: dueOn,
  );

  /// The faculty levy, untouched.
  static final Invoice ictLevy = Invoice(
    id: 'inv-09104',
    reference: 'INV-2026-09104',
    title: 'Faculty of Science ICT & Lab Levy',
    subtitle: 'Faculty of Science · Computer Science',
    shortLabel: 'Faculty levy',
    lineLabel: 'Faculty ICT & Lab levy',
    session: session,
    status: InvoiceStatus.open,
    totalMinorUnits: 1600000,
    paidMinorUnits: 0,
    dueOn: dueOn,
  );

  /// Newest first, the order the screen lists them in.
  static final List<Invoice> invoices = [tuition, ictLevy];

  static final List<PaymentRecord> payments = [
    PaymentRecord(
      id: 'rec-04412',
      reference: 'REC-2026-04412',
      title: 'Tuition Instalment 1',
      amountMinorUnits: 11500000,
      paidOn: DateTime(2027, 1, 12),
      channel: PaymentChannel.remitaRrr,
      channelReference: '2401-9982-1102',
      status: PaymentStatus.succeeded,
      invoiceId: 'inv-08821',
    ),
    PaymentRecord(
      id: 'rec-01009',
      reference: 'REC-2026-01009',
      title: 'Departmental Dues (CSC)',
      amountMinorUnits: 1250000,
      paidOn: DateTime(2026, 10, 15),
      channel: PaymentChannel.card,
      status: PaymentStatus.succeeded,
    ),
  ];

  static const PaymentTerms terms = PaymentTerms(
    gatewayChargeMinorUnits: 35000,
    minimumInstalmentMinorUnits: 2500000,
    bankBranchReference: '2409-8812-9014',
  );

  /// The whole record, as the cubit reads it.
  static final FeesLedger ledger = FeesLedger(
    student: student,
    session: session,
    invoices: invoices,
    payments: payments,
    terms: terms,
  );
}
