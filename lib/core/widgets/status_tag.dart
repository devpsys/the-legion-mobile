import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_tone.dart';
import '../utils/responsive.dart';

/// Coloured pill carrying a status, a category or a verdict.
///
/// One widget for every feature, so "amber means the same thing" everywhere:
/// amber is actionable-but-not-yours (an offer, a part-paid invoice), red is
/// closed or owed, blue is in progress, green is done. Promoted to core
/// because the candidate portal and the bursary both render status, and a
/// second definition would let the two drift apart.
class StatusTag extends StatelessWidget {
  const StatusTag({
    required this.label,
    required this.tone,
    this.isUppercase = false,
    this.icon,
    super.key,
  });

  final String label;
  final AppTone tone;

  /// Spaced capitals, for tags that name a source or a programme rather than
  /// report a status. Statuses stay in sentence case.
  final bool isUppercase;

  /// A glyph before the label, for the one verdict a colour alone should not
  /// have to carry. Most tags go without.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final foreground = tone.foreground(theme.brightness);
    final icon = this.icon;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tone.surface(theme.brightness),
        borderRadius: AppRadii.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppDimensions.iconMicro, color: foreground),
            AppSpacing.horizontalGap(AppSpacing.xs),
          ],
          Text(
            isUppercase ? label.toUpperCase() : label,
            style: theme.textTheme.labelSmall?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
