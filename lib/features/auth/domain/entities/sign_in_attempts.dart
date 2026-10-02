import 'dart:math' as math;

import 'package:equatable/equatable.dart';

/// Consecutive failed sign-in attempts and the lockout that follows.
///
/// A business rule, so it lives in the domain layer: five rejected
/// credentials lock sign-in for [cooldown], after which the user gets a fresh
/// allowance.
///
/// Client-side only for now — once the API reports throttling, [maxAttempts]
/// and [cooldown] move behind [AuthRepository] and this becomes a projection
/// of the server's answer.
class SignInAttempts extends Equatable {
  const SignInAttempts({this.failedAttempts = 0, this.lockedUntil});

  /// Attempts allowed before sign-in is locked.
  static const int maxAttempts = 5;

  /// How long sign-in stays locked once [maxAttempts] is reached.
  static const Duration cooldown = Duration(minutes: 5);

  /// Rejected credentials so far in the current streak.
  final int failedAttempts;

  /// Instant at which the lockout expires; `null` while not locked.
  final DateTime? lockedUntil;

  /// Attempts left before the lockout kicks in.
  int get remainingAttempts => math.max(0, maxAttempts - failedAttempts);

  /// `true` while the lockout window has not elapsed.
  bool isLockedAt(DateTime now) =>
      lockedUntil != null && now.isBefore(lockedUntil!);

  /// Time left before sign-in unlocks.
  Duration remainingCooldownAt(DateTime now) {
    final until = lockedUntil;
    if (until == null) return Duration.zero;
    final remaining = until.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Records a rejected credential; locks once the allowance is exhausted.
  ///
  /// An active lockout is never extended by further failures — the window
  /// starts once, at the moment the limit was reached. Pass [cooldown] to
  /// override the window; it defaults to [SignInAttempts.cooldown].
  SignInAttempts registerFailure(DateTime now, {Duration? cooldown}) {
    if (isLockedAt(now)) return this;

    final attempts = failedAttempts + 1;
    if (attempts < maxAttempts) {
      return SignInAttempts(failedAttempts: attempts);
    }
    return SignInAttempts(
      failedAttempts: attempts,
      lockedUntil: now.add(cooldown ?? SignInAttempts.cooldown),
    );
  }

  /// Clears the streak — used on a successful sign-in and after a lockout.
  SignInAttempts get cleared => const SignInAttempts();

  @override
  List<Object?> get props => [failedAttempts, lockedUntil];
}
