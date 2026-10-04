import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/emphasised_text.dart';
import '../models/fees_models.dart';

/// Eyebrow, title and the student's byline at the top of the fees tab.
///
/// The byline sets the matriculation number in the mono face: it is the
/// identifier the bursary files everything under, and the one figure on the
/// line a student reads digit by digit.
class FeesHeader extends StatelessWidget {
  const FeesHeader({required this.student, super.key});

  final FeesStudent student;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.feesEyebrow.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: AppTextStyles.trackingCapsWide,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          l10n.feesTitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        EmphasisedText(
          l10n.feesStudentLine(
            l10n.feesLevel(student.level),
            student.matricNumber,
            student.name,
          ),
          emphasis: [student.matricNumber],
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          emphasisStyle: AppTextStyles.codeMedium.copyWith(
            color: AppColors.infoText(theme.brightness),
            fontWeight: AppTextStyles.semiBold,
          ),
        ),
      ],
    );
  }
}
