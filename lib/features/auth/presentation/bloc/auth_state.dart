import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/sign_in_attempts.dart';
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

  /// Sign-in is locked after too many rejected credentials.
  rateLimited,

  authenticated,

  unauthenticated,
}

/// Single immutable state of the auth feature.
///
/// A status enum is used instead of `isLoading` / `hasError` / `isSuccess`
/// flag combinations, which cannot describe illegal states such as
/// "loading and failed".
class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.user,
    this.failure,
    this.attempts = const SignInAttempts(),
    this.cooldownRemaining = Duration.zero,
  });

  const AuthState.initial() : this(status: AuthStatus.unknown);

  const AuthState.authenticated(User user)
    : this(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated({
    Failure? failure,
    SignInAttempts attempts = const SignInAttempts(),
  }) : this(
         status: AuthStatus.unauthenticated,
         failure: failure,
         attempts: attempts,
       );

  final AuthStatus status;
  final User? user;
  final Failure? failure;

  /// Failed sign-in streak behind [AuthStatus.rateLimited].
  final SignInAttempts attempts;

  /// Countdown shown by the lockout UI; driven by the cubit's ticker.
  final Duration cooldownRemaining;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  /// `true` while sign-in is locked and the countdown has not elapsed.
  bool get isRateLimited => status == AuthStatus.rateLimited;

  /// `true` while a request that blocks interaction is running.
  bool get isBusy =>
      status == AuthStatus.restoringSession ||
      status == AuthStatus.authenticating ||
      status == AuthStatus.signingOut;

  /// Fraction of the cooldown still to elapse, for the progress meter.
  double get cooldownProgress {
    final total = SignInAttempts.cooldown.inMilliseconds;
    if (total == 0) return 0;
    final remaining = cooldownRemaining.inMilliseconds;
    return (remaining / total).clamp(0.0, 1.0);
  }

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    Failure? failure,
    SignInAttempts? attempts,
    Duration? cooldownRemaining,
    bool clearUser = false,
    bool clearFailure = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      failure: clearFailure ? null : (failure ?? this.failure),
      attempts: attempts ?? this.attempts,
      cooldownRemaining: cooldownRemaining ?? this.cooldownRemaining,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    failure,
    attempts,
    cooldownRemaining,
  ];
}
