import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Centered progress indicator, optionally with a label.
class LoadingView extends StatelessWidget {
  const LoadingView({
    this.message,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    super.key,
  });

  final String? message;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              Text(message!, style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
