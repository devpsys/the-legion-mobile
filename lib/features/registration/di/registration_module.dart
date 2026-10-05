import 'package:get_it/get_it.dart';

import '../presentation/bloc/registration_cubit.dart';

/// Registers the student Registration & Records screens.
///
/// A factory: the portal shell creates one cubit for the visit and tears it
/// down when the student leaves for the hub.
void registerRegistrationModule(GetIt sl) {
  sl.registerFactory<RegistrationCubit>(RegistrationCubit.new);
}
