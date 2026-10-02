import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/hub_models.dart';
import 'hub_tone_colors.dart';

/// Section wrapper of the hub: a hairline-stroked card on the canvas.
///
/// Elevation comes from the 1px perimeter stroke rather than a drop shadow,
/// which is how the rest of the design system separates surfaces.
class HubCard extends StatelessWidget {
  const HubCard({
    required this.child,
    this.padding = AppSpacing.card,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}

/// Section heading: a label on the left, a count or action on the right — the
/// pattern the designs repeat above every section of the hub.
class HubSectionHeading extends StatelessWidget {
  const HubSectionHeading({
    required this.title,
    this.subtitle,
    this.trailing,
    this.icon,
    this.isUppercase = true,
    super.key,
  });

  final String title;

  /// Muted qualifier rendered after the title, e.g. "Sequential Priority Flow".
  final String? subtitle;

  /// Count pill or "See all" action.
  final Widget? trailing;

  /// Optional leading glyph, as on the announcement board.
  final IconData? icon;

  /// Designs set section labels in spaced capitals.
  final bool isUppercase;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      letterSpacing: 1.2,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: AppDimensions.iconMedium,
            color: theme.colorScheme.primary,
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
        ],
        Expanded(
          // A Wrap rather than a Row so the qualifier drops to a second line
          // on narrow phones and with longer translations.
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.xs,
            children: [
              Text(
                isUppercase ? title.toUpperCase() : title,
                style: labelStyle,
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: labelStyle?.copyWith(
                    fontWeight: AppTextStyles.regular,
                  ),
                ),
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

/// Small status pill — the coloured tag that closes a timeline step.
class HubTag extends StatelessWidget {
  const HubTag({
    required this.label,
    required this.tone,
    this.isMono = false,
    super.key,
  });

  final String label;
  final HubTone tone;

  /// Uses the mono face, for reference codes rather than words.
  final bool isMono;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final brightness = theme.brightness;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tone.surface(brightness),
        borderRadius: AppRadii.chipRadius,
      ),
      child: Text(
        label,
        style: isMono
            ? AppTextStyles.codeSmall.copyWith(
                color: tone.foreground(brightness),
              )
            : theme.textTheme.labelSmall?.copyWith(
                color: tone.foreground(brightness),
              ),
      ),
    );
  }
}

/// Circular count pill — the dark badge on a section heading.
class HubCountPill extends StatelessWidget {
  const HubCountPill({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: AppRadii.chipRadius,
      ),
      child: Text(
        '$count',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
