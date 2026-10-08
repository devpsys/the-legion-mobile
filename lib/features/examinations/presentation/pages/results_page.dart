import 'package:flutter/material.dart';

import '../widgets/examinations_page_frame.dart';
import '../widgets/examinations_tab_bar.dart';
import '../widgets/results_body.dart';

/// Results hub: published marks, the CGPA and where the student stands, or an
/// empty state while nothing is published.
class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExaminationsPageFrame(
      destination: ExaminationsDestination.results,
      builder: (context, state) {
        final student = state.student;
        final results = state.results;
        if (student == null || results == null) return const SizedBox.shrink();
        return ResultsBody(student: student, record: results);
      },
    );
  }
}
