import 'package:equatable/equatable.dart';

import '../models/fees_models.dart';

/// Stage of the fees screen.
enum FeesStatus {
  /// Nothing loaded yet.
  initial,

  /// The student's ledger is being read.
  loading,

  /// Ready to render.
  ready,

  /// The read failed.
  failure,
}

/// State of the student fees screen.
///
/// Presentation only — the bursary endpoints are pending, so the cubit reads
/// a fixture ledger and this state derives everything the screen shows from
/// it: the outstanding total is a sum over the open invoices, never a figure
/// of its own, so the hero and the cards cannot disagree.
class FeesState extends Equatable {
  const FeesState({
    this.status = FeesStatus.initial,
    this.student,
    this.session = '',
    this.invoices = const [],
    this.payments = const [],
    this.terms,
    this.failureMessage,
  });

  final FeesStatus status;

  /// `null` until loaded.
  final FeesStudent? student;

  /// The session the invoices are headed with.
  final String session;

  /// Newest first.
  final List<Invoice> invoices;

  /// Newest first.
  final List<PaymentRecord> payments;

  /// `null` until loaded.
  final PaymentTerms? terms;

  final String? failureMessage;

  /// The invoices money is still owed on, in ledger order.
  List<Invoice> get outstandingInvoices =>
      invoices.where((invoice) => invoice.isOutstanding).toList();

  /// Everything owed across the open invoices, in kobo.
  int get outstandingMinorUnits => outstandingInvoices.fold(
    0,
    (total, invoice) => total + invoice.balanceMinorUnits,
  );

  /// `true` while anything is owed.
  bool get hasOutstanding => outstandingMinorUnits > 0;

  /// The earliest deadline among the open invoices, or `null` when nothing
  /// is owed.
  DateTime? get nextDueOn {
    DateTime? earliest;
    for (final invoice in outstandingInvoices) {
      if (earliest == null || invoice.dueOn.isBefore(earliest)) {
        earliest = invoice.dueOn;
      }
    }
    return earliest;
  }

  /// The open invoices a checkout is for.
  ///
  /// An empty [ids] means all of them — the hero's "pay outstanding balance"
  /// — and an id that is not an open invoice is dropped rather than paid:
  /// a stale link must not put a settled bill back on the till.
  List<Invoice> outstandingInvoicesFor(List<String> ids) {
    final outstanding = outstandingInvoices;
    if (ids.isEmpty) return outstanding;
    return outstanding.where((invoice) => ids.contains(invoice.id)).toList();
  }

  FeesState copyWith({
    FeesStatus? status,
    FeesStudent? student,
    String? session,
    List<Invoice>? invoices,
    List<PaymentRecord>? payments,
    PaymentTerms? terms,
    String? failureMessage,
    bool clearFailure = false,
  }) {
    return FeesState(
      status: status ?? this.status,
      student: student ?? this.student,
      session: session ?? this.session,
      invoices: invoices ?? this.invoices,
      payments: payments ?? this.payments,
      terms: terms ?? this.terms,
      failureMessage: clearFailure
          ? null
          : (failureMessage ?? this.failureMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    student,
    session,
    invoices,
    payments,
    terms,
    failureMessage,
  ];
}
