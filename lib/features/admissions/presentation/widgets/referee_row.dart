import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../models/application_detail_models.dart';
import 'status_tag.dart';

/// One referee on the record: who they are, whether they have answered, and
/// the two things a candidate can do about it.
///
/// The monogram rather than a photograph: a referee has not consented to
/// being shown anywhere, and initials on a neutral disc are what the design
/// gives them — enough to tell two invitees apart, not enough to be a
/// portrait.
class RefereeRow extends StatelessWidget {
  const RefereeRow({
    required this.referee,
    required this.onResend,
    required this.onRemove,
    super.key,
  });

  final Referee referee;

  final VoidCallback onResend;

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final tone = referee.status.tone;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimensions.monogramSize,
            height: AppDimensions.monogramSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tone.surface(theme.brightness),
              shape: BoxShape.circle,
            ),
            child: Text(
              referee.initials,
              style: theme.textTheme.labelLarge?.copyWith(
                color: tone.foreground(theme.brightness),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  referee.name,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                // The address in the mono face: a candidate reading it back
                // to the registry gets the dots and dashes in the right place.
                Text(
                  referee.email,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  referee.role,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusTag(label: l10n.admissionsRefereeAwaiting, tone: tone),
                  AppSpacing.horizontalGap(AppSpacing.xs),
                  IconButton(
                    onPressed: onRemove,
                    tooltip: l10n.admissionsRefereeRemoveTooltip,
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints.tightFor(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                    ),
                    icon: Icon(
                      Icons.close,
                      size: AppDimensions.iconDense,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: onResend,
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.tertiary,
                  minimumSize: const Size(0, AppDimensions.buttonCompact),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                ),
                child: Text(l10n.admissionsRefereeResend),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
