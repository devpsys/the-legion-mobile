import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_labels.dart';

/// One line of the incident file. After a dry run it also says what the
/// import would do with it, and why.
class ImportRowTile extends StatelessWidget {
  const ImportRowTile({required this.row, this.report, super.key});

  final ImportRow row;
  final ImportRowReport? report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final report = this.report;
    final subject = row.subject.trim();

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.examOfficeImportRowLine(
                    row.courseCode,
                    subject.isEmpty
                        ? l10n.examOfficeIncidentNoStudent
                        : subject,
                  ),
                  style: AppTextStyles.codeMedium.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              if (report != null)
                StatusTag(
                  label: ExamOfficeLabels.importAction(l10n, report.action),
                  tone: ExamOfficeLabels.importTone(report.action),
                ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.examOfficeImportRowKind(row.kindText, row.time),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            row.description.trim().isEmpty
                ? l10n.examOfficeNoValue
                : row.description,
            style: theme.textTheme.bodySmall,
          ),
          if (report != null) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              ExamOfficeLabels.importReason(l10n, report.reason),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
