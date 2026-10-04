import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../models/admissions_models.dart';
import '../models/application_detail_models.dart';
import 'status_tag.dart';

/// The register's answer when a code is genuine: what the letter prints, and
/// nothing the letter does not.
///
/// No email, no phone, no address, no scores. The person reading this is not
/// the candidate, and the page's whole promise — stated under it — is that it
/// shows only what is already on the paper in their hand.
class VerificationResultCard extends StatelessWidget {
  const VerificationResultCard({required this.result, super.key});

  final AdmissionVerificationResult result;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final brightness = theme.brightness;
    final success = AppTone.success.foreground(brightness);
    final border = AppColors.successBorder(brightness);
    final matricNumber = result.matricNumber;

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppTone.success.surface(brightness),
        borderRadius: AppRadii.rowRadius,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: border,
                  width: AppDimensions.hairline,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: AppDimensions.iconHero,
                  color: success,
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Text(
                  l10n.admissionsVerifyGenuine,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: success,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          // Who and what are the two facts a reader checks against the
          // person in front of them, so they carry the heavier weight; the
          // terms under them are read, not matched.
          VerificationFactRow(
            label: l10n.admissionsVerifyName,
            value: result.candidateName,
            isEmphasised: true,
          ),
          VerificationFactRow(
            label: l10n.admissionsVerifyProgramme,
            value: result.programmeName,
            detail: result.department,
            isEmphasised: true,
          ),
          VerificationFactRow(
            label: l10n.admissionsVerifyLevel,
            value: l10n.admissionsOfferLevelValue(result.level),
          ),
          VerificationFactRow(
            label: l10n.admissionsVerifySession,
            value: result.session,
          ),
          VerificationFactRow(
            label: l10n.admissionsVerifyStatus,
            trailing: StatusTag(
              label: applicationStatusLabel(l10n, result.status),
              tone: result.status.tone,
            ),
          ),
          if (matricNumber != null)
            VerificationFactRow(
              label: l10n.admissionsVerifyMatricNumber,
              value: matricNumber,
              isCode: true,
            ),
          VerificationFactRow(
            label: l10n.admissionsVerifyIssuedOn,
            value: AppDateFormats.long(l10n.localeName).format(result.issuedOn),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

/// One fact the register confirms: label left, value right, a hairline under
/// every row but the last.
class VerificationFactRow extends StatelessWidget {
  const VerificationFactRow({
    required this.label,
    this.value,
    this.detail,
    this.trailing,
    this.isCode = false,
    this.isEmphasised = false,
    this.isLast = false,
    super.key,
  }) : assert(
         value != null || trailing != null,
         'A fact row needs a value or a trailing widget.',
       );

  final String label;

  /// The fact in words; `null` when [trailing] draws it instead.
  final String? value;

  /// A second line under the value — the department under a programme.
  final String? detail;

  /// Draws the fact in place of [value] — a status pill.
  final Widget? trailing;

  /// Sets [value] in the mono face, for a matric number.
  final bool isCode;

  /// Sets [value] bold rather than semibold — for the facts a reader matches
  /// against the person holding the letter, not the terms beneath them.
  final bool isEmphasised;

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final value = this.value;
    final detail = this.detail;
    final weight = isEmphasised ? AppTextStyles.bold : AppTextStyles.semiBold;
    final valueStyle = isCode
        ? AppTextStyles.codeMedium.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: weight,
          )
        : theme.textTheme.bodyLarge?.copyWith(fontWeight: weight);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.successBorder(theme.brightness),
                  width: AppDimensions.hairline,
                ),
              ),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (trailing != null)
                  trailing!
                else if (value != null)
                  Text(value, textAlign: TextAlign.end, style: valueStyle),
                if (detail != null) ...[
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    detail,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The register's answer when a code matches nothing.
///
/// Says what to do about it — check the code, try again — before saying what
/// it means, because a mistyped character is the likelier story.
class VerificationNotFoundCard extends StatelessWidget {
  const VerificationNotFoundCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final brightness = theme.brightness;
    final danger = AppTone.danger.foreground(brightness);

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppTone.danger.surface(brightness),
        borderRadius: AppRadii.rowRadius,
        border: Border.all(color: AppColors.dangerBorder(brightness)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            size: AppDimensions.iconHero,
            color: danger,
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.admissionsVerifyNotFoundTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: danger,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.admissionsVerifyNotFoundBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: AppTextStyles.relaxedLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
