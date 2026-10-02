import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Rule with a caption, used to separate the credential deck from the
/// secondary institutional access options.
class LabelledDivider extends StatelessWidget {
  const LabelledDivider({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
      ],
    );
  }
}

/// Secondary access action shown under the sign-in card.
class SecondaryActionTile extends StatelessWidget {
  const SecondaryActionTile({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isAccent = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  /// Renders the icon in the accent colour instead of the brand navy.
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final iconColor = isAccent
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: AppRadii.elementRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.elementRadius,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadii.elementRadius,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: AppDimensions.iconSmall, color: iconColor),
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Two-up deck of secondary institutional access routes.
class SecondaryActionDeck extends StatelessWidget {
  const SecondaryActionDeck({
    required this.createAccountLabel,
    required this.verifyLetterLabel,
    required this.onCreateAccount,
    required this.onVerifyLetter,
    super.key,
  });

  final String createAccountLabel;
  final String verifyLetterLabel;
  final VoidCallback onCreateAccount;
  final VoidCallback onVerifyLetter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelledDivider(label: context.l10n.loginOrDivider),
        AppSpacing.verticalGap(AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final gap = context.screenSize.isCompactOrMedium
                ? AppSpacing.sm
                : AppSpacing.md;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SecondaryActionTile(
                    icon: Icons.person_add_alt,
                    label: createAccountLabel,
                    onPressed: onCreateAccount,
                  ),
                ),
                AppSpacing.horizontalGap(gap),
                Expanded(
                  child: SecondaryActionTile(
                    icon: Icons.verified_outlined,
                    label: verifyLetterLabel,
                    isAccent: true,
                    onPressed: onVerifyLetter,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
