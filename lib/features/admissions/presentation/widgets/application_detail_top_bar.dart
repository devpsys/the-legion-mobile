import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/notification_bell.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/widgets/user_avatar.dart';
import 'admissions_task_bar.dart';

/// Top bar of the application detail screen.
///
/// The same 56px bar the rest of the portal sits under, with the product mark
/// swapped for a back chevron: the candidate has left the sections behind and
/// opened one record, so the left edge has to say *where back goes* instead of
/// where they already are. The reference sits between the two because it is
/// the number a candidate quotes to the registry — never the screen's name.
class ApplicationDetailTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ApplicationDetailTopBar({
    required this.reference,
    required this.onBack,
    required this.user,
    required this.onNotifications,
    required this.onAvatarTap,
    super.key,
  });

  /// The record's tracking code, or `null` while it is still loading.
  final String? reference;

  /// Unwinds to the record this screen was opened from.
  final VoidCallback onBack;

  /// The signed-in candidate; `null` while the session is being restored.
  final User? user;

  final VoidCallback onNotifications;

  /// Opens the candidate's profile.
  final VoidCallback onAvatarTap;

  @override
  Size get preferredSize => const Size.fromHeight(AdmissionsTaskBar.barHeight);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return AppBar(
      toolbarHeight: AdmissionsTaskBar.barHeight,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.94),
      surfaceTintColor: AppColors.transparent,
      shape: Border(
        bottom: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: onBack,
        tooltip: l10n.admissionsDetailBackTooltip,
        icon: Icon(
          Icons.chevron_left,
          size: AppDimensions.iconMedium,
          color: theme.colorScheme.primary,
        ),
      ),
      centerTitle: true,
      title: ApplicationDetailTitle(reference: reference),
      actions: [
        // The shared bell: one notification centre for the hub and the portal.
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

/// Reference and screen name, stacked at the centre of the bar.
///
/// Deliberately not `Flexible`: an `AppBar` lays its actions out from the
/// edges, and a flexible title there collapses onto the leading button (the
/// same trap `CyclePill` is bounded to avoid). The column instead takes the
/// width the bar hands it and ellipsizes into it.
class ApplicationDetailTitle extends StatelessWidget {
  const ApplicationDetailTitle({required this.reference, super.key});

  /// `null` while the record loads, in which case the caption stands alone.
  final String? reference;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final reference = this.reference;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (reference != null) ...[
          Text(
            reference,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.codeMedium.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: AppTextStyles.bold,
              letterSpacing: AppTextStyles.trackingCaps,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
        ],
        Text(
          l10n.admissionsDetailCaption.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: AppTextStyles.trackingCapsWide,
          ),
        ),
      ],
    );
  }
}
