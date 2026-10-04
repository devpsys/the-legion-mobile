import 'package:equatable/equatable.dart';

import '../models/fees_models.dart';

/// Why a typed instalment cannot be taken.
enum InstalmentProblem {
  /// Nothing typed, or not an amount.
  missing,

  /// Under the bursary's permitted minimum.
  belowMinimum,

  /// More than is owed; an overpayment is not what this screen is for.
  aboveBalance,
}

/// State of one visit to the checkout.
///
/// The invoices and the terms are copied in from the ledger when the visit
/// starts; everything else is the student's choice. The figures are derived,
/// never stored: the total payable is the chosen amount plus the gateway's
/// charge, so the radio label, the summary and the button cannot disagree.
class FeeCheckoutState extends Equatable {
  const FeeCheckoutState({
    this.invoices = const [],
    this.terms,
    this.amountMode = PaymentAmountMode.full,
    this.instalmentMinorUnits,
    this.method = PaymentMethod.gateway,
  });

  /// The open invoices being paid, in ledger order.
  final List<Invoice> invoices;

  /// `null` until the visit starts.
  final PaymentTerms? terms;

  final PaymentAmountMode amountMode;

  /// The instalment as typed and parsed; `null` while empty or not an amount.
  final int? instalmentMinorUnits;

  final PaymentMethod method;

  /// `true` once the visit has a ledger to work from.
  bool get isStarted => terms != null;

  /// Everything owed on [invoices], in kobo.
  int get balanceMinorUnits =>
      invoices.fold(0, (total, invoice) => total + invoice.balanceMinorUnits);

  /// What the gateway adds, in kobo.
  int get gatewayChargeMinorUnits => terms?.gatewayChargeMinorUnits ?? 0;

  /// The least a custom instalment may be, in kobo.
  int get minimumInstalmentMinorUnits =>
      terms?.minimumInstalmentMinorUnits ?? 0;

  /// What paying the whole balance costs, charge included.
  int get fullPayableMinorUnits => balanceMinorUnits + gatewayChargeMinorUnits;

  /// `true` when an instalment is worth offering: only while the balance is
  /// above the minimum, since otherwise the only permitted instalment is the
  /// whole balance.
  bool get allowsInstalment =>
      isStarted && balanceMinorUnits > minimumInstalmentMinorUnits;

  /// The amount going against the invoices, or `null` while the instalment
  /// is not yet an amount.
  int? get amountMinorUnits => switch (amountMode) {
    PaymentAmountMode.full => balanceMinorUnits,
    PaymentAmountMode.instalment => instalmentMinorUnits,
  };

  /// What the student will be charged: the amount plus the gateway's charge,
  /// or `null` while there is no amount.
  int? get payableMinorUnits {
    final amount = amountMinorUnits;
    return amount == null ? null : amount + gatewayChargeMinorUnits;
  }

  /// What is wrong with the typed instalment, or `null` when nothing is —
  /// including whenever the full balance is chosen instead.
  InstalmentProblem? get instalmentProblem {
    if (amountMode != PaymentAmountMode.instalment) return null;
    final instalment = instalmentMinorUnits;
    if (instalment == null || instalment <= 0) return InstalmentProblem.missing;
    if (instalment < minimumInstalmentMinorUnits) {
      return InstalmentProblem.belowMinimum;
    }
    if (instalment > balanceMinorUnits) return InstalmentProblem.aboveBalance;
    return null;
  }

  /// `true` while the gateway can be asked for the figure on the button.
  bool get canProceed =>
      isStarted &&
      balanceMinorUnits > 0 &&
      payableMinorUnits != null &&
      instalmentProblem == null;

  FeeCheckoutState copyWith({
    List<Invoice>? invoices,
    PaymentTerms? terms,
    PaymentAmountMode? amountMode,
    int? instalmentMinorUnits,
    bool clearInstalment = false,
    PaymentMethod? method,
  }) {
    return FeeCheckoutState(
      invoices: invoices ?? this.invoices,
      terms: terms ?? this.terms,
      amountMode: amountMode ?? this.amountMode,
      instalmentMinorUnits: clearInstalment
          ? null
          : (instalmentMinorUnits ?? this.instalmentMinorUnits),
      method: method ?? this.method,
    );
  }

  @override
  List<Object?> get props => [
    invoices,
    terms,
    amountMode,
    instalmentMinorUnits,
    method,
  ];
}
