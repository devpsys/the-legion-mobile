import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../models/staff/exam_office_models.dart';
import '../examinations_labels.dart';
import 'exam_office_block.dart';
import 'exam_office_labels.dart';

/// A student's semester at a glance: standing, CGPA, and each course with its
/// verdict. A mark held back by an incident is called out as provisional.
class DossierBody extends StatelessWidget {
  const DossierBody({required this.dossier, super.key});

  final StudentDossier dossier;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final provisional = dossier.provisionalCourse;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dossier.name,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  StatusTag(
                    label: ExaminationsLabels.standing(l10n, dossier.standing),
                    tone: ExaminationsLabels.standingTone(dossier.standing),
                  ),
                ],
              ),
              Text(
                l10n.examOfficeDossierLine(dossier.matric, dossier.programme),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              ExamOfficeMetricRow(
                metrics: [
                  ExamOfficeMetric(
                    value: dossier.cgpa.toStringAsFixed(2),
                    caption: l10n.examOfficeDossierCgpa,
                  ),
                  ExamOfficeMetric(
                    value: l10n.examOfficeUnitsOf(
                      dossier.unitsPassed,
                      dossier.unitsTaken,
                    ),
                    caption: l10n.examOfficeDossierUnits,
                  ),
                  ExamOfficeMetric(
                    value: dossier.classification,
                    caption: l10n.examOfficeDossierClassification,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (provisional != null) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          ToneCallout(
            tone: AppTone.warning,
            icon: Icons.hourglass_top,
            title: l10n.examOfficeProvisionalTitle,
            body: l10n.examOfficeProvisionalBody(provisional.code),
          ),
        ],
        AppSpacing.verticalGap(AppSpacing.lg),
        ExamOfficeBlock(
          title: l10n.examOfficeDossierCourses(dossier.termLabel),
          children: [
            for (final course in dossier.courses)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.examOfficeCourseLine(
                              course.code,
                              course.title,
                            ),
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            course.score == null
                                ? l10n.examOfficeDossierNoScore(course.units)
                                : l10n.examOfficeDossierScore(
                                    course.grade ?? '',
                                    course.score!,
                                    course.units,
                                  ),
                            style: AppTextStyles.codeSmall.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusTag(
                      label: ExamOfficeLabels.verdict(l10n, course.verdict),
                      tone: ExamOfficeLabels.verdictTone(course.verdict),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
