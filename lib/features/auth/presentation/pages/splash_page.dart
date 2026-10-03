import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_mark.dart';
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
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
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
          maxWidth: AppDimensions.chromeMaxWidth,
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
