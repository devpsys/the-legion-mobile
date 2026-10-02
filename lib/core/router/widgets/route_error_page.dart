import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_spacing.dart';
import '../../utils/responsive.dart';
import '../../widgets/responsive_content.dart';
import '../route_names.dart';

/// Rendered when a URL does not match any route (e.g. a stale deep link).
class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({required this.location, super.key});

  final String location;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: Center(
        child: ResponsiveContent(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.explore_off_outlined,
                size: AppDimensions.iconLarge,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              Text(
                context.l10n.routeNotFoundTitle,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              Text(
                context.l10n.routeNotFoundBody,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                location,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppRadii.field,
                ),
                child: TextButton.icon(
                  onPressed: () => context.goNamed(Routes.homeName),
                  icon: const Icon(Icons.home_outlined),
                  label: Text(context.l10n.routeErrorBackHome),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
