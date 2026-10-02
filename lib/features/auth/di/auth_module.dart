import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/auth_token_provider.dart';
import '../../../../core/router/auth_guard.dart';
import '../../../../core/storage/key_value_store.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../data/datasources/fake/fake_auth_remote_data_source.dart';
import '../data/datasources/fake/in_memory_auth_local_data_source.dart';
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
///
/// While the backend is pending, `USE_FAKE_DATA_SOURCES` (default: on outside
/// production) swaps the remote and local datasources for their in-memory
/// fakes. The repository, use cases and cubit above them are unchanged, so the
/// presentation layer is already wired exactly as it will be in production.
void registerAuthModule(GetIt sl) {
  final useFakes = sl<AppConfig>().useFakeDataSources;

  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => useFakes
          ? FakeAuthRemoteDataSource()
          : AuthRemoteDataSourceImpl(sl<Dio>()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => useFakes
          ? InMemoryAuthLocalDataSource()
          : AuthLocalDataSourceImpl(
              secureStorage: sl<SecureStorageService>(),
              cache: sl<KeyValueStore>(),
            ),
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
    ..registerLazySingleton<AuthTokenProvider>(() => sl<AuthLocalDataSource>());
}
