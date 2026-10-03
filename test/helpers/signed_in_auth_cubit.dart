import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/in_memory_auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';

/// An [AuthCubit] over the in-memory fakes, already signed in as Ada.
///
/// For pages that read the session's user (the portal's avatar) without
/// exercising sign-in itself.
Future<AuthCubit> signedInAuthCubit() async {
  final repository = AuthRepositoryImpl(
    remote: FakeAuthRemoteDataSource(latency: Duration.zero),
    local: InMemoryAuthLocalDataSource(),
  );
  final cubit = AuthCubit(
    login: LoginUseCase(repository),
    logout: LogoutUseCase(repository),
    restoreSession: RestoreSessionUseCase(repository),
  );
  await cubit.signIn(
    email: 'ada@the-legion.dev',
    password: FakeAuthRemoteDataSource.defaultPassword,
  );
  return cubit;
}
