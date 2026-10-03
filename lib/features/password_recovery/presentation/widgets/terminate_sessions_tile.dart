import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Opt-in to revoking every other session when the password changes.

class TerminateSessionsTile extends StatelessWidget {
  const TerminateSessionsTile({
    required this.value,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppDimensions.checkboxSize,
            child: Checkbox(
              value: value,
              onChanged: enabled ? (v) => onChanged(v ?? false) : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Text(
              context.l10n.recoveryTerminateSessions,
              style: context.textStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
