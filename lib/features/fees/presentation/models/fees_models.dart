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
