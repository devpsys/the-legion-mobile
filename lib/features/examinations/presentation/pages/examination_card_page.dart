import 'package:flutter/material.dart';

import '../widgets/card_body.dart';
import '../widgets/examinations_page_frame.dart';
import '../widgets/examinations_tab_bar.dart';

/// The examination card: clearance gates, the issued card or the withdrawal.
class ExaminationCardPage extends StatelessWidget {
  const ExaminationCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExaminationsPageFrame(
      destination: ExaminationsDestination.card,
      builder: (context, state) {
        final student = state.student;
        final card = state.card;
        if (student == null || card == null) return const SizedBox.shrink();
        return CardBody(student: student, card: card);
      },
    );
  }
}
