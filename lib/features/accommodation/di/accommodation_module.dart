import 'package:get_it/get_it.dart';

import '../presentation/bloc/accommodation_cubit.dart';
import '../presentation/bloc/staff/housing_cubit.dart';

/// Registers Accommodation presentation dependencies.
///
/// Cubits are factories: the portal shell creates one per visit, so a student
/// who leaves and comes back starts from a freshly loaded ledger.
void registerAccommodationModule(GetIt sl) {
  sl.registerFactory<AccommodationCubit>(AccommodationCubit.new);
  sl.registerFactory<HousingCubit>(HousingCubit.new);
}
