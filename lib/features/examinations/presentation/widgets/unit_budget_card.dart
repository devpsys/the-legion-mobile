import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/examinations_models.dart';

/// The open resit window and the semester's unit allowance, as one ledger:
/// status, a segmented meter, and a ring of how much of the cap is used.
class UnitBudgetCard extends StatelessWidget {
  const UnitBudgetCard({required this.record, super.key});

  final ResitsRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final muted = theme.colorScheme.onSurfaceVariant;
    final primary = theme.colorScheme.primary;
    final date = AppDateFormats.long(l10n.localeName).format(record.windowDate);
    final cap = record.unitCap;
    final used = cap == 0 ? 0 : record.unitsUsed.clamp(0, cap);
    final percent = cap == 0 ? 0 : ((used / cap) * 100).round();

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
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
                    Container(
                      width: AppDimensions.indicator,
                      height: AppDimensions.indicator,
                      decoration: const BoxDecoration(
                        color: AppColors.portalStudent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.xs),
                    Text(
                      l10n.examResitWindowOpen(record.windowLabel),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: primary,
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: AppDimensions.iconSmall,
                    color: muted,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.xs),
                  Text(
                    l10n.examResitWindowCloses(date),
                    style: AppTextStyles.codeSmall.copyWith(color: muted),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Divider(color: theme.colorScheme.outlineVariant),
          AppSpacing.verticalGap(AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.examResitBudgetTitle.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: muted,
                              fontWeight: AppTextStyles.semiBold,
                              letterSpacing: AppTextStyles.trackingCaps,
                            ),
                          ),
                        ),
                        AppSpacing.horizontalGap(AppSpacing.sm),
                        Text(
                          l10n.examResitBudgetUsed(cap, used),
                          style: AppTextStyles.tabular(
                            AppTextStyles.codeMedium.copyWith(
                              color: primary,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    UnitAllowanceMeter(used: used, cap: cap),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.examResitBudgetLeft(record.unitsLeft),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: muted,
                            ),
                          ),
                        ),
                        AppSpacing.horizontalGap(AppSpacing.sm),
                        Text(
                          l10n.examResitCapCapacity(percent),
                          style: AppTextStyles.codeSmall.copyWith(
                            color: primary,
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              UnitAllowanceRing(
                used: used,
                cap: cap,
                label: l10n.examResitBudgetRatio(cap, used),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One segment per unit in the semester cap, filled up to the units used.
class UnitAllowanceMeter extends StatelessWidget {
  const UnitAllowanceMeter({required this.used, required this.cap, super.key});

  final int used;
  final int cap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final segments = cap <= 0 ? 1 : cap;
    final filled = cap <= 0 ? 0 : used.clamp(0, cap);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.hairline),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
        borderRadius: AppRadii.chipRadius,
      ),
      child: Row(
        children: [
          for (var i = 0; i < segments; i++) ...[
            if (i > 0) AppSpacing.horizontalGap(AppSpacing.xs),
            Expanded(
              child: Container(
                height: AppDimensions.trackHeight,
                decoration: BoxDecoration(
                  color: i < filled
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: AppRadii.tagRadius,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A ring of the cap, with the used-over-cap figure in the middle.
class UnitAllowanceRing extends StatelessWidget {
  const UnitAllowanceRing({
    required this.used,
    required this.cap,
    required this.label,
    super.key,
  });

  final int used;
  final int cap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final fraction = cap <= 0 ? 0.0 : (used / cap).clamp(0, 1).toDouble();

    return Container(
      width: AppDimensions.statusBadge,
      height: AppDimensions.statusBadge,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size.square(AppDimensions.iconLarge),
            painter: UnitAllowanceRingPainter(
              fraction: fraction,
              track: theme.colorScheme.surfaceContainerHighest,
              fill: theme.colorScheme.primary,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.tabular(
              AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws the allowance ring: a full track, then the used arc from the top.
class UnitAllowanceRingPainter extends CustomPainter {
  const UnitAllowanceRingPainter({
    required this.fraction,
    required this.track,
    required this.fill,
  });

  final double fraction;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = AppDimensions.accentStripeTop;
    final inset = stroke / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - stroke,
      size.height - stroke,
    );
    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, trackPaint);
    if (fraction > 0) {
      canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * fraction, false, fillPaint);
    }
  }

  @override
  bool shouldRepaint(UnitAllowanceRingPainter oldDelegate) {
    return oldDelegate.fraction != fraction ||
        oldDelegate.track != track ||
        oldDelegate.fill != fill;
  }
}
