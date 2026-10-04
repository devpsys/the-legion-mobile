import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/fees_models.dart';

/// Who is paying, as the bursary has them on record.
///
/// Read-only on purpose: the receipt is made out to the record, not to what
/// a student types at a checkout, so there is nothing here to edit.
class PayerVerificationCard extends StatelessWidget {
  const PayerVerificationCard({required this.student, super.key});

  final FeesStudent student;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final info = AppColors.infoText(theme.brightness);

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.feesPayerVerification.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: AppTextStyles.trackingCapsWide,
                  ),
                ),
              ),
              Icon(
                Icons.badge_outlined,
                size: AppDimensions.iconSmall,
                color: info,
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Text(
                l10n.feesVerifiedRecord,
                style: theme.textTheme.labelSmall?.copyWith(color: info),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          LabelledValueRow(label: l10n.feesStudentName, value: student.name),
          AppSpacing.verticalGap(AppSpacing.md),
          LabelledValueRow(
            label: l10n.feesMatricNumber,
            value: student.matricNumber,
            isCode: true,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          LabelledValueRow(
            label: l10n.feesDepartment,
            value: l10n.feesDepartmentValue(
              student.department,
              l10n.feesLevel(student.level),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          LabelledValueRow(
            label: l10n.feesEmail,
            value: student.email,
            isCode: true,
          ),
        ],
      ),
    );
  }
}
