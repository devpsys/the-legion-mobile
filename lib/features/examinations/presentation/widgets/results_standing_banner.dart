import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/examinations_models.dart';
import 'examinations_labels.dart';

/// Standing pill and the cumulative grade point, as the dossier's hero.
class ResultsStandingBanner extends StatelessWidget {
  const ResultsStandingBanner({required this.record, super.key});

  final ResultsRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final tone = ExaminationsLabels.standingTone(record.standing);
    final primary = theme.colorScheme.primary;
    final info = AppTone.info.foreground(theme.brightness);
    final infoMuted = info.withValues(alpha: 0.8);

    return SurfaceCard(
      padding: AppSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              StatusTag(
                label: ExaminationsLabels.standing(l10n, record.standing),
                tone: tone,
                icon: record.standing == StandingKind.good
                    ? Icons.check_circle_outline
                    : Icons.warning_amber_outlined,
              ),
              const Spacer(),
              Icon(
                Icons.verified_outlined,
                size: AppDimensions.iconMicro,
                color: primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Text(
                l10n.examResultsSenateApproved.toUpperCase(),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: AppTextStyles.semiBold,
                  letterSpacing: AppTextStyles.trackingCaps,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Container(
            padding: AppSpacing.card,
            decoration: BoxDecoration(
              color: AppTone.info.surface(theme.brightness),
              borderRadius: AppRadii.blockRadius,
              border: Border.all(color: AppTone.info.border(theme.brightness)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.examResultsCumulativeLabel.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: info,
                          fontWeight: AppTextStyles.semiBold,
                          letterSpacing: AppTextStyles.trackingCaps,
                        ),
                      ),
                    ),
                    Text(
                      l10n.examCgpaValue(record.cgpa.toStringAsFixed(2)),
                      style: AppTextStyles.tabular(
                        AppTextStyles.codeLarge.copyWith(
                          color: info,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Divider(
                  color: info.withValues(alpha: 0.15),
                  height: AppDimensions.hairline,
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: AppDimensions.iconMicro,
                      color: infoMuted,
                    ),
                    AppSpacing.horizontalGap(AppSpacing.xs),
                    Expanded(
                      child: Text(
                        l10n.examCgpaNote,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: infoMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
