import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Title, result count and one-line purpose of the programme browser.
///
/// The count sits on the title's baseline rather than in the list, because
/// after a search it is the only place that says how much is on screen.
class ProgrammesHeader extends StatelessWidget {
  const ProgrammesHeader({required this.resultCount, super.key});

  /// Programmes matching the current search and faculty.
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  l10n.admissionsProgrammesTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Text(
                l10n.admissionsProgrammesAvailable(resultCount),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.admissionsProgrammesSubtitle,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
