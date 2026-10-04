import 'package:equatable/equatable.dart';

import '../models/application_detail_models.dart';

/// Stage of one public letter check.
enum AdmissionVerificationStatus {
  /// Nothing has been looked up for the code as typed.
  idle,

  /// The register is being asked.
  checking,

  /// The code names a genuine admission; [AdmissionVerificationState.result]
  /// is what the letter prints.
  verified,

  /// The register has no admission under this code.
  notFound,
}

/// State of the public admission check.
class AdmissionVerificationState extends Equatable {
  const AdmissionVerificationState({
    this.status = AdmissionVerificationStatus.idle,
    this.code = '',
    this.result,
  });

  final AdmissionVerificationStatus status;

  /// The code as typed, spaces and all; normalised only when looked up.
  final String code;

  /// Set only while [status] is [AdmissionVerificationStatus.verified].
  final AdmissionVerificationResult? result;

  /// `true` once the code has the shape of one the register could answer.
  bool get isCodeComplete => isCompleteVerificationCode(code);

  /// `true` while a lookup can be started.
  bool get canVerify =>
      isCodeComplete && status != AdmissionVerificationStatus.checking;

  AdmissionVerificationState copyWith({
    AdmissionVerificationStatus? status,
    String? code,
    AdmissionVerificationResult? result,
    bool clearResult = false,
  }) {
    return AdmissionVerificationState(
      status: status ?? this.status,
      code: code ?? this.code,
      result: clearResult ? null : result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [status, code, result];
}
