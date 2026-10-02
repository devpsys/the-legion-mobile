import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/router/auth_guard.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/restore_session.dart';
import 'auth_state.dart';

/// Owns the session for the whole application.
///
/// Registered as a singleton because both the router (`AuthGuard`) and every
/// auth page observe it. It only talks to use cases — never to a repository or
/// a datasource directly.
class AuthCubit extends Cubit<AuthState> implements AuthGuard {
  AuthCubit({
    required LoginUseCase login,
    required LogoutUseCase logout,
    required RestoreSessionUseCase restoreSession,
  }) : _login = login,
       _logout = logout,
       _restoreSession = restoreSession,
       super(const AuthState.initial());

  final LoginUseCase _login;
  final LogoutUseCase _logout;
  final RestoreSessionUseCase _restoreSession;

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
  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.authenticating, clearFailure: true));
    try {
      final user = await _login(email: email, password: password);
      emit(AuthState.authenticated(user));
    } on Failure catch (failure) {
      emit(AuthState.unauthenticated(failure: failure));
    } catch (error, stackTrace) {
      AppLogger.instance.e('Sign in crashed', error, stackTrace);
      emit(
        AuthState.unauthenticated(
          failure: UnexpectedFailure(message: '$error'),
        ),
      );
    }
  }

  /// Clears the session and returns to the login screen.
  Future<void> signOut() async {
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

  // --- AuthGuard (core/router) -------------------------------------------

  @override
  bool get isSessionResolved => state.status != AuthStatus.unknown;

  @override
  bool get isAuthenticated => state.isAuthenticated;
}
