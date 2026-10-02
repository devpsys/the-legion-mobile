import 'package:equatable/equatable.dart';

/// The institutional password policy (`POL-SEC-v4.2` in the designs).
///
/// A business rule, so it lives in the domain layer and is unit testable
/// without a widget. The presentation renders whatever this reports.
class PasswordPolicy extends Equatable {
  const PasswordPolicy({
    this.minLength = 8,
    this.requiresUppercase = true,
    this.requiresNumber = true,
    this.requiresSpecialCharacter = true,
  });

  final int minLength;
  final bool requiresUppercase;
  final bool requiresNumber;
  final bool requiresSpecialCharacter;

  static final RegExp _uppercase = RegExp('[A-Z]');
  static final RegExp _number = RegExp(r'[0-9]');
  static final RegExp _special = RegExp(r'[!@#$%^&*]');

  /// Evaluates [password] against every rule, in display order.
  List<PasswordRequirement> evaluate(String password) => [
    PasswordRequirement(
      id: PasswordRequirementId.length,
      isMet: password.length >= minLength,
    ),
    PasswordRequirement(
      id: PasswordRequirementId.uppercase,
      isMet: !requiresUppercase || _uppercase.hasMatch(password),
    ),
    PasswordRequirement(
      id: PasswordRequirementId.number,
      isMet: !requiresNumber || _number.hasMatch(password),
    ),
    PasswordRequirement(
      id: PasswordRequirementId.special,
      isMet: !requiresSpecialCharacter || _special.hasMatch(password),
    ),
  ];

  /// `true` only when every rule passes.
  bool isCompliant(String password) =>
      evaluate(password).every((requirement) => requirement.isMet);

  /// Fraction of satisfied rules, for the strength meter (0 → 1).
  double strengthOf(String password) {
    if (password.isEmpty) return 0;
    final requirements = evaluate(password);
    final met = requirements.where((requirement) => requirement.isMet).length;
    return met / requirements.length;
  }

  @override
  List<Object?> get props => [
    minLength,
    requiresUppercase,
    requiresNumber,
    requiresSpecialCharacter,
  ];
}

/// Identifies a single policy rule so the UI can localize it per id.
enum PasswordRequirementId { length, uppercase, number, special }

/// One rule and whether the candidate password satisfies it.
class PasswordRequirement extends Equatable {
  const PasswordRequirement({required this.id, required this.isMet});

  final PasswordRequirementId id;
  final bool isMet;

  @override
  List<Object?> get props => [id, isMet];
}
