import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../mock/password_recovery_fixtures.dart';

/// Stage indicator and session reference from the design's card header.
class StageRow extends StatelessWidget {
  const StageRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppDimensions.indicator,
          height: AppDimensions.indicator,
          decoration: BoxDecoration(
            color: context.colors.secondary,
            shape: BoxShape.circle,
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Expanded(
          child: Text(
            context.l10n.recoveryStage(2),
            style: context.textStyles.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
              letterSpacing: AppTextStyles.trackingCaps,
            ),
          ),
        ),
        Text(
          RecoveryFixtures.sessionReference,
          style: AppTextStyles.codeSmall.copyWith(
            color: context.colors.outline,
          ),
        ),
      ],
    );
  }
}
