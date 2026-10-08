import 'package:flutter/material.dart';

import '../widgets/examinations_page_frame.dart';
import '../widgets/examinations_tab_bar.dart';
import '../widgets/resits_body.dart';

/// Resit registration: the window, the unit allowance, the failed courses and
/// what the student has already registered.
class ResitsPage extends StatelessWidget {
  const ResitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExaminationsPageFrame(
      destination: ExaminationsDestination.resits,
      builder: (context, state) {
        final student = state.student;
        final resits = state.resits;
        if (student == null || resits == null) return const SizedBox.shrink();
        return ResitsBody(student: student, record: resits);
      },
    );
  }
}
