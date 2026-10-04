import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/receipt_verification_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/receipt_verification_state.dart';
import 'package:the_legion_mobile/features/fees/presentation/mock/fees_fixtures.dart';

void main() {
  late ReceiptVerificationCubit cubit;

  setUp(() => cubit = ReceiptVerificationCubit());
  tearDown(() => cubit.close());

  test('verifies a genuine code to the five public facts', () {
    cubit.verifyCode(FeesFixtures.receiptVerificationCode);

    expect(cubit.state.status, ReceiptVerificationStatus.verified);
    final result = cubit.state.result!;
    expect(result.receiptNumber, 'REC-2027-098812');
    expect(result.amountMinorUnits, 6635000);
    expect(result.paidBy, 'Amaka Bello');
    expect(result.paidFor, 'Tuition balance & faculty levy');
    // Privacy: the result model has no matric field to leak.
    expect(result.props, hasLength(5));
  });

  test('formats and accepts a hyphenated code', () {
    cubit.verifyCode('9K8L-4M2P-TX77');

    expect(cubit.state.status, ReceiptVerificationStatus.verified);
  });

  test('unknown codes are not found', () {
    cubit.verifyCode('AAAAAAAAAAAA');

    expect(cubit.state.status, ReceiptVerificationStatus.notFound);
    expect(cubit.state.result, isNull);
  });

  test('changing the code voids the last answer', () {
    cubit.verifyCode(FeesFixtures.receiptVerificationCode);
    cubit.codeChanged('partial');

    expect(cubit.state.status, ReceiptVerificationStatus.idle);
    expect(cubit.state.result, isNull);
  });
}
