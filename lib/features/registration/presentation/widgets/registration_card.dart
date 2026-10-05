import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';

/// Rounded surface card that keeps its hairline border visible over clipped
/// children (headers, footers, full-bleed fills).
///
/// [Container] paints [decoration] behind the child and clips to the outer
/// radius, so an opaque child covers the border at the corners. The border is
/// therefore drawn with [foregroundDecoration] on top of the content.
class RegistrationCard extends StatelessWidget {
  const RegistrationCard({
    required this.child,
    this.padding,
    this.color,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = AppRadii.blockRadius,
    this.clip = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;

  /// When false, content is not clipped (use for simple cards without
  /// full-bleed sections).
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final outline = borderColor ?? theme.colorScheme.outlineVariant;
    final fill = color ?? theme.colorScheme.surface;

    return Container(
      width: double.infinity,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      padding: padding,
      decoration: BoxDecoration(color: fill, borderRadius: borderRadius),
      foregroundDecoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: outline, width: borderWidth),
      ),
      child: child,
    );
  }
}

/// Same border-on-top treatment for [SurfaceCard]-style padded sections.
class RegistrationPaddedCard extends StatelessWidget {
  const RegistrationPaddedCard({
    required this.child,
    this.padding = AppSpacing.card,
    this.borderRadius = AppRadii.blockRadius,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return RegistrationCard(
      borderRadius: borderRadius,
      clip: false,
      padding: padding,
      child: child,
    );
  }
}
