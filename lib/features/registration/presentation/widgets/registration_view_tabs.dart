import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

/// Which panel the tabbed-ledger body is showing.
enum RegistrationViewTab {
  /// Courses ledger + week timetable.
  selected,

  /// Departmental catalogue.
  catalogue,
}

/// Segmented control: Selected & Timetable | Catalogue & Add.
class RegistrationViewTabs extends StatelessWidget {
  const RegistrationViewTabs({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final RegistrationViewTab selected;
  final ValueChanged<RegistrationViewTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              icon: Icons.list_alt_outlined,
              label: l10n.registrationTabSelected,
              selected: selected == RegistrationViewTab.selected,
              onTap: () => onChanged(RegistrationViewTab.selected),
            ),
          ),
          Expanded(
            child: _TabButton(
              icon: Icons.library_add_outlined,
              label: l10n.registrationTabCatalogue,
              selected: selected == RegistrationViewTab.catalogue,
              onTap: () => onChanged(RegistrationViewTab.catalogue),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Material(
      color: selected
          ? theme.colorScheme.surfaceContainerHigh
          : theme.colorScheme.surface.withValues(alpha: 0),
      borderRadius: AppRadii.elementRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.elementRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppDimensions.iconSmall,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: selected
                        ? AppTextStyles.semiBold
                        : AppTextStyles.medium,
                    color: selected
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
