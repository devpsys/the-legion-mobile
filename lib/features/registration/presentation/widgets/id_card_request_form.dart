import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/registration_cubit.dart';
import '../models/registration_models.dart';
import 'id_card_active_section.dart';
import 'registration_card.dart';
import 'registration_chrome.dart';
import 'registration_labels.dart';

/// First-issue / replacement request form on the ID card screen.
class IdCardRequestForm extends StatelessWidget {
  const IdCardRequestForm({
    required this.record,
    required this.cubit,
    super.key,
  });

  final IdCardRecord record;
  final RegistrationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final lock = record.submitLock;
    final fieldStyle = AppTextStyles.codeSmall.copyWith(
      fontWeight: AppTextStyles.medium,
      color: theme.colorScheme.onSurface,
    );
    final hintStyle = AppTextStyles.codeSmall.copyWith(
      fontWeight: AppTextStyles.regular,
      color: theme.colorScheme.onSurfaceVariant,
    );
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: AppRadii.elementRadius),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );
    final reasons = record.isFirstIssue
        ? const [
            IdCardReason.firstCard,
            IdCardReason.lostOrStolen,
            IdCardReason.damaged,
            IdCardReason.nameOrProgrammeUpdate,
          ]
        : const [
            IdCardReason.lostOrStolen,
            IdCardReason.damaged,
            IdCardReason.nameOrProgrammeUpdate,
          ];

    return RegistrationCard(
      clip: false,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RegistrationFormHeader(
            title: record.isFirstIssue
                ? l10n.idCardRequestYourCard
                : l10n.idCardRequestReplacement,
            subtitle: record.isFirstIssue
                ? l10n.idCardFirstIssueFormSubtitle
                : l10n.idCardRequestFormSubtitle,
            icon: Icons.badge_outlined,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          ToneCallout(
            tone: record.photoApproved ? AppTone.info : AppTone.warning,
            icon: Icons.account_box_outlined,
            body: l10n.idCardPhotoHint,
          ),
          if (!record.photoApproved) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            OutlinedButton(
              onPressed: null,
              child: Text(l10n.idCardPhotoUpload),
            ),
          ],
          AppSpacing.verticalGap(AppSpacing.md),
          RegistrationFieldLabel(l10n.idCardReasonLabel),
          AppSpacing.verticalGap(AppSpacing.xs),
          DropdownButtonFormField<IdCardReason>(
            initialValue: record.draftReason,
            isExpanded: true,
            isDense: true,
            style: fieldStyle,
            iconSize: AppDimensions.iconSmall,
            decoration: inputDecoration,
            hint: Text(
              l10n.idCardReasonLabel,
              style: hintStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            items: [
              for (final reason in reasons)
                DropdownMenuItem(
                  value: reason,
                  child: Text(
                    RegistrationLabels.idCardReason(l10n, reason),
                    style: fieldStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
            selectedItemBuilder: (context) => [
              for (final reason in reasons)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    RegistrationLabels.idCardReason(l10n, reason),
                    style: fieldStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
            onChanged: lock == IdCardSubmitLock.activeRequest
                ? null
                : (value) => cubit.setIdCardDraftReason(value),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          if (record.isFirstIssue)
            IdCardDetailInset(
              icon: Icons.verified_outlined,
              tone: AppTone.success,
              body: l10n.idCardFeeFree,
            )
          else
            Text(
              RegistrationLabels.idCardFeeLine(
                l10n,
                record.replacementFeeMinorUnits,
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          AppSpacing.verticalGap(AppSpacing.lg),
          FilledButton(
            onPressed: record.canSubmitRequest
                ? () {
                    final sent = cubit.submitIdCardRequest();
                    if (sent) {
                      context.showMessage(l10n.idCardRequestedSnack);
                    }
                  }
                : null,
            child: Text(l10n.idCardRequestCard),
          ),
          if (lock != null) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              switch (lock) {
                IdCardSubmitLock.activeRequest =>
                  l10n.idCardRequestLockedActive,
                IdCardSubmitLock.photo => l10n.idCardRequestLockedPhoto,
                IdCardSubmitLock.reasonRequired =>
                  l10n.idCardRequestLockedReason,
              },
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTone.warning.foreground(theme.brightness),
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
