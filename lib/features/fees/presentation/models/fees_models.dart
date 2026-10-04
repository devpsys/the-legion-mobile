/// View models of the student fees screens.
///
/// These shapes describe what the screens render, not what the bursary API
/// returns: the fees endpoints are pending and the feature is fed from
/// `presentation/mock/`. When the endpoints land, replace them with the
/// feature's domain entities and delete the mock file.
///
/// Every amount is an integer in minor units (kobo) and is rendered through
/// `formatNaira`; nothing here is ever a `double` of naira.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/theme/app_tone.dart';

/// Where an invoice stands with the bursary.
///
/// The labels are the bursary's vocabulary, never the enum's name: `open`
/// reads "Unpaid" and `partiallyPaid` reads "Part paid".
enum InvoiceStatus {
  /// Billed, nothing cleared against it yet.
  open,

  /// Some of it cleared; the balance is still owed.
  partiallyPaid,

  /// Cleared in full.
  paid,

  /// Withdrawn by the bursary; nothing is owed on it.
  cancelled,
}

/// Semantic tone of an invoice status, mirroring its urgency.
extension InvoiceStatusTone on InvoiceStatus {
  AppTone get tone => switch (this) {
    InvoiceStatus.open => AppTone.danger,
    InvoiceStatus.partiallyPaid => AppTone.warning,
    InvoiceStatus.paid => AppTone.success,
    InvoiceStatus.cancelled => AppTone.neutral,
  };

  /// `true` while money is still owed on the invoice.
  bool get isOutstanding =>
      this == InvoiceStatus.open || this == InvoiceStatus.partiallyPaid;
}

/// Where a payment stands with the gateway.
///
/// Nothing says the money moved until the gateway says so: a payment that is
/// [pending] reads "Awaiting confirmation", never "Paid".
enum PaymentStatus {
  /// Initiated; the gateway has not confirmed it.
  pending,

  /// Confirmed by the gateway and cleared by the bursary.
  succeeded,
}

/// Semantic tone of a payment status.
extension PaymentStatusTone on PaymentStatus {
  AppTone get tone => switch (this) {
    PaymentStatus.pending => AppTone.warning,
    PaymentStatus.succeeded => AppTone.success,
  };
}

/// How a recorded payment was made.
enum PaymentChannel {
  /// A debit card through the gateway.
  card,

  /// A Remita Retrieval Reference paid at a bank or online.
  remitaRrr,
}

/// The ways the checkout offers to pay.
enum PaymentMethod {
  /// Card or instant bank transfer through the gateway; clears in a minute.
  gateway,

  /// A Remita reference paid over the counter at a bank branch; clears in
  /// hours.
  bankBranch,

  /// A single-use NIP virtual account generated for the student.
  virtualAccount,
}

/// Whether the checkout pays everything owed or a chosen instalment.
enum PaymentAmountMode {
  /// The whole balance on the chosen invoices.
  full,

  /// An amount the student types, at or above the permitted minimum.
  instalment,
}

/// The student the bursary bills, as the bursary records them.
class FeesStudent extends Equatable {
  const FeesStudent({
    required this.name,
    required this.matricNumber,
    required this.level,
    required this.department,
    required this.faculty,
    required this.email,
  });

  final String name;

  /// e.g. `23/CSC/0412`.
  final String matricNumber;

  /// Level of study, e.g. `300`.
  final int level;

  final String department;
  final String faculty;

  /// Institutional email the receipts go to.
  final String email;

  @override
  List<Object?> get props => [
    name,
    matricNumber,
    level,
    department,
    faculty,
    email,
  ];
}

/// One bill raised against the student.
class Invoice extends Equatable {
  const Invoice({
    required this.id,
    required this.reference,
    required this.title,
    required this.subtitle,
    required this.shortLabel,
    required this.lineLabel,
    required this.session,
    required this.status,
    required this.totalMinorUnits,
    required this.paidMinorUnits,
    required this.dueOn,
  });

  /// Stable identifier used by routes and tests.
  final String id;

  /// The number the student quotes to the bursary, e.g. `INV-2026-08821`.
  final String reference;

  /// What the bill is for, e.g. `300 Level Composite Tuition`.
  final String title;

  /// Who raised it, e.g. `Faculty of Science · Computer Science`.
  final String subtitle;

  /// The bill's name where a line has no room, e.g. `Tuition balance` in the
  /// strip under the outstanding total.
  final String shortLabel;

  /// The bill's name on a checkout line, e.g. `Tuition balance (300 Level)`.
  final String lineLabel;

  /// Academic session billed, e.g. `2026/2027`.
  final String session;

  final InvoiceStatus status;

  /// Everything billed, in kobo.
  final int totalMinorUnits;

  /// Everything cleared against it so far, in kobo.
  final int paidMinorUnits;

  /// When the balance must be cleared by.
  final DateTime dueOn;

  /// What is still owed; never negative, since an overpayment goes to the
  /// wallet rather than against the bill.
  int get balanceMinorUnits {
    final balance = totalMinorUnits - paidMinorUnits;
    return balance < 0 ? 0 : balance;
  }

  /// Share of the bill cleared, clamped to `0..1`.
  double get paidFraction => totalMinorUnits <= 0
      ? 0
      : (paidMinorUnits / totalMinorUnits).clamp(0.0, 1.0);

  /// [paidFraction] as a whole percentage, for the label beside the bar.
  int get paidPercent => (paidFraction * 100).round();

  /// `true` while money is still owed on it.
  bool get isOutstanding => status.isOutstanding;

  @override
  List<Object?> get props => [
    id,
    reference,
    title,
    subtitle,
    shortLabel,
    lineLabel,
    session,
    status,
    totalMinorUnits,
    paidMinorUnits,
    dueOn,
  ];
}

/// One payment the bursary has on record, and the receipt it issued.
class PaymentRecord extends Equatable {
  const PaymentRecord({
    required this.id,
    required this.reference,
    required this.title,
    required this.amountMinorUnits,
    required this.paidOn,
    required this.channel,
    required this.status,
    this.channelReference,
    this.invoiceId,
  });

  final String id;

  /// The receipt number, e.g. `REC-2026-04412`.
  final String reference;

  /// What was paid for, e.g. `Tuition Instalment 1`.
  final String title;

  final int amountMinorUnits;

  final DateTime paidOn;

  final PaymentChannel channel;

  /// The channel's own reference, e.g. the Remita RRR; `null` where the
  /// channel issues none.
  final String? channelReference;

  final PaymentStatus status;

  /// The invoice it cleared against; `null` for dues billed outside one.
  final String? invoiceId;

  @override
  List<Object?> get props => [
    id,
    reference,
    title,
    amountMinorUnits,
    paidOn,
    channel,
    channelReference,
    status,
    invoiceId,
  ];
}

/// The bursary's terms for a payment: what the gateway adds, how small an
/// instalment may be, and the reference a bank branch needs.
class PaymentTerms extends Equatable {
  const PaymentTerms({
    required this.gatewayChargeMinorUnits,
    required this.minimumInstalmentMinorUnits,
    required this.bankBranchReference,
  });

  /// Statutory processing charge the gateway adds to every payment.
  final int gatewayChargeMinorUnits;

  /// The least a custom instalment may be.
  final int minimumInstalmentMinorUnits;

  /// The Remita Retrieval Reference quoted at a bank branch.
  final String bankBranchReference;

  @override
  List<Object?> get props => [
    gatewayChargeMinorUnits,
    minimumInstalmentMinorUnits,
    bankBranchReference,
  ];
}

/// Everything the bursary holds on one student: who they are, what they were
/// billed, what they paid, and on what terms they may pay the rest.
class FeesLedger extends Equatable {
  const FeesLedger({
    required this.student,
    required this.session,
    required this.invoices,
    required this.payments,
    required this.terms,
  });

  final FeesStudent student;

  /// The session the invoices section is headed with, e.g. `2026/2027`.
  final String session;

  /// Newest first.
  final List<Invoice> invoices;

  /// Newest first.
  final List<PaymentRecord> payments;

  final PaymentTerms terms;

  @override
  List<Object?> get props => [student, session, invoices, payments, terms];
}

/// Where the gateway-return screen stands after a Pay attempt.
///
/// Nothing says the money moved until the gateway confirms: [pending] is the
/// state Pay opens onto — amber, with a selectable reference — never a
/// success. The other three cover the rest of what the return screen may
/// show once the gateway answers.
enum GatewayReturnStatus {
  /// Submitted; confirmation has not arrived.
  pending,

  /// Confirmed and cleared.
  succeeded,

  /// Declined or rejected by the gateway.
  failed,

  /// Left unanswered past the gateway's window.
  expired,
}

/// Semantic tone of a gateway-return status.
extension GatewayReturnStatusTone on GatewayReturnStatus {
  AppTone get tone => switch (this) {
    GatewayReturnStatus.pending => AppTone.warning,
    GatewayReturnStatus.succeeded => AppTone.success,
    GatewayReturnStatus.failed => AppTone.danger,
    GatewayReturnStatus.expired => AppTone.neutral,
  };

  /// `true` once the bursary has a receipt for this payment.
  bool get hasReceipt => this == GatewayReturnStatus.succeeded;
}

/// One line on the card checkout's itemised schedule.
class FeeScheduleLine extends Equatable {
  const FeeScheduleLine({
    required this.label,
    required this.amountMinorUnits,
    this.isCharge = false,
  });

  final String label;

  final int amountMinorUnits;

  /// `true` for the statutory gateway charge, drawn apart from the bills.
  final bool isCharge;

  @override
  List<Object?> get props => [label, amountMinorUnits, isCharge];
}

/// What the card checkout is charging: the student, the schedule, and the
/// transaction reference the gateway will quote on return.
class CardCheckoutSession extends Equatable {
  const CardCheckoutSession({
    required this.student,
    required this.session,
    required this.lines,
    required this.totalMinorUnits,
    required this.transactionReference,
    required this.invoiceIds,
  });

  final FeesStudent student;

  /// Academic session on the schedule header.
  final String session;

  /// Invoice balances plus the gateway charge, in ledger order.
  final List<FeeScheduleLine> lines;

  /// Sum of [lines], in kobo — what the Pay button charges.
  final int totalMinorUnits;

  /// Reference handed to the gateway and shown on the return screen.
  final String transactionReference;

  /// The open invoices this charge is for.
  final List<String> invoiceIds;

  @override
  List<Object?> get props => [
    student,
    session,
    lines,
    totalMinorUnits,
    transactionReference,
    invoiceIds,
  ];
}

/// One visit to the gateway-return screen: status, amount, and the ledger
/// rows the designs print under the hero.
class GatewayReturn extends Equatable {
  const GatewayReturn({
    required this.reference,
    required this.status,
    required this.amountMinorUnits,
    required this.occurredOn,
    required this.studentName,
    required this.matricNumber,
    required this.channelLabel,
    this.rrr,
    this.gatewayReference,
    this.paidFor,
    this.receiptId,
    this.authCode,
  });

  /// Path / query key for this return, e.g. `TXN-2027-PENDING`.
  final String reference;

  final GatewayReturnStatus status;

  final int amountMinorUnits;

  /// When the attempt was made (or confirmed).
  final DateTime occurredOn;

  final String studentName;

  final String matricNumber;

  /// Human channel label, e.g. `Card (Mastercard)`.
  final String channelLabel;

  /// Remita RRR when the channel issued one.
  final String? rrr;

  /// The gateway's own transaction id.
  final String? gatewayReference;

  /// Short description of what was paid for.
  final String? paidFor;

  /// Official receipt id once [status] is [GatewayReturnStatus.succeeded].
  final String? receiptId;

  /// Authorisation code on a cleared card payment.
  final String? authCode;

  @override
  List<Object?> get props => [
    reference,
    status,
    amountMinorUnits,
    occurredOn,
    studentName,
    matricNumber,
    channelLabel,
    rrr,
    gatewayReference,
    paidFor,
    receiptId,
    authCode,
  ];
}

/// One line on the official e-receipt's fee table.
class OfficialReceiptLine extends Equatable {
  const OfficialReceiptLine({
    required this.label,
    required this.session,
    required this.amountMinorUnits,
  });

  final String label;

  /// Semester / session column, e.g. `2026/2027`.
  final String session;

  final int amountMinorUnits;

  @override
  List<Object?> get props => [label, session, amountMinorUnits];
}

/// The paper the bursary issues once a payment is cleared.
///
/// Drawn as a light document on a dark chrome. Overpayment, if any, is a
/// separate "To wallet" row — never netted into the outstanding balance.
class OfficialReceipt extends Equatable {
  const OfficialReceipt({
    required this.id,
    required this.receiptNumber,
    required this.verificationCode,
    required this.issuedOn,
    required this.session,
    required this.studentName,
    required this.matricNumber,
    required this.faculty,
    required this.department,
    required this.level,
    required this.lines,
    required this.totalMinorUnits,
    required this.channelLabel,
    required this.rrr,
    required this.clearingReference,
    this.authCode,
    this.toWalletMinorUnits,
  });

  /// Same id as the [PaymentRecord] it belongs to, so history can open it.
  final String id;

  /// Printed receipt number, e.g. `REC-2027-098812`.
  final String receiptNumber;

  /// Code at the foot / in the QR — what the public check accepts.
  final String verificationCode;

  final DateTime issuedOn;

  final String session;

  final String studentName;

  final String matricNumber;

  final String faculty;

  final String department;

  final int level;

  final List<OfficialReceiptLine> lines;

  final int totalMinorUnits;

  final String channelLabel;

  final String rrr;

  /// Clearing / central reference on the settlement block.
  final String clearingReference;

  final String? authCode;

  /// Surplus credited to the wallet; `null` when the payment did not
  /// overrun what the invoices could absorb.
  final int? toWalletMinorUnits;

  @override
  List<Object?> get props => [
    id,
    receiptNumber,
    verificationCode,
    issuedOn,
    session,
    studentName,
    matricNumber,
    faculty,
    department,
    level,
    lines,
    totalMinorUnits,
    channelLabel,
    rrr,
    clearingReference,
    authCode,
    toWalletMinorUnits,
  ];
}

/// How many characters a bursary receipt verification code has.
const int receiptVerificationCodeLength = 12;

/// A receipt verification code as the register keys it: upper case, with
/// spaces and hyphens stripped.
String normaliseReceiptVerificationCode(String raw) =>
    raw.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();

/// `true` when [raw] has the shape of a code the register could answer.
bool isCompleteReceiptVerificationCode(String raw) =>
    normaliseReceiptVerificationCode(raw).length ==
    receiptVerificationCodeLength;

/// Formats a normalised code as `XXXX-XXXX-XXXX` for the public field.
String formatReceiptVerificationCode(String raw) {
  final normalised = normaliseReceiptVerificationCode(raw);
  final buffer = StringBuffer();
  for (var i = 0; i < normalised.length; i++) {
    if (i > 0 && i % 4 == 0) buffer.write('-');
    buffer.write(normalised[i]);
  }
  return buffer.toString();
}

/// What a public receipt check may show: exactly five facts.
///
/// No matric, email, phone, bank account, teller or gateway reference — the
/// fees README treats any of those as a privacy leak, and the model has no
/// field for them so the screen cannot draw them.
class ReceiptVerificationResult extends Equatable {
  const ReceiptVerificationResult({
    required this.receiptNumber,
    required this.amountMinorUnits,
    required this.paidBy,
    required this.paidFor,
    required this.paidOn,
  });

  final String receiptNumber;

  final int amountMinorUnits;

  /// Payer's name only — never a matric or contact detail.
  final String paidBy;

  /// Short purpose, e.g. `Tuition balance & faculty levy`.
  final String paidFor;

  final DateTime paidOn;

  @override
  List<Object?> get props => [
    receiptNumber,
    amountMinorUnits,
    paidBy,
    paidFor,
    paidOn,
  ];
}
