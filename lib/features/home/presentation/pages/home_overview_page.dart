import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/section_card.dart';

/// Landing page of the authenticated area.
///
/// Deliberately data-free: it surfaces the active environment configuration so
/// a developer can verify that `--dart-define` values reached the build.
class HomeOverviewPage extends StatelessWidget {
  const HomeOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = sl<AppConfig>();
    final theme = context.theme;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.homeTitle)),
      body: SingleChildScrollView(
        child: ResponsiveContent(
          maxWidth: AppDimensions.maxContentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NoticeBox(
                icon: Icons.architecture_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.homeFoundationTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      context.l10n.homeFoundationBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              SectionCard(
                icon: Icons.tune,
                title: AppConstants.appName,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
