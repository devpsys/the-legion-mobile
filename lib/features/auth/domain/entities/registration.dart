import 'package:equatable/equatable.dart';

/// What an applicant hands the university to open an account.
///
/// Pure domain object, already validated and trimmed by the time it exists:
/// the use case builds one only after every rule has passed, so a repository
/// never has to re-check it. Optional parts are `null`, not empty strings.
class Registration extends Equatable {
  const Registration({
    required this.firstName,
    required this.surname,
    required this.email,
    required this.password,
    this.otherNames,
    this.phone,
  });

  final String firstName;
  final String surname;
  final String? otherNames;
  final String email;
  final String? phone;
  final String password;

  /// The name the account is opened under, as it will greet the applicant.
  String get displayName => '$firstName $surname';

  @override
  List<Object?> get props => [
    firstName,
    surname,
    otherNames,
    email,
    phone,
    password,
  ];
}
