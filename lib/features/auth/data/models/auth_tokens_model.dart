import 'package:equatable/equatable.dart';

/// Credentials returned by the API after a successful sign-in.
class AuthTokensModel extends Equatable {
  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    final expiresInSeconds = json['expiresIn'] is num
        ? (json['expiresIn'] as num).toInt()
        : const Duration(hours: 1).inSeconds;
    return AuthTokensModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresAt: DateTime.now().add(Duration(seconds: expiresInSeconds)),
    );
  }

  final String accessToken;
  final String refreshToken;

  /// Absolute expiry used to decide whether the cached session is still valid.
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'expiresAt': expiresAt.toIso8601String(),
  };

  /// Restores tokens previously written with [toJson].
  factory AuthTokensModel.fromStoredJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresAt:
          DateTime.tryParse(json['expiresAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];
}
