import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// One choice in a group on the checkout: a radio, a title with an optional
/// tag, a line of detail, and whatever the choice brings with it.
///
/// Shared by the amount and the method groups so a selected option looks the
/// same in both: the accent border says "this one" once, not twice. The
/// whole tile is the target, not just the radio, and the radio reports to
/// the `RadioGroup` above it so the two cannot disagree.
class CheckoutOptionTile<T> extends StatelessWidget {
  const CheckoutOptionTile({
    required this.value,
    required this.isSelected,
    required this.title,
    required this.onTap,
    this.detail,
    this.tag,
    this.trailing,
    this.extra,
    super.key,
  });

  /// The option's value in its `RadioGroup`.
  final T value;

  final bool isSelected;

  final String title;

  /// A line under the title, e.g. when the payment clears.
  final String? detail;

  /// A pill beside the title, e.g. "Instant".
  final Widget? tag;

  /// What sits at the tile's right edge: a figure, or a chevron.
  final Widget? trailing;

  /// Content under the detail that belongs to the option — chips naming the
  /// cards a gateway takes, the reference a bank branch needs.
  final Widget? extra;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final detail = this.detail;
    final tag = this.tag;
    final trailing = this.trailing;
    final extra = this.extra;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.elementRadius,
        child: AnimatedContainer(
          duration: kThemeChangeDuration,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.surfaceContainerHigh
                : theme.colorScheme.surface,
            borderRadius: AppRadii.elementRadius,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shrunk to its glyph: the tile is the target, so the
                  // radio's own 48px halo would only push the title down.
                  Radio<T>(
                    value: value,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.xs,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: AppTextStyles.semiBold,
                              ),
                            ),
                            ?tag,
                          ],
                        ),
                        if (detail != null) ...[
                          AppSpacing.verticalGap(AppSpacing.xs),
                          Text(
                            detail,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    trailing,
                  ],
                ],
              ),
              if (extra != null) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                extra,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
