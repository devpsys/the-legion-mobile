import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';

/// Static footer for the sign-in screen: language switcher and attribution.
class AuthFooter extends StatelessWidget {
  const AuthFooter({required this.language, super.key});

  /// Currently selected language label.
  final String language;

  /// Languages offered by the switcher.
  static const List<String> languages = ['English', 'Français'];

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: AppRadii.chipRadius,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in languages)
                  _LanguageOption(
                    label: option,
                    isSelected: option == language,
                  ),
              ],
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            context.l10n.loginCopyright,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.surface : Colors.transparent,
        borderRadius: AppRadii.chipRadius,
      ),
      child: Text(
        label,
        style: isSelected
            ? theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              )
            : theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
      ),
    );
  }
}
