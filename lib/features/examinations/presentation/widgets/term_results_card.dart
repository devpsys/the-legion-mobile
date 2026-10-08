import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/examinations_models.dart';
import 'course_result_tile.dart';

/// One semester as a dossier: term banner, course pods, then the unit ledger.
class TermResultsCard extends StatelessWidget {
  const TermResultsCard({
    required this.term,
    required this.cumulativeCgpa,
    super.key,
  });

  final TermResult term;
  final double cumulativeCgpa;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final muted = theme.colorScheme.onSurfaceVariant;

    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            color: theme.colorScheme.surfaceContainerLow,
            child: Row(
              children: [
                Container(
                  width: AppDimensions.indicator,
                  height: AppDimensions.indicator,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Text(
                  term.label,
                  style: AppTextStyles.codeMedium.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Container(
                  width: AppSpacing.xs,
                  height: AppSpacing.xs,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    term.levelLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: muted,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: AppRadii.chipRadius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.examResultsSemesterGpaLabel.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: muted.withValues(alpha: 0.8),
                          letterSpacing: AppTextStyles.trackingCaps,
                        ),
                      ),
                      AppSpacing.horizontalGap(AppSpacing.xs),
                      Text(
                        term.gpa.toStringAsFixed(2),
                        style: AppTextStyles.tabular(
                          AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSpacing.card,
            child: Column(
              children: [
                for (var i = 0; i < term.courses.length; i++) ...[
                  if (i > 0) AppSpacing.verticalGap(AppSpacing.sm),
                  CourseResultTile(course: term.courses[i], termLabel: term.label),
                ],
              ],
            ),
          ),
          Container(
            padding: AppSpacing.card,
            color: theme.colorScheme.surfaceContainerLow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TermLedgerTile(
                        icon: Icons.menu_book_outlined,
                        label: l10n.examTermUnitsTaken,
                        value: l10n.examUnitsValue(term.unitsTaken),
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: TermLedgerTile(
                        icon: Icons.task_alt,
                        label: l10n.examTermUnitsPassed,
                        value: l10n.examUnitsValue(term.unitsPassed),
                        tone: AppTone.success,
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TermLedgerTile(
                        icon: Icons.query_stats,
                        label: l10n.examResultsSemesterGpaLabel,
                        value: term.gpa.toStringAsFixed(2),
                        tone: AppTone.info,
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: TermLedgerTile(
                        icon: Icons.school_outlined,
                        label: l10n.examResultsCumulativeCgpa,
                        value: cumulativeCgpa.toStringAsFixed(2),
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: AppDimensions.iconSmall,
                      color: muted,
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.examResultsResitNote,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: muted,
                          height: AppTextStyles.relaxedLineHeight,
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

/// One cell of the semester ledger: a label and a figure.
class TermLedgerTile extends StatelessWidget {
  const TermLedgerTile({
    required this.icon,
    required this.label,
    required this.value,
    this.tone,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppTone? tone;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final accent = tone?.foreground(theme.brightness) ??
        theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppDimensions.iconMicro, color: accent),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: accent,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.tabular(
              AppTextStyles.codeLarge.copyWith(
                fontWeight: AppTextStyles.bold,
                color: tone?.foreground(theme.brightness) ??
                    theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
