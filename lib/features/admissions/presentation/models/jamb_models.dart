/// View models of the JAMB claim screen.
///
/// Presentation only, like the rest of the admissions feature: the CAPS record
/// is drawn from `presentation/mock/` until the import endpoint exists. When
/// it lands, replace these with domain entities and delete the mock file.
library;

import 'package:equatable/equatable.dart';

/// How many digits open a JAMB registration number, as printed on the slip:
/// twelve, then two letters, e.g. `202630112233AB`.
const int jambRegistrationDigits = 12;
const int jambRegistrationLetters = 2;

final RegExp _registrationShape = RegExp(
  '^[0-9]{$jambRegistrationDigits}[A-Z]{$jambRegistrationLetters}\$',
);

/// A registration number as CAPS keys it: upper case, with the spaces and
/// hyphens somebody copying from a slip tends to add taken out.
String normaliseJambRegistrationNumber(String raw) =>
    raw.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();

/// `true` when [raw] has the shape of a number CAPS could answer.
bool isCompleteJambRegistrationNumber(String raw) =>
    _registrationShape.hasMatch(normaliseJambRegistrationNumber(raw));

/// What the candidate types to be matched against the CAPS import.
///
/// Three facts, because a registration number alone is on every slip a
/// candidate has ever shown anyone: the surname and the date of birth are
/// what make the match the candidate's own.
class JambClaimRequest extends Equatable {
  const JambClaimRequest({
    required this.registrationNumber,
    required this.surname,
    required this.dateOfBirth,
  });

  /// As typed; normalised with [normaliseJambRegistrationNumber] when matched.
  final String registrationNumber;

  /// As typed; matched without regard to case or surrounding space.
  final String surname;

  final DateTime dateOfBirth;

  @override
  List<Object?> get props => [registrationNumber, surname, dateOfBirth];
}

/// One subject on a UTME result.
class JambSubjectScore extends Equatable {
  const JambSubjectScore({required this.subject, required this.score});

  /// The subject as CAPS names it, e.g. `Mathematics`.
  final String subject;

  /// Out of 100.
  final int score;

  @override
  List<Object?> get props => [subject, score];
}

/// A UTME result as the university received it from CAPS.
///
/// Carries the candidate's surname and date of birth so the match can be made
/// against them; neither is drawn on screen, where the record shows only the
/// name, the examination and the scores.
class JambResult extends Equatable {
  const JambResult({
    required this.registrationNumber,
    required this.candidateName,
    required this.surname,
    required this.dateOfBirth,
    required this.examinationYear,
    required this.aggregateScore,
    required this.subjects,
  });

  /// As CAPS keys it, e.g. `202630112233AB`.
  final String registrationNumber;

  /// The full name on the record, e.g. `Musa Ibrahim`.
  final String candidateName;

  /// The surname as registered, for the match.
  final String surname;

  final DateTime dateOfBirth;

  /// The year of the UTME sitting, e.g. `2026`.
  final int examinationYear;

  /// The aggregate, out of 400.
  final int aggregateScore;

  /// The four subjects, in the order CAPS lists them.
  final List<JambSubjectScore> subjects;

  /// `true` when [request] names this record: same number, same surname
  /// (case and space aside), same day of birth.
  bool matches(JambClaimRequest request) {
    if (normaliseJambRegistrationNumber(request.registrationNumber) !=
        registrationNumber) {
      return false;
    }
    if (request.surname.trim().toLowerCase() != surname.toLowerCase()) {
      return false;
    }
    final born = request.dateOfBirth;
    return born.year == dateOfBirth.year &&
        born.month == dateOfBirth.month &&
        born.day == dateOfBirth.day;
  }

  @override
  List<Object?> get props => [
    registrationNumber,
    candidateName,
    surname,
    dateOfBirth,
    examinationYear,
    aggregateScore,
    subjects,
  ];
}

/// Resolves a claim to the CAPS record it names, or `null`.
typedef JambResultLookup = JambResult? Function(JambClaimRequest request);
