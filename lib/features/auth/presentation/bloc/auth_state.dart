import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';

/// Lifecycle of the authentication session.
enum AuthStatus {
  /// Cold start, the persisted session has not been inspected yet.
  unknown,

  /// The persisted session is being restored.
  restoringSession,

  /// A sign-in request is in flight.
  authenticating,

  /// A sign-out request is in flight.
  signingOut,

  authenticated,

  unauthenticated,
}

/// Single immutable state of the auth feature.
///
/// A status enum is used instead of `isLoading` / `hasError` / `isSuccess`
/// flag combinations, which cannot describe illegal states such as
/// "loading and failed".
class AuthState extends Equatable {
  const AuthState({required this.status, this.user, this.failure});

  const AuthState.initial() : this(status: AuthStatus.unknown);

  const AuthState.authenticated(User user)
    : this(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated({Failure? failure})
    : this(status: AuthStatus.unauthenticated, failure: failure);

  final AuthStatus status;
  final User? user;
  final Failure? failure;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  /// `true` while a request that blocks interaction is running.
  bool get isBusy =>
      status == AuthStatus.restoringSession ||
      status == AuthStatus.authenticating ||
      status == AuthStatus.signingOut;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    Failure? failure,
    bool clearUser = false,
    bool clearFailure = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, user, failure];
}
