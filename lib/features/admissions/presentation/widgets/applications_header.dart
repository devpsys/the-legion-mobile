import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The Applications tab's title.
///
/// It stands alone: the action that starts an application is the floating
/// button on the page, so this only has to name the screen. Kept as its own
/// widget because the title's typography — the same 22/28 headline the
/// browser's header uses — is a decision worth not repeating inline.
class ApplicationsHeader extends StatelessWidget {
  const ApplicationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Text(
      context.l10n.admissionsApplicationsTitle,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}
