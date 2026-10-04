import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_gateway_return_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_gateway_return_state.dart';
import 'package:the_legion_mobile/features/fees/presentation/mock/fees_fixtures.dart';
import 'package:the_legion_mobile/features/fees/presentation/models/fees_models.dart';

void main() {
  late FeeGatewayReturnCubit cubit;

  setUp(() => cubit = FeeGatewayReturnCubit());
  tearDown(() => cubit.close());

  test('loads the pending return Pay opens onto', () {
    cubit.load(FeesFixtures.pendingTransactionReference);

    expect(cubit.state.loadStatus, FeeGatewayReturnLoadStatus.ready);
    expect(cubit.state.payment?.status, GatewayReturnStatus.pending);
    expect(cubit.state.canViewReceipt, isFalse);
  });

  test('loads a succeeded return with a receipt id', () {
    cubit.load(FeesFixtures.succeededTransactionReference);

    expect(cubit.state.payment?.status, GatewayReturnStatus.succeeded);
    expect(cubit.state.canViewReceipt, isTrue);
    expect(cubit.state.payment?.receiptId, 'rec-098812');
  });

  test('confirm flips the pending fixture to succeeded', () {
    cubit.load(FeesFixtures.pendingTransactionReference);
    cubit.confirm();

    expect(cubit.state.payment?.status, GatewayReturnStatus.succeeded);
    expect(cubit.state.canViewReceipt, isTrue);
  });

  test('unknown references are not found', () {
    cubit.load('missing');

    expect(cubit.state.loadStatus, FeeGatewayReturnLoadStatus.notFound);
    expect(cubit.state.payment, isNull);
  });
}
