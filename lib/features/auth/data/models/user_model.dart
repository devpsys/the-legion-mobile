import '../../../../core/extensions/string_extensions.dart';
import '../../domain/entities/user.dart';

/// Wire model for [User].
///
/// Owns the JSON contract of the API. Keeping the mapping here means the
/// domain entity stays clean and the presentation layer never sees a
/// `UserModel`.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    super.avatarUrl,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _asString(json['id']),
      email: _asString(json['email']),
      displayName: _asString(
        json['displayName'] ?? json['name'],
        fallback: _asString(json['email']),
      ),
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: _asDate(json['createdAt']),
    );
  }

  /// Rebuilds a model from a domain entity, e.g. for optimistic caching.
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      avatarUrl: user.avatarUrl,
      createdAt: user.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  static String _asString(Object? value, {String fallback = ''}) {
    return value is String && value.isNotBlank ? value : fallback;
  }

  static DateTime? _asDate(Object? value) {
    if (value is String) return DateTime.tryParse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }
}
