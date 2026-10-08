import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../models/examinations_models.dart';
import 'examinations_page_header.dart';
import 'resit_failures_section.dart';
import 'resit_how_it_works.dart';
import 'resit_policy_note.dart';
import 'resit_registrations_section.dart';
import 'resit_window_banner.dart';
import 'unit_budget_card.dart';

/// The resits tab: it switches on whether the window is open or closed.
class ResitsBody extends StatelessWidget {
  const ResitsBody({required this.student, required this.record, super.key});

  final ExamStudent student;
  final ResitsRecord record;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExaminationsScrollBody(
      title: l10n.examResitsTitle,
      subtitle: l10n.examResitsSubtitle(student.matricNumber),
      children: [
        const ResitPolicyNote(),
        if (record.isOpen)
          UnitBudgetCard(record: record)
        else
          ResitWindowBanner(record: record),
        ResitFailuresSection(record: record),
        if (record.registrations.isNotEmpty)
          ResitRegistrationsSection(record: record),
        if (record.isOpen) ResitHowItWorks(record: record),
      ],
    );
  }
}
