import 'package:flutter_bloc/flutter_bloc.dart';

import '../../mock/staff/registry_fixtures.dart';
import '../../models/staff/registry_models.dart';

class IdCardVerificationState {
  const IdCardVerificationState({
    this.code = '',
    this.result = const IdCardVerificationResult(
      outcome: IdCardVerificationOutcome.idle,
    ),
  });

  final String code;
  final IdCardVerificationResult result;

  IdCardVerificationState copyWith({
    String? code,
    IdCardVerificationResult? result,
  }) {
    return IdCardVerificationState(
      code: code ?? this.code,
      result: result ?? this.result,
    );
  }
}

/// Public student ID card check — five fields only when valid.
class IdCardVerificationCubit extends Cubit<IdCardVerificationState> {
  IdCardVerificationCubit() : super(const IdCardVerificationState());

  void setCode(String value) {
    emit(state.copyWith(code: value));
  }

  void verify([String? raw]) {
    final code = (raw ?? state.code).trim();
    emit(
      state.copyWith(
        code: code,
        result: RegistryFixtures.verifyCode(code),
      ),
    );
  }

  void verifyCode(String raw) => verify(raw);
}
