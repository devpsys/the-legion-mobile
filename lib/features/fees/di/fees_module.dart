import 'package:get_it/get_it.dart';

import '../presentation/bloc/fee_checkout_cubit.dart';
import '../presentation/bloc/fees_cubit.dart';

/// Registers the student fees screens.
///
/// Factories, not singletons: the fees cubit is created by the shell branch
/// that hosts the tab and lives as long as it does, and the checkout cubit
/// holds one visit's choices, which the next visit must start without.
void registerFeesModule(GetIt sl) {
  sl.registerFactory<FeesCubit>(FeesCubit.new);
  sl.registerFactory<FeeCheckoutCubit>(FeeCheckoutCubit.new);
}
