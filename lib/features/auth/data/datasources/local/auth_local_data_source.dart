import 'dart:convert';

import '../../../../../core/network/auth_token_provider.dart';
import '../../../../../core/storage/key_value_store.dart';
import '../../../../../core/storage/secure_storage_service.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';

/// Local source for the persisted session.
///
/// Also acts as the session store for the networking layer
/// ([AuthTokenProvider]), because whoever persists the tokens owns them.
abstract interface class AuthLocalDataSource implements AuthTokenProvider {
  Future<UserModel?> readCachedUser();

  Future<void> cacheUser(UserModel user);

  Future<AuthTokensModel?> readTokens();

  Future<void> saveTokens(AuthTokensModel tokens);

  /// Removes tokens and cached profile in one call.
  Future<void> clear();
}

/// Hive + secure storage backed implementation.
///
/// Credentials go to [SecureStorageService] (never plain Hive); the cached
/// profile is non-sensitive and lives in the Hive backed
/// [KeyValueStore].
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required SecureStorageService secureStorage,
    required KeyValueStore cache,
  }) : _secureStorage = secureStorage,
       _cache = cache;

  static const String _accessTokenKey = 'auth.access_token';
  static const String _refreshTokenKey = 'auth.refresh_token';
  static const String _tokenExpiryKey = 'auth.token_expires_at';
  static const String _cachedUserKey = 'auth.cached_user';

  final SecureStorageService _secureStorage;
  final KeyValueStore _cache;

  // --- AuthLocalDataSource -------------------------------------------------

  @override
  Future<UserModel?> readCachedUser() async {
    final raw = _cache.read<String>(_cachedUserKey);
    if (raw == null) return null;

    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      // A corrupted cache entry must never block the app; drop it instead.
      await _cache.delete(_cachedUserKey);
      return null;
    } on TypeError {
      await _cache.delete(_cachedUserKey);
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) =>
      _cache.write(_cachedUserKey, jsonEncode(user.toJson()));

  @override
  Future<AuthTokensModel?> readTokens() async {
    final accessToken = await _secureStorage.read(_accessTokenKey);
    final refreshToken = await _secureStorage.read(_refreshTokenKey);
    final expiry = await _secureStorage.read(_tokenExpiryKey);
    if (accessToken == null || accessToken.isEmpty) return null;

    return AuthTokensModel.fromStoredJson(<String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken ?? '',
      'expiresAt': expiry,
    });
  }

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    await _secureStorage.write(_accessTokenKey, tokens.accessToken);
    await _secureStorage.write(_refreshTokenKey, tokens.refreshToken);
    await _secureStorage.write(
      _tokenExpiryKey,
      tokens.expiresAt.toIso8601String(),
    );
  }

  @override
  Future<void> clear() async {
    await _secureStorage.delete(_accessTokenKey);
    await _secureStorage.delete(_refreshTokenKey);
    await _secureStorage.delete(_tokenExpiryKey);
    await _cache.delete(_cachedUserKey);
  }

  // --- AuthTokenProvider (core/network) ----------------------------------

  @override
  Future<String?> accessToken() async {
    final tokens = await readTokens();
    if (tokens == null || tokens.isExpired) return null;
    return tokens.accessToken;
  }

  @override
  Future<void> onUnauthorized() => clear();
}
