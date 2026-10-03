import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// The last thing on the screen: withdrawing the application.
///
/// Outside every card, under a rule of its own — the design keeps it apart
/// because it does the opposite of everything above it. Outlined in the danger
/// tone rather than filled: this is not the action the screen wants the
/// candidate to take, and a solid red button at the end of a long scroll is
/// one careless thumb away from being pressed.
class ApplicationWithdrawAction extends StatelessWidget {
  const ApplicationWithdrawAction({required this.onWithdraw, super.key});

  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: AppSpacing.xs),
        AppSpacing.verticalGap(AppSpacing.xl),
        OutlinedButton.icon(
          onPressed: onWithdraw,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.dangerText(theme.brightness),
            minimumSize: const Size(0, AppDimensions.buttonHeight),
          ),
          icon: const Icon(Icons.block, size: AppDimensions.iconDense),
          label: Text(l10n.admissionsWithdrawAction),
        ),
      ],
    );
  }
}
