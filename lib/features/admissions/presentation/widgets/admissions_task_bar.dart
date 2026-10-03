import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_mark.dart';
import '../../../../core/widgets/notification_bell.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/widgets/user_avatar.dart';

/// Fixed top bar of the candidate portal.
///
/// A cycle chip rather than the hub's term pill: an applicant is choosing
/// between cycles, not counting down a term.
class AdmissionsTaskBar extends StatelessWidget implements PreferredSizeWidget {
  const AdmissionsTaskBar({
    required this.cycleLabel,
    required this.user,
    required this.onNotifications,
    required this.onAvatarTap,
    super.key,
  });

  /// Compact cycle label, e.g. `2026/2027 Cycle`.
  final String cycleLabel;

  /// The signed-in candidate, shown as the avatar. `null` while the session
  /// is being restored, in which case no avatar is drawn.
  final User? user;

  final VoidCallback onNotifications;

  /// Opens the candidate's profile.
  final VoidCallback onAvatarTap;

  @override
  Size get preferredSize => const Size.fromHeight(barHeight);

  /// Height of the bar itself; the [Scaffold] adds the status bar inset.
  static const double barHeight = 56;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return AppBar(
      toolbarHeight: barHeight,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.94),
      surfaceTintColor: AppColors.transparent,
      shape: Border(
        bottom: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      // The product mark rather than a back button: back is the system
      // gesture, and the portal's own tab bar is the navigation between its
      // sections. Decorative, so it is not a tap target.
      automaticallyImplyLeading: false,
      leading: const Center(child: AppMark(size: AppDimensions.avatarSmall)),
      centerTitle: true,
      title: CyclePill(label: cycleLabel),
      actions: [
        // The shared bell: the same count and the same sheet as the hub's,
        // because both read one notification centre.
        NotificationBell(onPressed: onNotifications),
        AppSpacing.horizontalGap(AppSpacing.xs),
        if (user case final user?)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Semantics(
              button: true,
              label: l10n.navProfile,
              child: InkResponse(
                onTap: onAvatarTap,
                customBorder: const CircleBorder(),
                child: ExcludeSemantics(
                  child: UserAvatar(
                    user: user,
                    size: AppDimensions.avatarSmall,
                  ),
                ),
              ),
            ),
          )
        else
          AppSpacing.horizontalGap(AppSpacing.sm),
      ],
    );
  }
}

/// Cycle indicator at the centre of the bar, e.g. `2026/2027 Cycle`.
class CyclePill extends StatelessWidget {
  const CyclePill({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      // Bounded rather than flexible: an `AppBar` lays its actions out from the
      // edges, and a `Flexible` there collapses the title onto the leading
      // button.
      constraints: const BoxConstraints(
        maxWidth: AppDimensions.cyclePillMaxWidth,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.chipRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: AppDimensions.iconSmall,
            color: theme.colorScheme.primary,
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
