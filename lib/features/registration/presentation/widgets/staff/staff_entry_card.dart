import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/responsive.dart';
import '../registration_card.dart';

/// Tappable card that leads from one staff screen to a sibling queue.
class StaffEntryCard extends StatelessWidget {
  const StaffEntryCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onOpen,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return RegistrationCard(
      child: Material(
        color: theme.colorScheme.surface,
        child: InkWell(
          onTap: onOpen,
          child: Padding(
            padding: AppSpacing.card,
            child: Row(
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
                    icon,
                    color: theme.colorScheme.primary,
                    size: AppDimensions.iconDense,
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.codeMedium.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        body,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: AppTextStyles.relaxedLineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Icon(
                  Icons.chevron_right,
                  size: AppDimensions.iconDense,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
