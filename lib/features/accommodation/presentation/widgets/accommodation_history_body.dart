import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../bloc/accommodation_state.dart';
import '../models/accommodation_models.dart';
import 'accommodation_labels.dart';
import 'history_record_tile.dart';

/// The student's accommodation history: the current allocation (or the lack
/// of one) above the permanent ledger of past beds.
class AccommodationHistoryBody extends StatelessWidget {
  const AccommodationHistoryBody({required this.state, super.key});

  final AccommodationState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final student = state.student;
    final term = state.current;
    final records = state.history;
    if (student == null || term == null) return const SizedBox.shrink();
    final bed = term.bed;
    final hasBed =
        bed != null &&
        term.phase != AllocationPhase.notScheduled &&
        term.phase != AllocationPhase.roomList &&
        term.phase != AllocationPhase.needsTerms;

    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.accommodationTitle,
                style: theme.textTheme.headlineSmall,
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                l10n.accommodationSubtitle(term.label),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            student.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: AppTextStyles.semiBold,
                            ),
                          ),
                        ),
                        StatusTag(
                          label: hasBed
                              ? AccommodationLabels.phaseStatus(
                                  l10n,
                                  term.phase,
                                )
                              : l10n.accommodationHistoryNoCurrent,
                          tone: hasBed
                              ? AccommodationLabels.phaseTone(term.phase)
                              : AppTone.neutral,
                        ),
                      ],
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.accommodationMatricLevel(
                        student.matricNumber,
                        student.level,
                      ),
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.lg),
                    Icon(
                      hasBed ? Icons.bed : Icons.bed_outlined,
                      size: AppDimensions.iconLarge,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    AppSpacing.verticalGap(AppSpacing.sm),
                    Text(
                      hasBed
                          ? AccommodationLabels.bedFull(l10n, bed)
                          : l10n.accommodationHistoryNoBed(term.label),
                      style: theme.textTheme.titleMedium,
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      hasBed
                          ? l10n.accommodationHistoryCurrentBody
                          : l10n.accommodationHistoryNoBedBody,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: AppTextStyles.relaxedLineHeight,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: () =>
                          context.goNamed(Routes.accommodationName),
                      icon: const Icon(Icons.campaign_outlined),
                      label: Text(l10n.accommodationHistoryOpenings),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              Row(
                children: [
                  Icon(
                    Icons.history_edu_outlined,
                    size: AppDimensions.iconDense,
                    color: theme.colorScheme.primary,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.accommodationHistoryTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    l10n.accommodationHistoryCount(records.length),
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                l10n.accommodationHistoryIntro,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              if (records.isEmpty)
                SurfaceCard(
                  child: Column(
                    children: [
                      Icon(
                        Icons.hotel_outlined,
                        size: AppDimensions.iconLarge,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      AppSpacing.verticalGap(AppSpacing.sm),
                      Text(
                        l10n.accommodationHistoryEmptyTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        l10n.accommodationHistoryEmptyBody,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                for (final record in records) ...[
                  HistoryRecordTile(record: record),
                  AppSpacing.verticalGap(AppSpacing.md),
                ],
                OutlinedButton.icon(
                  onPressed: () => context.showMessage(l10n.commonComingSoon),
                  icon: const Icon(Icons.rule_folder_outlined),
                  label: Text(l10n.accommodationHistoryExport),
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Center(
                  child: Text(
                    l10n.accommodationHistoryDisplaying(records.length),
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
