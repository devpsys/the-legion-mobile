import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/responsive.dart';

/// Compact staff app bar for Registration staff / registry screens.
class StaffRegistrationTaskBar extends StatelessWidget
    implements PreferredSizeWidget {
  const StaffRegistrationTaskBar({
    required this.title,
    required this.subtitle,
    this.onBack,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: AppColors.transparent,
      leading: onBack == null
          ? null
          : IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Page header used on staff Registration screens.
class StaffPageHeader extends StatelessWidget {
  const StaffPageHeader({
    required this.breadcrumb,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final List<String> breadcrumb;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (var i = 0; i < breadcrumb.length; i++) ...[
              if (i > 0) ...[
                AppSpacing.horizontalGap(AppSpacing.xs),
                Icon(
                  Icons.chevron_right,
                  size: AppDimensions.iconMicro,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                AppSpacing.horizontalGap(AppSpacing.xs),
              ],
              Text(
                breadcrumb[i],
                style: AppTextStyles.codeSmall.copyWith(
                  color: i == breadcrumb.length - 1
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Text(title, style: theme.textTheme.headlineMedium),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: AppTextStyles.relaxedLineHeight,
          ),
        ),
      ],
    );
  }
}
