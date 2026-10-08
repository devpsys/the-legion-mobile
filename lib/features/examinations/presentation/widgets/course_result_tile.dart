import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/examinations_models.dart';
import 'examinations_labels.dart';

/// One course pod: a grade tile and score, a resit's two sittings, a held
/// mark, or a course that has not been marked.
class CourseResultTile extends StatelessWidget {
  const CourseResultTile({
    required this.course,
    required this.termLabel,
    super.key,
  });

  final CourseResult course;

  /// The term this mark belongs to, printed beside a resit score.
  final String termLabel;

  @override
  Widget build(BuildContext context) {
    if (course.isHeldBack) return HeldBackCoursePod(course: course);
    return MarkedCoursePod(course: course, termLabel: termLabel);
  }
}

/// A mark the examinations office is holding back.
class HeldBackCoursePod extends StatelessWidget {
  const HeldBackCoursePod({required this.course, super.key});

  final CourseResult course;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final tone = AppTone.danger;
    final foreground = tone.foreground(theme.brightness);

    return Container(
      decoration: BoxDecoration(
        color: tone.surface(theme.brightness),
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: tone.border(theme.brightness)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: AppDimensions.accentStripeWide,
              decoration: BoxDecoration(
                color: foreground,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppRadii.block),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: AppSpacing.card,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          size: AppDimensions.iconSmall,
                          color: foreground,
                        ),
                        AppSpacing.horizontalGap(AppSpacing.sm),
                        Text(
                          course.code,
                          style: AppTextStyles.codeMedium.copyWith(
                            color: foreground,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const Spacer(),
                        HeldBackTag(label: l10n.examCourseHeldBack),
                      ],
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.examCourseHeldBackNote,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: foreground,
                        height: AppTextStyles.relaxedLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarkedCoursePod extends StatelessWidget {
  const MarkedCoursePod({
    required this.course,
    required this.termLabel,
    super.key,
  });

  final CourseResult course;
  final String termLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final gradeTone = ExaminationsLabels.gradeTone(course.grade);
    final muted = theme.colorScheme.onSurfaceVariant;
    final resit = course.resit;

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppDimensions.iconLarge,
            height: AppDimensions.iconLarge,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: course.isMarked
                  ? gradeTone.surface(theme.brightness)
                  : theme.colorScheme.surfaceContainer,
              borderRadius: AppRadii.elementRadius,
            ),
            child: Text(
              course.isMarked
                  ? (course.grade ?? l10n.examCourseNoGrade)
                  : l10n.examCourseNoGrade,
              style: AppTextStyles.codeMedium.copyWith(
                fontWeight: AppTextStyles.bold,
                color: course.isMarked
                    ? gradeTone.foreground(theme.brightness)
                    : muted,
              ),
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      course.code,
                      style: AppTextStyles.codeMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    if (resit != null)
                      StatusTag(label: l10n.examCourseResit, tone: AppTone.warning),
                    if (course.isMarked)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainer,
                          borderRadius: AppRadii.tagRadius,
                        ),
                        child: Text(
                          l10n.examUnitsValue(course.units),
                          style: AppTextStyles.codeSmall.copyWith(color: muted),
                        ),
                      ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  course.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: muted),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          if (course.isMarked && resit != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SittingScore(
                  score: '${resit.previousScore}',
                  caption: resit.previousTermLabel,
                  struck: true,
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                SittingScore(
                  score: '${course.score}',
                  caption: l10n.examCourseResitWhen(termLabel),
                ),
              ],
            )
          else if (course.isMarked)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${course.score}',
                  style: AppTextStyles.tabular(
                    AppTextStyles.codeLarge.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  l10n.examCourseOutOf,
                  style: theme.textTheme.bodySmall?.copyWith(color: muted),
                ),
              ],
            )
          else
            Text(
              l10n.examCourseNotMarked,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: muted,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}

/// One sitting on the right of a course pod: the mark, then its caption.
class SittingScore extends StatelessWidget {
  const SittingScore({
    required this.score,
    required this.caption,
    this.struck = false,
    super.key,
  });

  final String score;
  final String caption;

  /// Earlier attempt: the figure is struck, the term beside it is not.
  final bool struck;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final muted = theme.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          score,
          style: AppTextStyles.tabular(
            (struck ? AppTextStyles.codeSmall : AppTextStyles.codeMedium)
                .copyWith(
              color: struck ? muted : theme.colorScheme.onSurface,
              fontWeight: struck ? AppTextStyles.medium : AppTextStyles.bold,
              decoration: struck ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.xs),
        Text(
          caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(color: muted),
        ),
      ],
    );
  }
}

/// White pill with a danger pip, as the held-back card draws it.
class HeldBackTag extends StatelessWidget {
  const HeldBackTag({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final foreground = AppTone.danger.foreground(theme.brightness);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.indicator,
            height: AppDimensions.indicator,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
