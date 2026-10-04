import 'package:get_it/get_it.dart';

import '../presentation/bloc/admission_verification_cubit.dart';
import '../presentation/bloc/admissions_cubit.dart';

/// Registers the candidate admissions portal and the public letter check.
///
/// Factories, not singletons: the portal cubit owns the confirmation-banner
/// state for the current session, so leaving the portal and coming back starts
/// clean; and the verification cubit holds one visitor's lookup, which the
/// next visitor must not see.
void registerAdmissionsModule(GetIt sl) {
  sl.registerFactory<AdmissionsCubit>(AdmissionsCubit.new);
  sl.registerFactory<AdmissionVerificationCubit>(
    AdmissionVerificationCubit.new,
  );
}
