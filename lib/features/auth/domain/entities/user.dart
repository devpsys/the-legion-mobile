import 'package:equatable/equatable.dart';

/// A user of the application.
///
/// Pure domain object: no JSON, no framework types.
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.createdAt,
  });

  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final DateTime? createdAt;

  /// Initials used by the avatar widget when no image is available.
  String get initials {
    final words = displayName
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return _firstLetterOf(email);
    if (words.length == 1) {
      final word = words.first;
      return word.substring(0, word.length > 2 ? 2 : word.length).toUpperCase();
    }
    return '${_firstLetterOf(words.first)}${_firstLetterOf(words.last)}';
  }

  static String _firstLetterOf(String value) =>
      value.isEmpty ? '' : value[0].toUpperCase();

  @override
  List<Object?> get props => [id, email, displayName, avatarUrl, createdAt];
}
