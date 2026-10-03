import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/password_policy.dart';

/// Live checklist of the institutional password requirements.
class PasswordRequirementsList extends StatelessWidget {
  const PasswordRequirementsList({
    required this.requirements,
    this.reference,
    super.key,
  });

  final List<PasswordRequirement> requirements;

  /// Policy code shown in the header (`POL-SEC-v4.2`).
  final String? reference;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final met = requirements.where((requirement) => requirement.isMet).length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: AppDimensions.iconSmall,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  context.l10n.recoveryPolicyRequirement,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              if (reference != null)
                Text(
                  reference!,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          for (final requirement in requirements)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: RequirementRow(requirement: requirement),
            ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            '${context.l10n.recoveryPolicyCompliant} ($met/${requirements.length})',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class RequirementRow extends StatelessWidget {
  const RequirementRow({required this.requirement, super.key});

  final PasswordRequirement requirement;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isMet = requirement.isMet;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          size: AppDimensions.iconSmall,
          color: isMet
              ? AppColors.successText(theme.brightness)
              : theme.colorScheme.outline,
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Expanded(
          child: Text(
            switch (requirement.id) {
              PasswordRequirementId.length =>
                context.l10n.recoveryRequirementLength,
              PasswordRequirementId.uppercase =>
                context.l10n.recoveryRequirementUppercase,
              PasswordRequirementId.number =>
                context.l10n.recoveryRequirementNumber,
              PasswordRequirementId.special =>
                context.l10n.recoveryRequirementSpecial,
            },
            style: theme.textTheme.bodySmall?.copyWith(
              color: isMet
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
