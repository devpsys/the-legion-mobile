import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_radii.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/utils/dates.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../../../../core/widgets/status_tag.dart';
import '../../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../../models/registration_models.dart';
import '../../../models/staff/approvals_models.dart';
import '../../../widgets/registration_labels.dart';
import '../staff_reason_field.dart';

/// One student petition in the HoD decision queue.
class RequestDecisionCard extends StatelessWidget {
  const RequestDecisionCard({
    required this.item,
    required this.onApprove,
    required this.onReject,
    required this.onReasonChanged,
    super.key,
  });

  final RequestDecisionItem item;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final ValueChanged<String> onReasonChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final dateFormat = AppDateFormats.medium(l10n.localeName);
    final rejected = item.status == AcademicRequestStatus.rejected;

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
                  RegistrationLabels.academicRequestType(l10n, item.type),
                  style: AppTextStyles.codeMedium.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              StatusTag(
                label: RegistrationLabels.academicRequestStatus(
                  l10n,
                  item.status,
                ),
                tone: item.status.tone,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            item.studentName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.staffApprovalsQueueMeta(
              item.matricNumber,
              item.programmeCode,
              l10n.registrationLevel(item.level),
            ),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            item.summary,
            style: theme.textTheme.bodySmall?.copyWith(
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.requestsFiledOn(dateFormat.format(item.filedOn)),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (item.studentNote.isNotEmpty) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: AppRadii.elementRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.staffApprovalsStudentNote.toUpperCase(),
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: AppTextStyles.trackingCaps,
                    ),
                  ),
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    item.studentNote,
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: AppTextStyles.relaxedLineHeight,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (item.isPending) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            ToneCallout(
              tone: AppTone.info,
              icon: Icons.info_outline,
              body: item.effectNote,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            StaffReasonField(
              label: l10n.staffApprovalsRequestReasonLabel,
              hint: l10n.staffApprovalsRequestReasonHint,
              initialValue: item.rejectDraft,
              onChanged: onReasonChanged,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        AppDimensions.buttonHeight,
                      ),
                      foregroundColor: theme.colorScheme.error,
                    ),
                    child: Text(l10n.staffApprovalsRequestReject),
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: onApprove,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        AppDimensions.buttonHeight,
                      ),
                    ),
                    child: Text(l10n.staffApprovalsRequestApprove),
                  ),
                ),
              ],
            ),
          ] else if (rejected && item.decisionNote.isNotEmpty) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            ToneCallout(
              tone: AppTone.danger,
              icon: Icons.error_outline,
              body: l10n.requestsDecisionNote(item.decisionNote),
            ),
          ],
        ],
      ),
    );
  }
}
