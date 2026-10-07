import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/surface_card.dart';

/// Tappable card that leads from one housing screen to a tool or a record.
class HousingEntryCard extends StatelessWidget {
  const HousingEntryCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onOpen,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onOpen;

  /// A tag or figure shown before the chevron.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final trailing = this.trailing;

    return InkWell(
      onTap: onOpen,
      borderRadius: AppRadii.cardRadius,
      child: SurfaceCard(
        child: Row(
          children: [
            Container(
              width: AppDimensions.iconTile,
              height: AppDimensions.iconTile,
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
            if (trailing != null) ...[
              AppSpacing.horizontalGap(AppSpacing.sm),
              trailing,
            ],
            AppSpacing.horizontalGap(AppSpacing.sm),
            Icon(
              Icons.chevron_right,
              size: AppDimensions.iconDense,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
