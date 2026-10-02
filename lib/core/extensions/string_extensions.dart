/// Small string helpers shared by validation logic and widget code.
extension StringX on String {
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;

  /// Pragmatic email shape check; the API remains the source of truth.
  bool get isValidEmail =>
      RegExp(r'^[\w.!#$%&*+/=?^`{|}~-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$')
          .hasMatch(trim());

  String get trimmed => trim();
}
