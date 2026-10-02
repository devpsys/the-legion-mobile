import '../../../../../core/network/auth_token_provider.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';
import '../local/auth_local_data_source.dart';

/// In-memory stand-in for the auth session on disk.
///
/// Keeps the fake [AuthLocalDataSource] to a couple of fields — no Hive, no
/// secure storage, no JSON round-trip — so the fake path behaves like the real
/// one from the repository's point of view without duplicating serialization
/// logic. The session disappears when the process does, which is the point.
///
/// Also implements [AuthTokenProvider] so the Dio interceptor keeps working
/// unchanged if the real datasource is swapped back in.
class InMemoryAuthLocalDataSource implements AuthLocalDataSource {
  InMemoryAuthLocalDataSource({this.sessionLifetime = defaultSessionLifetime});

  /// Tokens issued by the fake remote datasource expire after this long.
  static const Duration defaultSessionLifetime = Duration(hours: 8);

  final Duration sessionLifetime;

  UserModel? _cachedUser;
  AuthTokensModel? _tokens;

  /// Exposed for assertions in tests; not part of [AuthLocalDataSource].
  UserModel? get cachedUser => _cachedUser;

  @override
  Future<UserModel?> readCachedUser() async => _cachedUser;

  @override
  Future<void> cacheUser(UserModel user) async => _cachedUser = user;

  @override
  Future<AuthTokensModel?> readTokens() async => _tokens;

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async => _tokens = tokens;

  @override
  Future<void> clear() async {
    _cachedUser = null;
    _tokens = null;
  }

  // --- AuthTokenProvider (core/network) ----------------------------------

  @override
  Future<String?> accessToken() async {
    final tokens = _tokens;
    if (tokens == null || tokens.isExpired) return null;
    return tokens.accessToken;
  }

  @override
  Future<void> onUnauthorized() => clear();
}
