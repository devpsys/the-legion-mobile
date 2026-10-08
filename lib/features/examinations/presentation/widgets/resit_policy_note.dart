import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';

/// The resit rule, then a worked example of both attempts counting.
class ResitPolicyNote extends StatelessWidget {
  const ResitPolicyNote({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final warning = AppTone.warning.foreground(theme.brightness);
    final primary = theme.colorScheme.primary;

    return SurfaceCard(
      padding: EdgeInsets.zero,
      borderRadius: AppRadii.blockRadius,
      child: ClipRRect(
        borderRadius: AppRadii.blockRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: AppSpacing.card,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    size: AppDimensions.iconMedium,
                    color: warning,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.examResitPolicyBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: AppDimensions.iconDense,
                        color: primary,
                      ),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.examResitWorkedExample,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: primary,
                            fontWeight: AppTextStyles.medium,
                            height: AppTextStyles.relaxedLineHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalGap(AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ResitAttemptPod(
                          label: l10n.examResitAttemptPrevious,
                          value: l10n.examResitExamplePreviousMark,
                          status: l10n.examResitExampleFailed,
                          tone: AppTone.danger,
                        ),
                      ),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      Expanded(
                        child: ResitAttemptPod(
                          label: l10n.examResitAttemptResit,
                          value: l10n.examResitExampleResitMark,
                          status: l10n.examResitBothCount,
                          tone: AppTone.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One sitting in the worked example: the label, the mark, and what it means.
class ResitAttemptPod extends StatelessWidget {
  const ResitAttemptPod({
    required this.label,
    required this.value,
    required this.status,
    required this.tone,
    super.key,
  });

  final String label;
  final String value;
  final String status;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final muted = theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: muted,
              fontWeight: AppTextStyles.semiBold,
              letterSpacing: AppTextStyles.trackingCaps,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.codeMedium.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Text(
                status,
                style: AppTextStyles.codeSmall.copyWith(
                  color: tone.foreground(theme.brightness),
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
