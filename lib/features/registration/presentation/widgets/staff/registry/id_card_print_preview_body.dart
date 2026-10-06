import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../../../../core/widgets/labelled_value_row.dart';
import '../../../../../../core/widgets/responsive_content.dart';
import '../../../../../../core/widgets/status_tag.dart';
import '../../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../../models/registration_models.dart';
import '../../../models/staff/registry_models.dart';
import '../../../widgets/registration_card.dart';
import '../../../widgets/registration_labels.dart';
import '../staff_chrome.dart';
import 'id_card_preview_card.dart';

/// Scrollable body of the ID card print preview.
class IdCardPrintPreviewBody extends StatelessWidget {
  const IdCardPrintPreviewBody({
    required this.preview,
    required this.canMarkPrinted,
    required this.onMarkPrinted,
    required this.onVerify,
    super.key,
  });

  final IdCardPrintPreview preview;
  final bool canMarkPrinted;
  final VoidCallback onMarkPrinted;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final code = preview.verificationCode;

    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            AppSpacing.md,
            0,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StaffPageHeader(
                breadcrumb: [
                  l10n.staffRegistryBreadcrumbRoot,
                  l10n.staffRegistryIdCardsBreadcrumb,
                  preview.serial,
                ],
                title: l10n.staffRegistryPreviewTitle,
                subtitle: l10n.staffRegistryPreviewSubtitle,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              IdCardPreviewCard(preview: preview),
              AppSpacing.verticalGap(AppSpacing.md),
              RegistrationCard(
                clip: false,
                padding: AppSpacing.card,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.staffRegistryPreviewStatus,
                            style: context.theme.textTheme.bodyMedium?.copyWith(
                              color: context.theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        StatusTag(
                          label: RegistrationLabels.idCardStatus(
                            l10n,
                            preview.status,
                          ),
                          tone: preview.status.tone,
                        ),
                      ],
                    ),
                    if (code != null) ...[
                      AppSpacing.verticalGap(AppSpacing.md),
                      LabelledValueRow(
                        label: l10n.staffRegistryPreviewCode,
                        value: code,
                        isCode: true,
                      ),
                    ],
                  ],
                ),
              ),
              if (!preview.hasPhoto) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                ToneCallout(
                  tone: AppTone.warning,
                  icon: Icons.no_photography_outlined,
                  title: l10n.staffRegistryPreviewNoPhotoTitle,
                  body: l10n.staffRegistryBlockedNoPhoto,
                ),
              ],
              if (preview.status == IdCardStatus.requested && !canMarkPrinted) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                ToneCallout(
                  tone: AppTone.warning,
                  icon: Icons.lock_outline,
                  body: l10n.staffRegistryPreviewBlocked,
                ),
              ],
              AppSpacing.verticalGap(AppSpacing.lg),
              if (preview.status == IdCardStatus.requested)
                FilledButton.icon(
                  onPressed: canMarkPrinted ? onMarkPrinted : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      AppDimensions.primaryActionHeight,
                    ),
                  ),
                  icon: const Icon(
                    Icons.print_outlined,
                    size: AppDimensions.iconDense,
                  ),
                  label: Text(l10n.staffRegistryMarkPrinted),
                ),
              if (preview.isPrinted && code != null)
                OutlinedButton.icon(
                  onPressed: onVerify,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      AppDimensions.primaryActionHeight,
                    ),
                  ),
                  icon: const Icon(
                    Icons.verified_user_outlined,
                    size: AppDimensions.iconDense,
                  ),
                  label: Text(l10n.staffRegistryPreviewVerify),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
