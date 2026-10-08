import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import 'exam_office_block.dart';
import 'exam_office_field.dart';

/// The two CGPAs that decide a student's standing: below the first they are
/// on probation, below the second the office advises withdrawal.
class StandingRulesCard extends StatefulWidget {
  const StandingRulesCard({
    required this.probationCgpa,
    required this.withdrawalCgpa,
    super.key,
  });

  final double probationCgpa;
  final double withdrawalCgpa;

  @override
  StandingRulesCardState createState() => StandingRulesCardState();
}

/// State of [StandingRulesCard].
class StandingRulesCardState extends State<StandingRulesCard> {
  late final TextEditingController _probation = TextEditingController(
    text: widget.probationCgpa.toStringAsFixed(2),
  );
  late final TextEditingController _withdrawal = TextEditingController(
    text: widget.withdrawalCgpa.toStringAsFixed(2),
  );

  @override
  void dispose() {
    _probation.dispose();
    _withdrawal.dispose();
    super.dispose();
  }

  void _save() {
    context.read<ExamOfficeCubit>().saveThresholds(
      probation: double.tryParse(_probation.text.trim()) ?? 0,
      withdrawal: double.tryParse(_withdrawal.text.trim()) ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficeBlock(
      title: l10n.examOfficeStandingRulesTitle,
      description: l10n.examOfficeStandingRulesBody,
      children: [
        ExamOfficeField(
          label: l10n.examOfficeProbationLabel,
          controller: _probation,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        ExamOfficeField(
          label: l10n.examOfficeWithdrawalLabel,
          controller: _withdrawal,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton(
            onPressed: _save,
            child: Text(l10n.examOfficeStandingRulesSave),
          ),
        ),
      ],
    );
  }
}
