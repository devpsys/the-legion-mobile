import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/examinations_fixtures.dart';
import '../models/examinations_models.dart';

/// State of the public hall-door check: the typed code and the last result.
class ExamCardVerificationState extends Equatable {
  const ExamCardVerificationState({
    this.code = '',
    this.result = const ExamCardCheckResult.idle(),
  });

  final String code;
  final ExamCardCheckResult result;

  @override
  List<Object?> get props => [code, result];
}

/// Uppercase letters and digits only, capped at the code length.
String normaliseExamCardCode(String raw) {
  final cleaned = raw.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');
  return cleaned.length > ExaminationsFixtures.checkCodeLength
      ? cleaned.substring(0, ExaminationsFixtures.checkCodeLength)
      : cleaned;
}

/// Public examination card check — five facts only when valid, no photo.
class ExamCardVerificationCubit extends Cubit<ExamCardVerificationState> {
  ExamCardVerificationCubit() : super(const ExamCardVerificationState());

  void setCode(String value) {
    emit(ExamCardVerificationState(code: normaliseExamCardCode(value)));
  }

  /// Checks [raw], or the typed code when none is given.
  void verify([String? raw]) {
    final code = normaliseExamCardCode(raw ?? state.code);
    emit(
      ExamCardVerificationState(
        code: code,
        result: ExaminationsFixtures.verify(code),
      ),
    );
  }
}
