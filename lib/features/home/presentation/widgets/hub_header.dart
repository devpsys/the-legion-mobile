import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Fixed top bar of the landing hub.
///
/// Pinned by the enclosing [Scaffold], so the content scrolls beneath it while
/// the term pill, the notification bell and the avatar stay reachable — the
/// behaviour the designs give their `position: fixed` header.
class HubHeader extends StatelessWidget implements PreferredSizeWidget {
  const HubHeader({
    required this.termLabel,
    required this.unreadCount,
    required this.avatar,
    required this.onNotifications,
    this.onMenu,
    this.onAvatarTap,
    super.key,
  });

  /// Compact term pill, e.g. `2025/2026 · 2nd Sem`.
  final String termLabel;

  /// Unread announcements, badged on the bell.
  final int unreadCount;

  final Widget avatar;

  /// Overrides the leading button's action. When omitted, the button opens the
  /// drawer of the enclosing [Scaffold].
  final VoidCallback? onMenu;

  final VoidCallback onNotifications;

  /// Optional: opens the profile tab.
  final VoidCallback? onAvatarTap;

  /// Height of the bar itself; the [Scaffold] adds the status bar inset.
  static const double barHeight = 56;

  @override
  Size get preferredSize => const Size.fromHeight(barHeight);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return AppBar(
      toolbarHeight: preferredSize.height,
      elevation: 0,
      scrolledUnderElevation: 0,
      // Slightly translucent so scrolling content is felt behind the bar. The
      // designs add a backdrop blur; that is left to the platform's own window
      // compositing rather than a per-frame filter on low-end devices.
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.94),
      surfaceTintColor: Colors.transparent,
      shape: Border(
        bottom: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      // The Builder re-roots the context below the AppBar so `Scaffold.of`
      // finds *this* screen's scaffold rather than an ancestor's.
      leading: Builder(
        builder: (innerContext) => IconButton(
          onPressed: onMenu ?? () => Scaffold.of(innerContext).openDrawer(),
          tooltip: l10n.homeMenuTooltip,
          icon: const Icon(Icons.menu),
        ),
      ),
      // The title is dropped on phones so the term pill and the bell keep
      // their space, matching the `hidden sm:block` rule of the designs.
      title: context.isCompact
          ? null
          : Text(l10n.homeHubTitle, style: theme.textTheme.headlineSmall),
      centerTitle: false,
      titleSpacing: AppSpacing.sm,
      actions: [
        TermPill(label: termLabel),
        AppSpacing.horizontalGap(AppSpacing.sm),
        NotificationBell(
          count: unreadCount,
          tooltip: l10n.homeNotificationsTooltip,
          onPressed: onNotifications,
        ),
        AppSpacing.horizontalGap(AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: avatar,
        ),
      ],
    );
  }
}

/// Compact term indicator — e.g. `2025/2026 · 2nd Sem`.
class TermPill extends StatelessWidget {
  const TermPill({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      // Capped rather than flexible: an `AppBar` lays its actions out from the
      // right, and a `Flexible` there collapses the whole action row onto the
      // leading button. The pill bounds itself instead and ellipsizes.
      constraints: const BoxConstraints(
        maxWidth: AppDimensions.termPillMaxWidth,
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
            size: 15,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Notification bell with an unread badge.
class NotificationBell extends StatelessWidget {
  const NotificationBell({
    required this.count,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final int count;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final badgeLabel = count > 9 ? '9+' : '$count';

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(badgeLabel),
        backgroundColor: theme.colorScheme.error,
        textColor: theme.colorScheme.onError,
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}
