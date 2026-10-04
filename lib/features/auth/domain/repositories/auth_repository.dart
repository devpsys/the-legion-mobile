import '../entities/registration.dart';
import '../entities/user.dart';

/// Contract implemented by `data/repositories/auth_repository_impl.dart`.
///
/// Use cases depend on this interface, which keeps the domain layer free of
/// Dio, Hive and every other infrastructure concern.
abstract interface class AuthRepository {
  /// Authenticates with email and password and persists the resulting session.
  ///
  /// Throws a `Failure` (validation, auth, network or server).
  Future<User> login({required String email, required String password});

  /// Opens an applicant account and persists the session it starts with —
  /// a new applicant is signed in, not sent back to the door.
  ///
  /// Throws a `Failure`; an address already on the register arrives as a
  /// `ValidationFailure` on the email field.
  Future<User> register(Registration registration);

  /// Returns the user of the persisted session, or `null` when there is no
  /// usable session (not signed in, expired token, missing cache).
  Future<User?> restoreSession();

  /// Clears the persisted session. Must be safe to call when signed out.
  Future<void> logout();
}
