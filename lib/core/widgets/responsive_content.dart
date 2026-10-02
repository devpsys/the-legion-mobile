import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../utils/responsive.dart';

/// Constrains its child to a readable width and centers it.
///
/// This is how the app stays usable on tablets and wide web windows without
/// creating separate layouts.
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    this.maxWidth = AppDimensions.maxContentWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    this.center = false,
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  /// Vertically centers the child inside the available space.
  final bool center;

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(padding: padding, child: child),
    );

    if (!center) {
      return Align(alignment: Alignment.topCenter, child: content);
    }

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        child: content,
      ),
    );
  }
}
