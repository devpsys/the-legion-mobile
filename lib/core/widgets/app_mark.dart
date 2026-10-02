import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';

/// Branded product mark used on the splash screen and in the navigation rail.
///
/// Replace the icon with a brand asset later without touching call sites.
class AppMark extends StatelessWidget {
  const AppMark({this.size = 72, super.key});

  /// Sizes above this threshold also render the wordmark.
  static const double labelThreshold = 56;

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadii.card),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.shield_outlined,
            size: size / 2,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        // The label only makes sense in the large splash presentation.
        if (size >= labelThreshold) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          Text(context.l10n.appTitle, style: theme.textTheme.titleLarge),
        ],
      ],
    );
  }
}
