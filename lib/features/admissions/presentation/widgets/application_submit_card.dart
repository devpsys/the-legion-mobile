import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../models/application_detail_models.dart';
import 'section_surface.dart';

/// "Submit" — the declaration, the button, and the reason it is still off.
///
/// The button is disabled for as long as the checklist has a known gap, and
/// the sentence under it says which and how many: a disabled control with no
/// explanation is the single most common way a form makes a candidate give up
/// and telephone the registry instead.
class ApplicationSubmitCard extends StatelessWidget {
  const ApplicationSubmitCard({
    required this.detail,
    required this.isDeclarationAccepted,
    required this.onDeclarationChanged,
    required this.onSubmit,
    super.key,
  });

  final ApplicationDetail detail;

  final bool isDeclarationAccepted;

  final ValueChanged<bool> onDeclarationChanged;

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final isChecklistComplete = detail.isChecklistComplete;
    final canSubmit = isChecklistComplete && isDeclarationAccepted;

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(title: l10n.admissionsSubmitTitle),
          AppSpacing.verticalGap(AppSpacing.lg),
          // The whole line is the target, not just the 20px box: a candidate
          // taps the words they are agreeing to.
          InkWell(
            onTap: () => onDeclarationChanged(!isDeclarationAccepted),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: AppDimensions.checkboxSize,
                    child: Checkbox(
                      value: isDeclarationAccepted,
                      onChanged: (value) =>
                          onDeclarationChanged(value ?? false),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.md),
                  Expanded(
                    // `bodyMedium` already carries the design system's leading.
                    child: Text(
                      l10n.admissionsSubmitDeclaration,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          FilledButton(
            onPressed: canSubmit ? onSubmit : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, AppDimensions.buttonHeight),
            ),
            child: Text(l10n.admissionsSubmitAction),
          ),
          if (!canSubmit) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              isChecklistComplete
                  ? l10n.admissionsSubmitNeedsDeclaration
                  : l10n.admissionsSubmitBlocked(detail.outstandingCount),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
