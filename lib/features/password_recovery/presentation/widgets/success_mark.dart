import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Success glyph: filled circle on a tinted ring.
class SuccessMark extends StatelessWidget {
  const SuccessMark({super.key});

  @override
  Widget build(BuildContext context) {
    final success = AppColors.successText(context.colors.brightness);
    final surface = AppColors.successSurface(context.colors.brightness);

    return Center(
      child: Container(
        width: AppDimensions.statusMark,
        height: AppDimensions.statusMark,
        decoration: BoxDecoration(color: surface, shape: BoxShape.circle),
        child: Container(
          margin: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: success.withValues(alpha: 0.35),
              width: AppDimensions.hairline * 2,
            ),
          ),
          child: Icon(
            Icons.check,
            size: AppDimensions.iconDisplay,
            color: success,
          ),
        ),
      ),
    );
  }
}
