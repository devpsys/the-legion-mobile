import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../core/network/auth_token_provider.dart';
import '../../../core/router/auth_guard.dart';
import '../../../core/storage/key_value_store.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../data/datasources/local/auth_local_data_source.dart';
import '../data/datasources/remote/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login.dart';
import '../domain/usecases/logout.dart';
import '../domain/usecases/restore_session.dart';
import '../presentation/bloc/auth_cubit.dart';

/// Registers every dependency of the auth feature.
///
/// The `core` interfaces [AuthGuard] and [AuthTokenProvider] are bound to the
/// feature's own implementations here, which keeps `core` free of feature
/// imports while still allowing the router and the HTTP layer to be generic.
void registerAuthModule(GetIt sl) {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<Dio>()),
    )
    // Registered by concrete type so one instance can be exposed through both
    // `AuthLocalDataSource` and the `core` port `AuthTokenProvider`.
    ..registerLazySingleton<AuthLocalDataSourceImpl>(
      () => AuthLocalDataSourceImpl(
        secureStorage: sl<SecureStorageService>(),
        cache: sl<KeyValueStore>(),
      ),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => sl<AuthLocalDataSourceImpl>(),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: sl<AuthRemoteDataSource>(),
        local: sl<AuthLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<RestoreSessionUseCase>(
      () => RestoreSessionUseCase(sl<AuthRepository>()),
    )
    // Singleton: the router and every auth page observe the same session.
    ..registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        login: sl<LoginUseCase>(),
        logout: sl<LogoutUseCase>(),
        restoreSession: sl<RestoreSessionUseCase>(),
      ),
    )
    // Ports declared in `core`, implemented by this feature.
    ..registerLazySingleton<AuthGuard>(() => sl<AuthCubit>())
    ..registerLazySingleton<AuthTokenProvider>(
      () => sl<AuthLocalDataSourceImpl>(),
    );
}
