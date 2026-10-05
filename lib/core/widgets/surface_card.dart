import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';

/// The plain card a screen's sections sit in: a hairline-stroked surface on
/// the canvas.
///
/// Elevation comes from the 1px perimeter stroke rather than a drop shadow,
/// which is how the design system separates surfaces. One widget, so the
/// border, radius and padding are decided once rather than per section.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    required this.child,
    this.padding = AppSpacing.card,
    this.borderRadius = AppRadii.cardRadius,
    super.key,
  });

  final Widget child;

  /// Interior padding. Sections use the card default; a card that is the
  /// whole screen's statement breathes more, with [AppSpacing.sheet].
  final EdgeInsetsGeometry padding;

  /// Corner radius. Defaults to [AppRadii.cardRadius]; features may pass a
  /// tighter radius (e.g. [AppRadii.blockRadius]) to match a specific layout.
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: borderRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}

/// A section title with an optional trailing action or count.
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.action, super.key});

  final String title;

  /// Trailing button or figure, aligned to the title.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (action != null) ...[
          AppSpacing.horizontalGap(AppSpacing.sm),
          action!,
        ],
      ],
    );
  }
}
