import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../registration/presentation/widgets/registration_task_bar.dart';

/// Fixed top bar of the Accommodation hub and history: the term pill, the bell
/// and the student's avatar.
///
/// It is the portal's session bar, drawn the same way as Registration &
/// Records so moving between the two keeps the student's bearings.
class AccommodationTaskBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AccommodationTaskBar({
    required this.termLabel,
    required this.user,
    required this.onNotifications,
    required this.onAvatarTap,
    super.key,
  });

  /// The selected term, e.g. `2026/2027-1`.
  final String termLabel;
  final User? user;
  final VoidCallback onNotifications;
  final VoidCallback onAvatarTap;

  @override
  Size get preferredSize =>
      const Size.fromHeight(RegistrationTaskBar.barHeight);

  @override
  Widget build(BuildContext context) {
    return RegistrationTaskBar(
      sessionLabel: termLabel,
      user: user,
      onNotifications: onNotifications,
      onAvatarTap: onAvatarTap,
    );
  }
}

/// Compact bar with a back chevron for the task screens (terms, rooms).
class AccommodationBackBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AccommodationBackBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: AppColors.transparent,
      leading: IconButton(
        onPressed: onBack,
        tooltip: context.l10n.accommodationBackTooltip,
        icon: const Icon(Icons.arrow_back),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
