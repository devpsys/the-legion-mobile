import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';

/// A rounded card with a status stripe down its left edge.
///
/// Three of the portal's cards want the same thing — a tone-coloured edge, a
/// hairline elsewhere — and Flutter rejects a non-uniform `Border` on a box
/// that also has a `borderRadius`. Drawing the stripe as a bar inside a clipped
/// card is the way to have both, and doing it once means the accent width and
/// the corner radius cannot drift between cards.
class StripedCard extends StatelessWidget {
  const StripedCard({
    required this.tone,
    required this.child,
    this.onTap,
    this.padding = AppSpacing.card,
    this.isRaised = false,
    super.key,
  });

  /// Colour of the left stripe.
  final AppTone tone;

  final Widget child;
  final VoidCallback? onTap;

  final EdgeInsetsGeometry padding;

  /// Fills the card with the raised surface instead of the plain one.
  final bool isRaised;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Material(
      color: isRaised
          ? theme.colorScheme.surfaceContainerHigh
          : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.rowRadius,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: AppDimensions.accentStripe,
                color: tone.accent(theme.brightness),
              ),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}
