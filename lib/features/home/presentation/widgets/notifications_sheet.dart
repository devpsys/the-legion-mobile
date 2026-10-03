import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../models/hub_models.dart';
import 'hub_tone_colors.dart';

/// Sheet behind the header bell: the unread bulletins, newest first.
///
/// Reuses the announcement fixtures so the bell and the board can never
/// disagree about what is unread.
class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({required this.announcements, super.key});

  final List<Announcement> announcements;

  /// Shows the sheet. Returns once it is dismissed.
  static Future<void> show(
    BuildContext context, {
    required List<Announcement> announcements,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: AppColors.transparent,
      builder: (context) => NotificationsSheet(announcements: announcements),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

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
                child: Text(
                  context.l10n.homeNotificationsTooltip,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  itemCount: announcements.length,
                  separatorBuilder: (context, index) =>
                      AppSpacing.verticalGap(AppSpacing.sm),
                  itemBuilder: (context, index) =>
                      NotificationRow(announcement: announcements[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One unread row: category dot, headline and timestamp.
class NotificationRow extends StatelessWidget {
  const NotificationRow({required this.announcement, super.key});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final tone = announcement.category.tone;
    final brightness = theme.brightness;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.elementRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimensions.indicator,
            height: AppDimensions.indicator,
            margin: const EdgeInsets.only(top: AppSpacing.md),
            decoration: BoxDecoration(
              color: tone.foreground(brightness),
              shape: BoxShape.circle,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  announcement.title,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  announcement.publishedLabel,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
