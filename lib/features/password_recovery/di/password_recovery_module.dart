import 'package:get_it/get_it.dart';

import '../presentation/bloc/password_recovery_cubit.dart';

/// Registers the account-recovery flow.
///
/// Registered as a factory: each entry into the flow builds a fresh cubit, so
/// a previous attempt's identifier, code and counters never leak into the next
/// one. The router provides it once for the whole flow via a `ShellRoute`.
void registerPasswordRecoveryModule(GetIt sl) {
  sl.registerFactory<PasswordRecoveryCubit>(PasswordRecoveryCubit.new);
}
