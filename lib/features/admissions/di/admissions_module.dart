import 'package:get_it/get_it.dart';

import '../presentation/bloc/admissions_cubit.dart';

/// Registers the candidate admissions portal.
///
/// A factory, not a singleton: the cubit owns the confirmation-banner state for
/// the current session, so leaving the portal and coming back starts clean.
void registerAdmissionsModule(GetIt sl) {
  sl.registerFactory<AdmissionsCubit>(AdmissionsCubit.new);
}
