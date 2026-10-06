import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import 'registration_card.dart';

/// Uppercase ledger section label with an optional count chip — matches
/// "Your Courses" / Study Plan section chrome.
class RegistrationSectionHeader extends StatelessWidget {
  const RegistrationSectionHeader({
    required this.title,
    this.countLabel,
    this.trailing,
    super.key,
  });

  final String title;
  final String? countLabel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final countLabel = this.countLabel;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title.toUpperCase(),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: AppTextStyles.trackingCaps,
                    fontWeight: AppTextStyles.semiBold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (countLabel != null) ...[
                AppSpacing.horizontalGap(AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: AppRadii.tagRadius,
                  ),
                  child: Text(
                    countLabel,
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          AppSpacing.horizontalGap(AppSpacing.sm),
          trailing!,
        ],
      ],
    );
  }
}

/// Banded form card header: icon + uppercase title + subtitle under a rule.
class RegistrationFormHeader extends StatelessWidget {
  const RegistrationFormHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: AppDimensions.iconDense,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Flexible(
                  child: Text(
                    title.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: AppTextStyles.bold,
                      letterSpacing: AppTextStyles.trackingCaps,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Muted "How this works" / about footer used across registration tabs.
class RegistrationAboutCard extends StatelessWidget {
  const RegistrationAboutCard({
    required this.title,
    required this.body,
    super.key,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return RegistrationCard(
      clip: false,
      color: theme.colorScheme.surfaceContainerHigh,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: AppDimensions.iconDense,
                    color: theme.colorScheme.primary,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Flexible(
                    child: Text(
                      title.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: AppTextStyles.bold,
                        letterSpacing: AppTextStyles.trackingCaps,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            body,
            style: theme.textTheme.bodySmall?.copyWith(
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dense code-styled label used above registration form fields.
class RegistrationFieldLabel extends StatelessWidget {
  const RegistrationFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.codeSmall.copyWith(
        fontWeight: AppTextStyles.semiBold,
      ),
    );
  }
}
