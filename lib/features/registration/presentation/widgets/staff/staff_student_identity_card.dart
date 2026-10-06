import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/responsive.dart';
import '../registration_card.dart';

/// Identity strip of the student a staff screen is about.
class StaffStudentIdentityCard extends StatelessWidget {
  const StaffStudentIdentityCard({
    required this.name,
    required this.matricNumber,
    required this.programme,
    this.level,
    this.trailing,
    super.key,
  });

  final String name;
  final String matricNumber;

  /// Omitted where the source has no level (the study-plan dossier).
  final int? level;
  final String programme;

  /// A status tag or similar, aligned to the end of the card.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final trailing = this.trailing;

    return RegistrationCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      clip: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimensions.avatarSmall,
            height: AppDimensions.avatarSmall,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: AppRadii.elementRadius,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Icon(
              Icons.person_outline,
              size: AppDimensions.iconDense,
              color: theme.colorScheme.primary,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.codeMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  level == null
                      ? matricNumber
                      : l10n.registrationMatricLevel(
                          l10n.registrationLevel(level!),
                          matricNumber,
                        ),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  programme,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            AppSpacing.horizontalGap(AppSpacing.sm),
            trailing,
          ],
        ],
      ),
    );
  }
}
