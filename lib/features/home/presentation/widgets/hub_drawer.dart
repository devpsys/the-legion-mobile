import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/widgets/user_avatar.dart';
import '../models/hub_models.dart';

/// Slide-out menu behind the header's menu button.
///
/// It carries the whole portal directory in one scroll — the grouped section is
/// designed for scanning, and the drawer is for searching by eye — plus the
/// build diagnostics in debug builds.
class HubDrawer extends StatelessWidget {
  const HubDrawer({
    required this.user,
    required this.clusters,
    this.onModuleTap,
    super.key,
  });

  final User user;
  final List<ModuleCluster> clusters;
  final void Function(PortalModule module)? onModuleTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          children: [
            Row(
              children: [
                UserAvatar(user: user, size: AppDimensions.monogramSize),
                AppSpacing.horizontalGap(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.email,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.xl),
            for (final cluster in clusters) ...[
              Text(
                cluster.label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: AppTextStyles.trackingCaps,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              for (final module in cluster.modules)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  leading: Icon(
                    module.icon,
                    size: AppDimensions.iconMedium,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  title: Text(module.label, style: theme.textTheme.bodyMedium),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: AppDimensions.iconDense,
                    color: theme.colorScheme.outline,
                  ),
                  onTap: onModuleTap == null
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          onModuleTap!(module);
                        },
                ),
              AppSpacing.verticalGap(AppSpacing.lg),
            ],
            // The hub replaced the old "foundation is ready" card that printed
            // the active configuration, so it lives here in debug builds only.
            if (kDebugMode) const BuildDiagnostics(),
          ],
        ),
      ),
    );
  }
}

/// `--dart-define` values of the running build.
class BuildDiagnostics extends StatelessWidget {
  const BuildDiagnostics({super.key});

  @override
  Widget build(BuildContext context) {
    final config = sl<AppConfig>();

    return SectionCard(
      icon: Icons.tune,
      title: context.l10n.homeDiagnosticsTitle,
      child: Column(
        children: [
          ValueChip(
            label: context.l10n.homeEnvironmentLabel,
            value: config.environment.name,
          ),
          ValueChip(
            label: context.l10n.homeApiBaseUrlLabel,
            value: config.apiBaseUrl,
          ),
          ValueChip(
            label: context.l10n.homeNetworkLoggingLabel,
            value: config.enableNetworkLogging.toString(),
          ),
          ValueChip(
            label: context.l10n.homeViewportLabel,
            value:
                '${context.screenSize.name} '
                '(${context.viewport.width.toStringAsFixed(0)}px)',
          ),
        ],
      ),
    );
  }
}
