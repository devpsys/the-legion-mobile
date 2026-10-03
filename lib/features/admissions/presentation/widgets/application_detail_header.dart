import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../models/admissions_models.dart';
import 'status_tag.dart';

/// The block above the checklist: what this record is, how it is doing, and
/// when it stops being possible to act on.
///
/// Everything on it is a fact of the record rather than a control — the only
/// interactive surface the design gives this screen is the back chevron in the
/// bar above, so nothing here invites a tap it cannot honour.
class ApplicationDetailHeader extends StatelessWidget {
  const ApplicationDetailHeader({
    required this.application,
    this.submitBy,
    super.key,
  });

  final ApplicationSummary application;

  /// The earliest moment the candidate can no longer submit: the earlier of
  /// the cycle's close and the first choice's own deadline. `null` when the
  /// portal has not resolved one, in which case no deadline is quoted at all
  /// rather than a guess.
  final DateTime? submitBy;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final trackingCode = application.trackingCode;
    final submitBy = this.submitBy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                l10n.admissionsDetailTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trackingCode != null) ...[
              AppSpacing.horizontalGap(AppSpacing.sm),
              Flexible(child: ApplicationReferenceChip(code: trackingCode)),
            ],
            AppSpacing.horizontalGap(AppSpacing.sm),
            StatusTag(
              label: applicationStatusLabel(l10n, application.status),
              tone: application.status.tone,
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Text(
          application.cycleName,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (submitBy != null) ...[
          AppSpacing.verticalGap(AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: AppDimensions.iconSmall,
                color: AppTone.warning.foreground(theme.brightness),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Flexible(
                child: Text(
                  l10n.admissionsDetailSubmitBy(
                    DateFormat.yMMMd(l10n.localeName).format(submitBy),
                    DateFormat.Hm(l10n.localeName).format(submitBy),
                  ),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTone.warning.foreground(theme.brightness),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// The record's tracking code, quoted in a bordered chip.
///
/// Spaced capitals on a pill rather than plain mono: this is a reference a
/// candidate reads aloud over the phone, and the pill is the same treatment
/// the cycle chip gets in the bar above.
class ApplicationReferenceChip extends StatelessWidget {
  const ApplicationReferenceChip({required this.code, super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.chipRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        code,
        style: AppTextStyles.codeMedium.copyWith(
          fontWeight: AppTextStyles.bold,
          letterSpacing: AppTextStyles.trackingCaps,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
