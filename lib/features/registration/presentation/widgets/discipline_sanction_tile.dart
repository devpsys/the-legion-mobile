import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../models/registration_models.dart';
import 'registration_labels.dart';

/// One sanction row on the Disciplinary matters list.
class DisciplineSanctionTile extends StatelessWidget {
  const DisciplineSanctionTile({
    required this.sanction,
    required this.caseReference,
    super.key,
  });

  final DisciplineSanction sanction;
  final String caseReference;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final typeLabel = RegistrationLabels.sanctionType(l10n, sanction.type);
    final lifecycleLabel = RegistrationLabels.sanctionLifecycle(
      l10n,
      sanction.lifecycle,
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _iconFor(sanction.type),
                size: AppDimensions.iconDense,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeLabel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.disciplineSanctionCaseRef(caseReference),
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              StatusTag(
                label: lifecycleLabel,
                tone: sanction.lifecycle.tone,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            sanction.summary,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          if (sanction.statusNote.isNotEmpty) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            ToneCallout(
              tone: AppTone.info,
              icon: Icons.info_outline,
              body: sanction.statusNote,
            ),
          ],
        ],
      ),
    );
  }

  IconData _iconFor(SanctionType type) => switch (type) {
    SanctionType.warning => Icons.warning_amber_outlined,
    SanctionType.probation => Icons.hourglass_bottom_outlined,
    SanctionType.suspension => Icons.pause_circle_outline,
    SanctionType.expulsion => Icons.gavel_outlined,
  };
}
