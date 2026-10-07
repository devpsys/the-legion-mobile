import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/accommodation_models.dart';

/// "What happens next": booked, pay the fee, check in, with the student's
/// place marked.
class NextStepsCard extends StatelessWidget {
  const NextStepsCard({required this.term, super.key});

  final TermAccommodation term;

  /// 1-based stage the student is at.
  int get stage => switch (term.phase) {
    AllocationPhase.held => 2,
    AllocationPhase.confirmed => 3,
    AllocationPhase.checkedIn => 3,
    _ => 1,
  };

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final dates = AppDateFormats.long(l10n.localeName);
    final short = AppDateFormats.short(l10n.localeName);
    final bookedOn = term.bookedOn;
    final deadline = term.deadline;
    final checkIn = term.checkInFrom;
    final isFree = term.isFree;
    final paid =
        term.phase == AllocationPhase.confirmed ||
        term.phase == AllocationPhase.checkedIn;

    final steps = [
      (
        done: true,
        title: l10n.accommodationStepBooked,
        when: bookedOn == null ? '' : dates.format(bookedOn),
        body: l10n.accommodationStepBookedBody,
      ),
      (
        done: paid,
        title: isFree
            ? l10n.accommodationStepCleared
            : paid
            ? l10n.accommodationStepPaid
            : l10n.accommodationStepPay,
        when: !paid && deadline != null
            ? l10n.accommodationStepBy(short.format(deadline))
            : '',
        body: isFree
            ? l10n.accommodationStepClearedBody
            : l10n.accommodationStepPayBody,
      ),
      (
        done: term.phase == AllocationPhase.checkedIn,
        title: l10n.accommodationStepCheckIn,
        when: checkIn == null
            ? ''
            : l10n.accommodationStepFrom(short.format(checkIn)),
        body: l10n.accommodationStepCheckInBody,
      ),
    ];

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.rule,
                size: AppDimensions.iconDense,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.accommodationNextTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                l10n.accommodationNextStage(stage, steps.length),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          for (var i = 0; i < steps.length; i++)
            NextStepRow(
              title: steps[i].title,
              when: steps[i].when,
              body: steps[i].body,
              isDone: steps[i].done,
              isCurrent: i + 1 == stage && !steps[i].done,
              isLast: i == steps.length - 1,
            ),
        ],
      ),
    );
  }
}

/// One step on [NextStepsCard]'s rail.
class NextStepRow extends StatelessWidget {
  const NextStepRow({
    required this.title,
    required this.when,
    required this.body,
    required this.isDone,
    required this.isCurrent,
    required this.isLast,
    super.key,
  });

  final String title;
  final String when;
  final String body;
  final bool isDone;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final accent = isDone || isCurrent
        ? theme.colorScheme.primary
        : theme.colorScheme.outline;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: AppDimensions.marker,
            child: Column(
              children: [
                Container(
                  width: AppDimensions.marker,
                  height: AppDimensions.marker,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? accent : theme.colorScheme.surface,
                    border: Border.all(color: accent),
                  ),
                  child: isDone
                      ? Icon(
                          Icons.check,
                          size: AppDimensions.iconSmall,
                          color: theme.colorScheme.onPrimary,
                        )
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: AppDimensions.hairline,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Padding(
              padding: isLast
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: isCurrent
                                ? AppTextStyles.bold
                                : AppTextStyles.semiBold,
                          ),
                        ),
                      ),
                      if (when.isNotEmpty)
                        Text(
                          when,
                          style: AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    body,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: AppTextStyles.relaxedLineHeight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
