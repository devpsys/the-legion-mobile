import '../../../../core/error/failure_translator.dart';
import '../../domain/entities/registration.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_data_source.dart';
import '../datasources/remote/auth_remote_data_source.dart';

/// Coordinates the remote and local auth sources and converts their
/// exceptions into domain level [Failure]s.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<User> login({required String email, required String password}) {
    return translateToFailure(() async {
      final response = await _remote.login(email: email, password: password);
      await _local.saveTokens(response.tokens);
      await _local.cacheUser(response.user);
      return response.user;
    });
  }

  @override
  Future<User> register(Registration registration) {
    return translateToFailure(() async {
      final response = await _remote.register(registration);
      await _local.saveTokens(response.tokens);
      await _local.cacheUser(response.user);
      return response.user;
    });
  }

  @override
  Future<User?> restoreSession() {
    return translateToFailure(() async {
      final tokens = await _local.readTokens();
      if (tokens == null || tokens.isExpired) {
        // Expired or missing tokens: clear the stale session quietly.
        await _local.clear();
        return null;
      }
      return _local.readCachedUser();
    });
  }

  @override
  Future<void> logout() => translateToFailure(() => _local.clear());
}
