import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/recovery_widgets.dart';

/// Protocol badge and registry reference from the design's card header.
///
/// A [Wrap] rather than a [Row] so the reference drops onto its own line on
/// narrow phones instead of overflowing.
class ReferenceRow extends StatelessWidget {
  const ReferenceRow({
    required this.protocol,
    required this.reference,
    super.key,
  });

  final String protocol;
  final String reference;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        RecoveryStatusChip(label: protocol, icon: Icons.verified_user_outlined),
        Text(
          reference,
          style: context.textStyles.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
