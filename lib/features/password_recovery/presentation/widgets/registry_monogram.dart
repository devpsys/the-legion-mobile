import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

/// Registry monogram from the success design's task bar.
class RegistryMonogram extends StatelessWidget {
  const RegistryMonogram({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.iconTileSmall,
      height: AppDimensions.iconTileSmall,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: AppRadii.elementRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        context.l10n.recoveryRegistryMonogram,
        style: context.textStyles.labelSmall?.copyWith(
          color: context.colors.onPrimary,
          letterSpacing: AppTextStyles.trackingCapsWide,
        ),
      ),
    );
  }
}
