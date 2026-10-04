import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/notification_bell.dart';

/// Top bar of the fees tab: a way back to the hub, the institution's name,
/// and the shared bell.
///
/// The name sits where a screen title would, in spaced capitals, because the
/// screen names itself in the header below — the bar says whose bursary this
/// is, the way the design prints it.
class FeesTopBar extends StatelessWidget implements PreferredSizeWidget {
  const FeesTopBar({
    required this.onBack,
    required this.onNotifications,
    super.key,
  });

  /// Leads back to the hub.
  final VoidCallback onBack;

  final VoidCallback onNotifications;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: AppColors.transparent,
      shape: Border(
        bottom: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: onBack,
        tooltip: l10n.feesBackTooltip,
        icon: const Icon(Icons.arrow_back),
      ),
      centerTitle: true,
      title: Text(
        l10n.feesInstitution.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: AppTextStyles.trackingCapsWide,
        ),
      ),
      actions: [
        // The shared bell: one notification centre for every signed-in screen.
        NotificationBell(onPressed: onNotifications),
      ],
    );
  }
}
