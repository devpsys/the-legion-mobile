import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

/// Declaration checkbox + submit action that scrolls with the page content.
class RegistrationSubmitBar extends StatelessWidget {
  const RegistrationSubmitBar({
    required this.accepted,
    required this.canSubmit,
    required this.onChanged,
    required this.onSubmit,
    super.key,
  });

  final bool accepted;
  final bool canSubmit;
  final ValueChanged<bool> onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => onChanged(!accepted),
              borderRadius: AppRadii.elementRadius,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: AppDimensions.checkboxSize,
                    height: AppDimensions.checkboxSize,
                    child: Checkbox(
                      value: accepted,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      onChanged: (value) => onChanged(value ?? false),
                    ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.registrationDeclaration,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: AppTextStyles.relaxedLineHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            FilledButton.icon(
              onPressed: canSubmit ? onSubmit : null,
              icon: const Icon(Icons.assignment_turned_in_outlined),
              label: Text(l10n.registrationSubmitForm),
            ),
          ],
        ),
      ),
    );
  }
}
