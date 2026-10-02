import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_spacing.dart';
import '../utils/responsive.dart';

/// Constrains its child to a readable width and centers it.
///
/// This is how the app stays usable on tablets and wide web windows without
/// creating separate layouts. The horizontal canvas gutter follows the design
/// spec: 16px on mobile, 24px from the tablet breakpoint upwards.
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    this.maxWidth = AppDimensions.maxContentWidth,
    this.padding,
    this.center = false,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  /// Defaults to the responsive canvas gutter.
  final EdgeInsetsGeometry? padding;

  /// Vertically centers the child inside the available space.
  final bool center;

  /// Horizontal canvas gutter: 16px on mobile, 24px from tablet upwards.
  EdgeInsets _gutter(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.isCompact ? AppSpacing.canvasGutter : AppSpacing.xl,
  );

  @override
  Widget build(BuildContext context) {
    final gutter = _gutter(context);
    final content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(padding: padding ?? gutter, child: child),
    );

    if (!center) {
      return Align(alignment: Alignment.topCenter, child: content);
    }

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: gutter.horizontal,
          vertical: AppSpacing.xl,
        ),
        child: content,
      ),
    );
  }
}
