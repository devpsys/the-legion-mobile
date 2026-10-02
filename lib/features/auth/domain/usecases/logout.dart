import '../repositories/auth_repository.dart';

/// Clears the persisted session.
class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.logout();
}
