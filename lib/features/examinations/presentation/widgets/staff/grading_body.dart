import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../bloc/staff/exam_office_state.dart';
import 'exam_office_entry_card.dart';
import 'standing_rules_card.dart';

/// The grading scales, and the CGPAs that decide a student's standing.
class GradingBody extends StatelessWidget {
  const GradingBody({required this.state, super.key});

  final ExamOfficeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final scale in state.scales) ...[
          ExamOfficeEntryCard(
            icon: Icons.grade_outlined,
            title: scale.name,
            body: l10n.examOfficeScaleBody(scale.appliesTo, scale.bands.length),
            trailing: scale.hasGap
                ? StatusTag(
                    label: l10n.examOfficeScaleBroken,
                    tone: AppTone.danger,
                  )
                : scale.isDefault
                ? StatusTag(
                    label: l10n.examOfficeScaleDefault,
                    tone: AppTone.success,
                  )
                : null,
            onOpen: () => context.goNamed(
              Routes.examOfficeGradingScaleName,
              pathParameters: {Routes.examOfficeScaleIdParam: scale.id},
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
        AppSpacing.verticalGap(AppSpacing.md),
        StandingRulesCard(
          key: ValueKey('${state.probationCgpa}/${state.withdrawalCgpa}'),
          probationCgpa: state.probationCgpa,
          withdrawalCgpa: state.withdrawalCgpa,
        ),
      ],
    );
  }
}
