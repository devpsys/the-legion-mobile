import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/router/auth_guard.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/sign_in_attempts.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/restore_session.dart';
import 'auth_state.dart';

/// Owns the session for the whole application.
///
/// Registered as a singleton because both the router ([AuthGuard]) and every
/// auth page observe it. It only talks to use cases — never to a repository or
/// a datasource directly.
class AuthCubit extends Cubit<AuthState> implements AuthGuard {
  AuthCubit({
    required LoginUseCase login,
    required LogoutUseCase logout,
    required RegisterUseCase register,
    required RestoreSessionUseCase restoreSession,
    DateTime Function()? now,
    Duration cooldown = SignInAttempts.cooldown,
  }) : _login = login,
       _logout = logout,
       _register = register,
       _restoreSession = restoreSession,
       _now = now ?? DateTime.now,
       _cooldown = cooldown,
       super(const AuthState.initial());

  final LoginUseCase _login;
  final LogoutUseCase _logout;
  final RegisterUseCase _register;
  final RestoreSessionUseCase _restoreSession;

  /// Injectable clock and cooldown keep the lockout rule testable.
  final DateTime Function() _now;
  final Duration _cooldown;

  Timer? _cooldownTimer;

  /// Restores a persisted session. Safe to call more than once.
  Future<void> bootstrap() async {
    if (state.status != AuthStatus.unknown) return;

    emit(
      state.copyWith(status: AuthStatus.restoringSession, clearFailure: true),
    );
    try {
      final user = await _restoreSession();
      emit(
        user == null
            ? const AuthState.unauthenticated()
            : AuthState.authenticated(user),
      );
    } on Failure catch (failure) {
      emit(AuthState.unauthenticated(failure: failure));
    } catch (error, stackTrace) {
      AppLogger.instance.e('Session restore crashed', error, stackTrace);
      emit(
        AuthState.unauthenticated(
          failure: UnexpectedFailure(message: '$error'),
        ),
      );
    }
  }

  /// Signs in. On success the router redirects to the protected area.
  ///
  /// Rejected credentials are counted by [SignInAttempts]; the fifth locks
  /// sign-in until the cooldown elapses. Input the API never saw — validation
  /// failures — does not count towards the limit.
  Future<void> signIn({required String email, required String password}) async {
    if (state.isRateLimited) return;

    emit(state.copyWith(status: AuthStatus.authenticating, clearFailure: true));
    try {
      final user = await _login(email: email, password: password);
      _cancelCooldown();
      emit(AuthState.authenticated(user));
    } on AuthFailure catch (failure) {
      _registerFailure(failure);
    } on Failure catch (failure) {
      emit(
        AuthState.unauthenticated(failure: failure, attempts: state.attempts),
      );
    } catch (error, stackTrace) {
      AppLogger.instance.e('Sign in crashed', error, stackTrace);
      emit(
        AuthState.unauthenticated(
          failure: UnexpectedFailure(message: '$error'),
          attempts: state.attempts,
        ),
      );
    }
  }

  /// Opens an applicant account and signs the applicant in. On success the
  /// router redirects to the protected area, as after [signIn].
  ///
  /// Nothing here counts towards the sign-in limit: a rejected registration
  /// is a form problem, not a guessed password. The streak already on the
  /// state is carried through untouched.
  Future<void> register({
    required String firstName,
    required String surname,
    required String email,
    required String password,
    required String confirmPassword,
    String otherNames = '',
    String phone = '',
  }) async {
    if (state.isBusy || state.isRateLimited) return;

    emit(state.copyWith(status: AuthStatus.registering, clearFailure: true));
    try {
      final user = await _register(
        firstName: firstName,
        surname: surname,
        otherNames: otherNames,
        email: email,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
      );
      _cancelCooldown();
      emit(AuthState.authenticated(user));
    } on Failure catch (failure) {
      emit(
        AuthState.unauthenticated(failure: failure, attempts: state.attempts),
      );
    } catch (error, stackTrace) {
      AppLogger.instance.e('Registration crashed', error, stackTrace);
      emit(
        AuthState.unauthenticated(
          failure: UnexpectedFailure(message: '$error'),
          attempts: state.attempts,
        ),
      );
    }
  }

  /// Drops the last failure without touching anything else.
  ///
  /// Sign-in and registration share this state, so a screen that is entered
  /// with the other screen's failure still on it clears it first — a wrong
  /// password is not something to show under a blank registration form.
  void clearFailure() {
    if (state.failure == null) return;
    emit(state.copyWith(clearFailure: true));
  }

  /// Clears the session and returns to the login screen.
  Future<void> signOut() async {
    _cancelCooldown();
    emit(state.copyWith(status: AuthStatus.signingOut, clearFailure: true));
    try {
      await _logout();
      emit(const AuthState.unauthenticated());
    } on Failure catch (failure) {
      emit(AuthState.unauthenticated(failure: failure));
    } catch (error, stackTrace) {
      AppLogger.instance.e('Sign out crashed', error, stackTrace);
      emit(
        AuthState.unauthenticated(
          failure: UnexpectedFailure(message: '$error'),
        ),
      );
    }
  }

  /// Records a rejected credential and starts the lockout when exhausted.
  void _registerFailure(AuthFailure failure) {
    final now = _now();
    final attempts = state.attempts.registerFailure(now, cooldown: _cooldown);

    if (attempts.lockedUntil != null) {
      emit(
        AuthState(
          status: AuthStatus.rateLimited,
          failure: failure,
          attempts: attempts,
          cooldownRemaining: _cooldown,
        ),
      );
      _startCooldownTicker();
      return;
    }

    emit(AuthState.unauthenticated(failure: failure, attempts: attempts));
  }

  void _startCooldownTicker() {
    _cancelCooldown();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = state.attempts.remainingCooldownAt(_now());
      if (remaining <= Duration.zero) {
        _cancelCooldown();
        // Cooldown elapsed: the user gets a fresh allowance.
        emit(const AuthState.unauthenticated());
        return;
      }
      emit(state.copyWith(cooldownRemaining: remaining));
    });
  }

  void _cancelCooldown() {
    _cooldownTimer?.cancel();
    _cooldownTimer = null;
  }

  @override
  Future<void> close() {
    _cancelCooldown();
    return super.close();
  }

  // --- AuthGuard (core/router) -------------------------------------------

  @override
  bool get isSessionResolved => state.status != AuthStatus.unknown;

  @override
  bool get isAuthenticated => state.isAuthenticated;
}
