import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../utils/responsive.dart';

/// Titled card used as the standard content block across the app.
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.title,
    required this.child,
    this.icon,
    super.key,
  });

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Card(
      child: Padding(
        padding: AppSpacing.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppDimensions.iconSmall),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                ],
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}

/// Label/value row for configuration or detail lists.
class ValueChip extends StatelessWidget {
  const ValueChip({required this.label, required this.value, super.key});

  final String label;
  final String value;

  static const double _labelWidth = 148;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isCompact = context.isCompact;

    final labelWidget = Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );

    final valueWidget = SelectableText(value, style: theme.textTheme.bodySmall);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelWidget,
                const SizedBox(height: AppSpacing.xxs),
                valueWidget,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: _labelWidth, child: labelWidget),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(child: valueWidget),
              ],
            ),
    );
  }
}

/// Inline notice box used for informational messages.
class NoticeBox extends StatelessWidget {
  const NoticeBox({required this.child, this.icon, super.key});

  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            AppSpacing.horizontalGap(AppSpacing.sm),
          ],
          Expanded(child: child),
        ],
      ),
    );
  }
}
