import 'package:get_it/get_it.dart';

import '../presentation/bloc/exam_card_verification_cubit.dart';
import '../presentation/bloc/examinations_cubit.dart';
import '../presentation/bloc/staff/exam_office_cubit.dart';

/// Registers Examinations & Results presentation dependencies.
///
/// Cubits are factories: each portal shell creates one per visit, so a
/// student or officer who leaves and comes back starts from a freshly loaded
/// ledger.
void registerExaminationsModule(GetIt sl) {
  sl.registerFactory<ExaminationsCubit>(ExaminationsCubit.new);
  sl.registerFactory<ExamCardVerificationCubit>(ExamCardVerificationCubit.new);
  sl.registerFactory<ExamOfficeCubit>(ExamOfficeCubit.new);
}
