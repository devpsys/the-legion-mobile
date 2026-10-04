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

    /// Cleared gateway payment that matches the card-checkout total in the
    /// designs — history and the official receipt open on this id.
    PaymentRecord(
      id: 'rec-098812',
      reference: 'REC-2027-098812',
      title: 'Tuition balance & faculty levy',
      amountMinorUnits: 6635000,
      paidOn: DateTime(2027, 1, 15, 10, 42),
      channel: PaymentChannel.card,
      channelReference: '2409-8812-9014',
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

  /// Transaction reference the card checkout hands the gateway.
  static const String pendingTransactionReference = 'TXN-2027-PENDING';

  /// Cleared gateway return that matches [gatewayReceipt].
  static const String succeededTransactionReference = 'TXN-2027-098812';

  static const String failedTransactionReference = 'TXN-2027-FAILED';

  static const String expiredTransactionReference = 'TXN-2027-EXPIRED';

  /// Verification code printed on [gatewayReceipt] and accepted by the
  /// public check.
  static const String receiptVerificationCode = '9K8L4M2PTX77';

  /// Pay opens onto this: amber, awaiting confirmation, never a success.
  static final GatewayReturn pendingReturn = GatewayReturn(
    reference: pendingTransactionReference,
    status: GatewayReturnStatus.pending,
    amountMinorUnits: 6635000,
    occurredOn: DateTime(2027, 1, 15, 10, 42),
    studentName: student.name,
    matricNumber: student.matricNumber,
    channelLabel: 'Card',
    rrr: terms.bankBranchReference,
    gatewayReference: pendingTransactionReference,
    paidFor: 'Tuition balance & faculty levy',
  );

  /// The success state of the dark gateway-return design.
  static final GatewayReturn succeededReturn = GatewayReturn(
    reference: succeededTransactionReference,
    status: GatewayReturnStatus.succeeded,
    amountMinorUnits: 6635000,
    occurredOn: DateTime(2027, 1, 15, 10, 42),
    studentName: student.name,
    matricNumber: student.matricNumber,
    channelLabel: 'Card (Mastercard)',
    rrr: terms.bankBranchReference,
    gatewayReference: succeededTransactionReference,
    paidFor: 'Tuition balance & faculty levy',
    receiptId: 'rec-098812',
    authCode: 'AUTHSUM',
  );

  static final GatewayReturn failedReturn = GatewayReturn(
    reference: failedTransactionReference,
    status: GatewayReturnStatus.failed,
    amountMinorUnits: 6635000,
    occurredOn: DateTime(2027, 1, 15, 10, 42),
    studentName: student.name,
    matricNumber: student.matricNumber,
    channelLabel: 'Card',
    gatewayReference: failedTransactionReference,
    paidFor: 'Tuition balance & faculty levy',
  );

  static final GatewayReturn expiredReturn = GatewayReturn(
    reference: expiredTransactionReference,
    status: GatewayReturnStatus.expired,
    amountMinorUnits: 6635000,
    occurredOn: DateTime(2027, 1, 15, 10, 42),
    studentName: student.name,
    matricNumber: student.matricNumber,
    channelLabel: 'Card',
    gatewayReference: expiredTransactionReference,
    paidFor: 'Tuition balance & faculty levy',
  );

  static final Map<String, GatewayReturn> gatewayReturns = {
    pendingReturn.reference: pendingReturn,
    succeededReturn.reference: succeededReturn,
    failedReturn.reference: failedReturn,
    expiredReturn.reference: expiredReturn,
  };

  /// Official e-receipt for the cleared gateway payment.
  static final OfficialReceipt gatewayReceipt = OfficialReceipt(
    id: 'rec-098812',
    receiptNumber: 'REC-2027-098812',
    verificationCode: receiptVerificationCode,
    issuedOn: DateTime(2027, 1, 15, 10, 42),
    session: session,
    studentName: student.name,
    matricNumber: student.matricNumber,
    faculty: student.faculty,
    department: student.department,
    level: student.level,
    lines: [
      OfficialReceiptLine(
        label: 'Tuition balance (300 Level)',
        session: session,
        amountMinorUnits: 5000000,
      ),
      OfficialReceiptLine(
        label: 'Faculty ICT & Lab levy',
        session: session,
        amountMinorUnits: 1600000,
      ),
      OfficialReceiptLine(
        label: 'Gateway processing charge (statutory)',
        session: session,
        amountMinorUnits: terms.gatewayChargeMinorUnits,
      ),
    ],
    totalMinorUnits: 6635000,
    channelLabel: 'Interswitch / Mastercard',
    rrr: terms.bankBranchReference,
    clearingReference: succeededTransactionReference,
    authCode: 'AUTHSUM',
  );

  /// Older history receipts, enough for the history cards to open a paper.
  static final OfficialReceipt tuitionInstalmentReceipt = OfficialReceipt(
    id: 'rec-04412',
    receiptNumber: 'REC-2026-04412',
    verificationCode: 'A1B2C3D4E5F6',
    issuedOn: DateTime(2027, 1, 12),
    session: session,
    studentName: student.name,
    matricNumber: student.matricNumber,
    faculty: student.faculty,
    department: student.department,
    level: student.level,
    lines: [
      OfficialReceiptLine(
        label: 'Tuition Instalment 1',
        session: session,
        amountMinorUnits: 11500000,
      ),
    ],
    totalMinorUnits: 11500000,
    channelLabel: 'Remita RRR',
    rrr: '2401-9982-1102',
    clearingReference: '2401-9982-1102',
  );

  static final OfficialReceipt departmentalDuesReceipt = OfficialReceipt(
    id: 'rec-01009',
    receiptNumber: 'REC-2026-01009',
    verificationCode: 'B2C3D4E5F6A1',
    issuedOn: DateTime(2026, 10, 15),
    session: session,
    studentName: student.name,
    matricNumber: student.matricNumber,
    faculty: student.faculty,
    department: student.department,
    level: student.level,
    lines: [
      OfficialReceiptLine(
        label: 'Departmental Dues (CSC)',
        session: session,
        amountMinorUnits: 1250000,
      ),
    ],
    totalMinorUnits: 1250000,
    channelLabel: 'Card',
    rrr: terms.bankBranchReference,
    clearingReference: 'TXN-2026-01009',
  );

  static final Map<String, OfficialReceipt> receipts = {
    gatewayReceipt.id: gatewayReceipt,
    tuitionInstalmentReceipt.id: tuitionInstalmentReceipt,
    departmentalDuesReceipt.id: departmentalDuesReceipt,
  };

  /// Public check register: code → the five facts the page may show.
  static final Map<String, ReceiptVerificationResult>
  receiptVerificationRegister = {
    normaliseReceiptVerificationCode(
      receiptVerificationCode,
    ): ReceiptVerificationResult(
      receiptNumber: gatewayReceipt.receiptNumber,
      amountMinorUnits: gatewayReceipt.totalMinorUnits,
      paidBy: student.name,
      paidFor: 'Tuition balance & faculty levy',
      paidOn: gatewayReceipt.issuedOn,
    ),
    normaliseReceiptVerificationCode(
      tuitionInstalmentReceipt.verificationCode,
    ): ReceiptVerificationResult(
      receiptNumber: tuitionInstalmentReceipt.receiptNumber,
      amountMinorUnits: tuitionInstalmentReceipt.totalMinorUnits,
      paidBy: student.name,
      paidFor: 'Tuition Instalment 1',
      paidOn: tuitionInstalmentReceipt.issuedOn,
    ),
  };

  /// Builds the card checkout session from the open [invoices] and the
  /// amount the university checkout already chose (charge included when
  /// [payableMinorUnits] is set; otherwise the full balances plus charge).
  static CardCheckoutSession cardSessionFor({
    required List<Invoice> invoices,
    required FeesStudent student,
    required String session,
    required PaymentTerms terms,
    int? amountMinorUnits,
    int? payableMinorUnits,
  }) {
    final charge = terms.gatewayChargeMinorUnits;
    final balance = invoices.fold<int>(
      0,
      (total, invoice) => total + invoice.balanceMinorUnits,
    );
    final againstInvoices = amountMinorUnits ?? balance;
    final total = payableMinorUnits ?? (againstInvoices + charge);

    // Spread a partial instalment across the open invoices in order so the
    // schedule still lists each bill; the last line absorbs the remainder.
    var remaining = againstInvoices;
    final lines = <FeeScheduleLine>[];
    for (var i = 0; i < invoices.length; i++) {
      final invoice = invoices[i];
      final share = i == invoices.length - 1
          ? remaining
          : remaining.clamp(0, invoice.balanceMinorUnits);
      if (share <= 0) continue;
      lines.add(
        FeeScheduleLine(label: invoice.shortLabel, amountMinorUnits: share),
      );
      remaining -= share;
    }
    lines.add(
      FeeScheduleLine(
        label: 'Gateway processing charge (statutory)',
        amountMinorUnits: charge,
        isCharge: true,
      ),
    );

    return CardCheckoutSession(
      student: student,
      session: session,
      lines: lines,
      totalMinorUnits: total,
      transactionReference: pendingTransactionReference,
      invoiceIds: invoices.map((invoice) => invoice.id).toList(growable: false),
    );
  }

  /// Looks up a gateway return by its reference, or `null`.
  static GatewayReturn? gatewayReturn(String reference) =>
      gatewayReturns[reference.trim()];

  /// Looks up an official receipt by payment / receipt id, or `null`.
  static OfficialReceipt? receipt(String id) => receipts[id.trim()];

  /// Resolves a verification code to the five public facts, or `null`.
  static ReceiptVerificationResult? verifyReceipt(String code) =>
      receiptVerificationRegister[normaliseReceiptVerificationCode(code)];

  /// Mock hand-off: a pending return confirmed by the gateway becomes the
  /// succeeded fixture. Anything else is left alone.
  static GatewayReturn confirmReturn(GatewayReturn current) {
    if (current.reference != pendingTransactionReference) return current;
    return succeededReturn;
  }
}
