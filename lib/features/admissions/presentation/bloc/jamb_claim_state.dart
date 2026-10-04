import 'package:equatable/equatable.dart';

import '../models/jamb_models.dart';

/// Stage of one attempt to claim a JAMB result.
enum JambClaimStatus {
  /// Nothing has been matched for the facts as typed.
  idle,

  /// The import is being asked.
  matching,

  /// The facts name a record; [JambClaimState.result] is what CAPS holds.
  matched,

  /// The import has no record under these facts.
  notFound,
}

/// State of the JAMB claim form.
class JambClaimState extends Equatable {
  const JambClaimState({
    this.status = JambClaimStatus.idle,
    this.registrationNumber = '',
    this.surname = '',
    this.dateOfBirth,
    this.result,
  });

  final JambClaimStatus status;

  /// As typed; normalised only when matched.
  final String registrationNumber;

  /// As typed.
  final String surname;

  /// `null` until the candidate picks one.
  final DateTime? dateOfBirth;

  /// Set only while [status] is [JambClaimStatus.matched].
  final JambResult? result;

  /// `true` once the number has the shape of one CAPS could answer.
  bool get isRegistrationNumberComplete =>
      isCompleteJambRegistrationNumber(registrationNumber);

  /// `true` once every fact the match needs is in.
  bool get isComplete =>
      isRegistrationNumberComplete &&
      surname.trim().isNotEmpty &&
      dateOfBirth != null;

  /// `true` while a match can be attempted.
  bool get canMatch => isComplete && status != JambClaimStatus.matching;

  /// `true` while the matched record can be linked.
  bool get canConfirm => status == JambClaimStatus.matched && result != null;

  /// The facts as a request, or `null` while one is still missing.
  JambClaimRequest? get request => isComplete
      ? JambClaimRequest(
          registrationNumber: registrationNumber,
          surname: surname,
          dateOfBirth: dateOfBirth!,
        )
      : null;

  JambClaimState copyWith({
    JambClaimStatus? status,
    String? registrationNumber,
    String? surname,
    DateTime? dateOfBirth,
    JambResult? result,
    bool clearResult = false,
  }) {
    return JambClaimState(
      status: status ?? this.status,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      surname: surname ?? this.surname,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      result: clearResult ? null : result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [
    status,
    registrationNumber,
    surname,
    dateOfBirth,
    result,
  ];
}
