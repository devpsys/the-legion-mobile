import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_radii.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/utils/dates.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../../../../core/widgets/brand_block.dart';
import '../../../../../../core/widgets/verification_qr_mark.dart';
import '../../../models/staff/registry_models.dart';
import '../../../widgets/registration_card.dart';

/// The face of a student ID card as it will be printed.
class IdCardPreviewCard extends StatelessWidget {
  const IdCardPreviewCard({required this.preview, super.key});

  final IdCardPrintPreview preview;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final dateFormat = AppDateFormats.medium(l10n.localeName);
    final code = preview.verificationCode;
    final expiresOn = preview.expiresOn;

    return RegistrationCard(
      clip: false,
      padding: AppSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BrandBlock(caption: l10n.staffRegistryPreviewCardCaption),
          AppSpacing.verticalGap(AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppDimensions.avatarLarge * 1.5,
                height: AppDimensions.avatarLarge * 1.8,
                decoration: BoxDecoration(
                  color: preview.hasPhoto
                      ? theme.colorScheme.surfaceContainerHigh
                      : AppTone.warning.surface(theme.brightness),
                  borderRadius: AppRadii.elementRadius,
                  border: Border.all(
                    color: preview.hasPhoto
                        ? theme.colorScheme.outlineVariant
                        : AppTone.warning.border(theme.brightness),
                  ),
                ),
                child: Icon(
                  preview.hasPhoto
                      ? Icons.person_outline
                      : Icons.no_photography_outlined,
                  size: AppDimensions.iconLarge,
                  color: preview.hasPhoto
                      ? theme.colorScheme.onSurfaceVariant
                      : AppTone.warning.foreground(theme.brightness),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preview.studentName,
                      style: theme.textTheme.titleMedium,
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      preview.matricNumber,
                      style: AppTextStyles.codeMedium.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.sm),
                    Text(preview.programme, style: theme.textTheme.bodySmall),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      preview.department,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          AppSpacing.verticalGap(AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preview.serial,
                      style: AppTextStyles.codeSmall.copyWith(
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      expiresOn == null
                          ? l10n.staffRegistryPreviewNoExpiry
                          : l10n.staffRegistryPreviewExpires(
                              dateFormat.format(expiresOn),
                            ),
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (code != null) VerificationQrMark(code: code),
            ],
          ),
        ],
      ),
    );
  }
}
