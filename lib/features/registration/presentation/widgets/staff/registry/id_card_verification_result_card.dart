import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/utils/dates.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../../../../core/widgets/labelled_value_row.dart';
import '../../../../../../core/widgets/surface_card.dart';
import '../../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../../models/staff/registry_models.dart';

/// Answer to a public ID card check.
///
/// A valid card shows five facts and nothing else; every other outcome shows
/// a notice and no student data.
class IdCardVerificationResultCard extends StatelessWidget {
  const IdCardVerificationResultCard({required this.result, super.key});

  final IdCardVerificationResult result;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return switch (result.outcome) {
      IdCardVerificationOutcome.idle => const SizedBox.shrink(),
      IdCardVerificationOutcome.invalid => ToneCallout(
        tone: AppTone.danger,
        icon: Icons.gpp_bad_outlined,
        title: l10n.verifyIdCardInvalidTitle,
        body: l10n.verifyIdCardInvalidBody,
      ),
      IdCardVerificationOutcome.notFound => ToneCallout(
        tone: AppTone.warning,
        icon: Icons.search_off_outlined,
        title: l10n.verifyIdCardNotFoundTitle,
        body: l10n.verifyIdCardNotFoundBody,
      ),
      IdCardVerificationOutcome.valid => SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.verified_user,
                  size: AppDimensions.iconMedium,
                  color: AppTone.success.foreground(theme.brightness),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.verifyIdCardValidTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTone.success.foreground(theme.brightness),
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            LabelledValueRow(
              label: l10n.verifyIdCardFieldName,
              value: result.name,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            LabelledValueRow(
              label: l10n.verifyIdCardFieldMatric,
              value: result.matricNumber,
              isCode: true,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            LabelledValueRow(
              label: l10n.verifyIdCardFieldProgramme,
              value: result.programme,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            LabelledValueRow(
              label: l10n.verifyIdCardFieldSerial,
              value: result.cardSerial,
              isCode: true,
            ),
            if (result.expiresOn != null) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              LabelledValueRow(
                label: l10n.verifyIdCardFieldExpires,
                value: AppDateFormats.long(
                  l10n.localeName,
                ).format(result.expiresOn!),
                isCode: true,
              ),
            ],
          ],
        ),
      ),
    };
  }
}
