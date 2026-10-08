import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_labels.dart';

/// One student's line on a course broadsheet: score, grade and verdict, with a
/// way to the student's dossier when they have one.
class BroadsheetRowTile extends StatelessWidget {
  const BroadsheetRowTile({required this.row, super.key});

  final BroadsheetRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final score = row.score;

    final content = SurfaceCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
                Text(
                  row.matric,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score == null
                    ? l10n.examOfficeNoValue
                    : l10n.examOfficeScoreGrade(row.grade ?? '', score),
                style: AppTextStyles.tabular(theme.textTheme.titleSmall!),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              StatusTag(
                label: ExamOfficeLabels.verdict(l10n, row.verdict),
                tone: ExamOfficeLabels.verdictTone(row.verdict),
              ),
            ],
          ),
          if (row.hasDossier) ...[
            AppSpacing.horizontalGap(AppSpacing.sm),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );

    if (!row.hasDossier) return content;
    return InkWell(
      onTap: () => context.goNamed(
        Routes.examOfficeDossierName,
        pathParameters: {Routes.examOfficeMatricParam: row.matric},
      ),
      child: content,
    );
  }
}
