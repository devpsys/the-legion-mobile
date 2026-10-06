import 'package:get_it/get_it.dart';

import '../presentation/bloc/registration_cubit.dart';
import '../presentation/bloc/staff/id_card_verification_cubit.dart';
import '../presentation/bloc/staff/registry_cubit.dart';
import '../presentation/bloc/staff/staff_approvals_cubit.dart';

/// Registers Registration & Records presentation dependencies.
///
/// Student cubits are factories: the portal shell creates one per visit.
/// Staff cubits follow the same pattern for the future staff portal shell.
/// Public ID-card verification is a factory so each visit starts clean.
void registerRegistrationModule(GetIt sl) {
  sl.registerFactory<RegistrationCubit>(RegistrationCubit.new);
  sl.registerFactory<StaffApprovalsCubit>(StaffApprovalsCubit.new);
  sl.registerFactory<RegistryCubit>(RegistryCubit.new);
  sl.registerFactory<IdCardVerificationCubit>(IdCardVerificationCubit.new);
}
