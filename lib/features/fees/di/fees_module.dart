import 'package:get_it/get_it.dart';

import '../presentation/bloc/fee_card_checkout_cubit.dart';
import '../presentation/bloc/fee_checkout_cubit.dart';
import '../presentation/bloc/fee_gateway_return_cubit.dart';
import '../presentation/bloc/fee_receipt_cubit.dart';
import '../presentation/bloc/fees_cubit.dart';
import '../presentation/bloc/receipt_verification_cubit.dart';

/// Registers the student fees screens.
///
/// Factories, not singletons: the fees cubit is created by the shell branch
/// that hosts the tab and lives as long as it does; the checkout, card,
/// return and receipt cubits each hold one visit and must start clean.
void registerFeesModule(GetIt sl) {
  sl.registerFactory<FeesCubit>(FeesCubit.new);
  sl.registerFactory<FeeCheckoutCubit>(FeeCheckoutCubit.new);
  sl.registerFactory<FeeCardCheckoutCubit>(FeeCardCheckoutCubit.new);
  sl.registerFactory<FeeGatewayReturnCubit>(FeeGatewayReturnCubit.new);
  sl.registerFactory<FeeReceiptCubit>(FeeReceiptCubit.new);
  sl.registerFactory<ReceiptVerificationCubit>(ReceiptVerificationCubit.new);
}
