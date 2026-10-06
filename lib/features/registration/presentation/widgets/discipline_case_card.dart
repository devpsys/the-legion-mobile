import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/registration_models.dart';
import 'registration_labels.dart';

/// One disciplinary case row on the Disciplinary matters list.
class DisciplineCaseCard extends StatelessWidget {
  const DisciplineCaseCard({
    required this.item,
    required this.onOpen,
    super.key,
  });

  final DisciplineCase item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final dateFormat = AppDateFormats.medium(l10n.localeName);
    final statusLabel = RegistrationLabels.disciplineCaseStatus(
      l10n,
      item.status,
    );
    final severityLabel = RegistrationLabels.disciplineSeverity(
      l10n,
      item.severity,
    );
    final categoryLabel = RegistrationLabels.disciplineCategory(
      l10n,
      item.category,
    );
    final opened = l10n.disciplineOpenedOn(dateFormat.format(item.openedOn));

    return InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.reference,
                    style: AppTextStyles.codeMedium.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                StatusTag(label: statusLabel, tone: item.status.tone),
                AppSpacing.horizontalGap(AppSpacing.xs),
                Icon(
                  Icons.chevron_right,
                  size: AppDimensions.iconDense,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              item.summary,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              l10n.disciplineCaseMeta(severityLabel, categoryLabel, opened),
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (item.listDetail.isNotEmpty) ...[
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                item.listDetail,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
