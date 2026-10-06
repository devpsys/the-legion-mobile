import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/emphasised_text.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/registration_models.dart';
import 'registration_labels.dart';

/// One academic petition row inside the Requests ledger card.
class AcademicRequestCard extends StatelessWidget {
  const AcademicRequestCard({
    required this.request,
    required this.onWithdraw,
    super.key,
  });

  final AcademicRequest request;
  final VoidCallback? onWithdraw;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final dateFormat = AppDateFormats.medium(l10n.localeName);
    final note = request.decisionNote;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  request.title,
                  style: AppTextStyles.codeMedium.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              StatusTag(
                label: RegistrationLabels.academicRequestStatus(
                  l10n,
                  request.status,
                ),
                tone: request.status.tone,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          EmphasisedText(
            request.summary,
            emphasis: request.emphasis,
            style: theme.textTheme.bodySmall!.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: AppTextStyles.relaxedLineHeight,
            ),
            emphasisStyle: theme.textTheme.bodySmall!.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: AppTextStyles.semiBold,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.requestsFiledOn(dateFormat.format(request.filedOn)),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (note != null && note.isNotEmpty) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppTone.danger
                    .surface(theme.brightness)
                    .withValues(alpha: 0.7),
                borderRadius: AppRadii.elementRadius,
                border: Border.all(
                  color: AppTone.danger
                      .foreground(theme.brightness)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: AppDimensions.iconDense,
                    color: AppTone.danger.foreground(theme.brightness),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.requestsDecisionNote(note),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTone.danger.foreground(theme.brightness),
                        height: AppTextStyles.relaxedLineHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (onWithdraw != null) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: AppRadii.elementRadius,
                child: InkWell(
                  onTap: onWithdraw,
                  borderRadius: AppRadii.elementRadius,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      l10n.requestsWithdraw,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.dangerText(theme.brightness),
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
