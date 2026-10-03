import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/hub_models.dart';
import 'hub_card.dart';

/// "Everything else" — the portal directory grouped by theme.
///
/// Grouping keeps thirteen destinations scannable: a student looking for the
/// clinic should not have to read twelve rows to find it.
class ModuleDirectory extends StatelessWidget {
  const ModuleDirectory({required this.clusters, this.onModuleTap, super.key});

  final List<ModuleCluster> clusters;

  /// Invoked with the chosen portal. Null leaves the rows inert.
  final void Function(PortalModule module)? onModuleTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HubSectionHeading(
          title: context.l10n.homeEverythingElse,
          isUppercase: false,
          trailing: Text(
            context.l10n.homeModuleCount(ModuleCluster.countOf(clusters)),
            style: context.textStyles.bodySmall,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        for (final cluster in clusters)
          Padding(
            padding: EdgeInsets.only(
              bottom: cluster == clusters.last ? 0 : AppSpacing.md,
            ),
            child: ClusterCard(cluster: cluster, onModuleTap: onModuleTap),
          ),
      ],
    );
  }
}

/// One themed group of portals.
class ClusterCard extends StatelessWidget {
  const ClusterCard({required this.cluster, this.onModuleTap, super.key});

  final ModuleCluster cluster;
  final void Function(PortalModule module)? onModuleTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm + 2,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    cluster.label.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: AppTextStyles.trackingCaps,
                    ),
                  ),
                ),
                Text(
                  context.l10n.homeModuleRows(cluster.modules.length),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          for (var index = 0; index < cluster.modules.length; index++)
            ModuleRow(
              module: cluster.modules[index],
              // Hairline separators rather than spacing, as in the designs.
              showDivider: index > 0,
              onTap: onModuleTap == null
                  ? null
                  : () => onModuleTap!(cluster.modules[index]),
            ),
        ],
      ),
    );
  }
}

/// A single portal row: icon tile, label and chevron on a 56px target.
class ModuleRow extends StatelessWidget {
  const ModuleRow({
    required this.module,
    required this.showDivider,
    this.onTap,
    super.key,
  });

  final PortalModule module;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    const rowHeight = AppDimensions.rowHeight;

    return Column(
      children: [
        if (showDivider)
          Divider(
            height: AppDimensions.hairline,
            color: theme.colorScheme.outlineVariant,
          ),
        Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: rowHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: AppDimensions.iconTileSmall,
                      height: AppDimensions.iconTileSmall,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHigh,
                        borderRadius: AppRadii.elementRadius,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        module.icon,
                        size: AppDimensions.iconMedium,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.lg),
                    Expanded(
                      child: Text(
                        module.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: AppDimensions.iconMedium,
                      color: theme.colorScheme.outline,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
