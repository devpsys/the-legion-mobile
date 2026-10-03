import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Institutional brand header banner.
///
/// Reproduces the navy banner from the design: crest tile, wordmark, SSO
/// badge and the one-sign-in subtitle, all docked to the top edge.
class AuthHeaderBanner extends StatelessWidget {
  const AuthHeaderBanner({this.crest, super.key});

  /// Optional crest widget; the app mark is used when omitted.
  final Widget? crest;

  static const double _tileSize = 44;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final onPrimary = AppColors.cardLight;

    return ColoredBox(
      color: theme.colorScheme.primaryContainer,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.navyPressed)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxFormWidth,
            ),
            child: Row(
              children: [
                Container(
                  width: _tileSize,
                  height: _tileSize,
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: AppRadii.elementRadius,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: crest ?? const DefaultCrest(),
                ),
                AppSpacing.horizontalGap(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              context.l10n.appTitle,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: onPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          AppSpacing.horizontalGap(AppSpacing.sm),
                          SsoBadge(label: context.l10n.loginSsoBadge),
                        ],
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        context.l10n.loginHeaderSubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: onPrimary.withValues(alpha: 0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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

/// Translucent SSO badge, set in the mono style from the design.
class SsoBadge extends StatelessWidget {
  const SsoBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardLight.withValues(alpha: 0.15),
        borderRadius: AppRadii.chipRadius,
        border: Border.all(color: AppColors.cardLight.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.brandTintSurfaceLight,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// Placeholder crest glyph; replace with the university crest asset.
class DefaultCrest extends StatelessWidget {
  const DefaultCrest({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.shield_outlined,
      color: context.colors.primary,
      size: AppDimensions.iconLarge - 8,
    );
  }
}
