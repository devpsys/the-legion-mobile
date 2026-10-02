import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../bloc/auth_cubit.dart';

/// Cold start screen.
///
/// Triggers session restoration and waits for the router redirect, so no
/// protected content is rendered before authentication is known.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // The cubit comes from the service locator and lives above this page, so
    // emitting from initState is safe.
    context.read<AuthCubit>().bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ResponsiveContent(
          maxWidth: 320,
          center: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppMark(),
              AppSpacing.verticalGap(AppSpacing.lg),
              LoadingView(message: context.l10n.sessionRestoring),
            ],
          ),
        ),
      ),
    );
  }
}

/// Product mark shown while the app boots. Replace with a brand asset later.
class AppMark extends StatelessWidget {
  const AppMark({this.size = 72, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadii.xl),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.shield_outlined,
            size: size / 2,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        Text(context.l10n.appTitle, style: theme.textTheme.titleLarge),
      ],
    );
  }
}
