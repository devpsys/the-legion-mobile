import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Restores a previously persisted session on cold start.
///
/// Returns `null` when the user must sign in again; never throws for the
/// "no session" case, which is an expected outcome and not an error.
class RestoreSessionUseCase {
  const RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<User?> call() => _repository.restoreSession();
}
