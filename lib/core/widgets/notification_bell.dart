import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../extensions/context_extensions.dart';
import '../notifications/notification_cubit.dart';
import '../notifications/notification_entry.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tone.dart';
import '../utils/responsive.dart';

/// Bell that badges the unread count, shared by every signed-in screen.
///
/// Reading the count from the ambient [NotificationCubit] rather than a
/// parameter is deliberate: two bells given the same number by hand will
/// disagree the first time one of them is rebuilt.
class NotificationBell extends StatelessWidget {
  const NotificationBell({
    required this.onPressed,
    this.tooltip,
    this.showCount = true,
    super.key,
  });

  final VoidCallback onPressed;

  /// Defaults to the app's notification string.
  final String? tooltip;

  /// `false` for a bare dot — for a screen whose badges live elsewhere.
  final bool showCount;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final count = context.select<NotificationCubit, int>(
      (cubit) => cubit.state.unreadCount,
    );
    // Nine is the point at which an exact number stops being useful.
    final label = count > 9 ? '9+' : '$count';

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip ?? context.l10n.homeNotificationsTooltip,
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(showCount ? label : ''),
        // A bare dot: no padding, and an empty label collapses to the dot.
        padding: showCount ? null : EdgeInsets.zero,
        backgroundColor: theme.colorScheme.error,
        textColor: theme.colorScheme.onError,
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}

/// Opens [NotificationsSheet].
///
/// One function rather than a class method so both bells call the same code.
Future<void> showNotificationsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<NotificationCubit>(),
      child: const NotificationsSheet(),
    ),
  );
}

/// Sheet listing the session's unread notifications.
///
/// Reads the same [NotificationCubit] as every bell, so the count in the sheet
/// header always matches the badge that opened it.
class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final centre = context.watch<NotificationCubit>().state;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.sizeOf(context).height *
              AppDimensions.sheetMaxHeightFactor,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadii.topSheet,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Center(
                child: Container(
                  width: AppDimensions.sheetHandleWidth,
                  height: AppDimensions.sheetHandleHeight,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: AppRadii.chipRadius,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.homeNotificationsTooltip,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    if (centre.unreadCount > 0)
                      Text(
                        l10n.homeUnreadCount(centre.unreadCount),
                        style: AppTextStyles.codeSmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (centre.unreadEntries.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.xxl,
                  ),
                  child: Text(
                    l10n.homeNoNotifications,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.xl,
                    ),
                    itemCount: centre.unreadEntries.length,
                    separatorBuilder: (context, index) =>
                        AppSpacing.verticalGap(AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final entry = centre.unreadEntries[index];
                      return NotificationRow(
                        entry: entry,
                        onTap: () => context.read<NotificationCubit>().markRead(
                          entry.id,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One unread row: tone dot, headline and timestamp.
class NotificationRow extends StatelessWidget {
  const NotificationRow({required this.entry, this.onTap, super.key});

  final NotificationEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final tone = entry.category.tone;

    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      borderRadius: AppRadii.elementRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.elementRadius,
        child: Padding(
          padding: AppSpacing.card,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppDimensions.indicator,
                height: AppDimensions.indicator,
                margin: const EdgeInsets.only(top: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: tone.foreground(theme.brightness),
                  shape: BoxShape.circle,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(entry.title, style: theme.textTheme.bodyMedium),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      entry.publishedLabel,
                      style: theme.textTheme.bodySmall,
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
