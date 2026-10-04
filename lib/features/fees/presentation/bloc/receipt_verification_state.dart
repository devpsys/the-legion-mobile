import 'package:equatable/equatable.dart';

import '../models/fees_models.dart';

/// Where the public receipt check stands.
enum ReceiptVerificationStatus {
  /// Nothing checked yet, or the code changed since the last answer.
  idle,

  /// Asking the register.
  checking,

  /// The code names a genuine receipt; [ReceiptVerificationState.result] is set.
  verified,

  /// The code matches nothing on the ledger.
  notFound,
}

/// State of the public receipt verification screen.
class ReceiptVerificationState extends Equatable {
  const ReceiptVerificationState({
    this.status = ReceiptVerificationStatus.idle,
    this.code = '',
    this.result,
  });

  final ReceiptVerificationStatus status;

  final String code;

  /// Set only while [status] is [ReceiptVerificationStatus.verified].
  final ReceiptVerificationResult? result;

  bool get isCodeComplete => isCompleteReceiptVerificationCode(code);

  bool get canVerify =>
      isCodeComplete && status != ReceiptVerificationStatus.checking;

  ReceiptVerificationState copyWith({
    ReceiptVerificationStatus? status,
    String? code,
    ReceiptVerificationResult? result,
    bool clearResult = false,
  }) {
    return ReceiptVerificationState(
      status: status ?? this.status,
      code: code ?? this.code,
      result: clearResult ? null : (result ?? this.result),
    );
  }

  @override
  List<Object?> get props => [status, code, result];
}
