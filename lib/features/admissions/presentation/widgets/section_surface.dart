import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';

// The header now lives in core, where the bursary shares it; exported from
// here so the portal's sections keep one import for the surface and its title.
export '../../../../core/widgets/surface_card.dart' show SectionHeader;

/// The plain card the portal's sections sit in.
///
/// One widget for the whole feature, so the border, radius and padding are
/// decided once rather than per section.
class HubSectionSurface extends StatelessWidget {
  const HubSectionSurface({
    required this.child,
    this.padding = AppSpacing.card,
    super.key,
  });

  final Widget child;

  /// Interior padding. Sections use the card default; a card that is the
  /// whole screen's statement — a closed state, a matriculation — breathes
  /// more, with [AppSpacing.sheet].
  final EdgeInsets padding;

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
