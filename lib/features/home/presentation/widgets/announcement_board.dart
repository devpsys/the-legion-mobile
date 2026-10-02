import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../models/hub_models.dart';
import 'hub_card.dart';
import 'hub_tone_colors.dart';

/// Announcement board: what the institution is telling the student right now.
///
/// Category drives the accent, so an urgent bulletin is recognisable before a
/// word of it is read.
class AnnouncementBoard extends StatelessWidget {
  const AnnouncementBoard({
    required this.announcements,
    this.onSeeAll,
    this.onAnnouncementTap,
    super.key,
  });

  final List<Announcement> announcements;

  final VoidCallback? onSeeAll;
  final void Function(Announcement announcement)? onAnnouncementTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HubSectionHeading(
          title: context.l10n.homeAnnouncements,
          isUppercase: false,
          icon: Icons.campaign_outlined,
          trailing: onSeeAll == null
              ? null
              : TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, AppDimensions.minTapTarget),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                  ),
                  child: Text(context.l10n.homeSeeAll),
                ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        for (var index = 0; index < announcements.length; index++)
          Padding(
            padding: EdgeInsets.only(
              bottom: index == announcements.length - 1 ? 0 : AppSpacing.md,
            ),
            child: AnnouncementCard(
              announcement: announcements[index],
              onTap: onAnnouncementTap == null
                  ? null
                  : () => onAnnouncementTap!(announcements[index]),
            ),
          ),
      ],
    );
  }
}

/// One bulletin: category tag, timestamp, headline and summary.
class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({required this.announcement, this.onTap, super.key});

  final Announcement announcement;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final tone = announcement.category.tone;
    final brightness = theme.brightness;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: AppRadii.rowRadius,
      // The category stripe is painted as a bar: Flutter rejects a
      // non-uniform border on a rounded box.
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: _accentWidth,
                color: tone.accent(brightness),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                _accentWidth + AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      HubTag(label: _categoryLabel(context), tone: tone),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      Expanded(
                        child: Text(
                          announcement.publishedLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalGap(AppSpacing.sm),
                  Text(
                    announcement.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    announcement.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  AppSpacing.verticalGap(AppSpacing.sm),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton.icon(
                      onPressed: onTap,
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, AppDimensions.minTapTarget),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                        ),
                        foregroundColor: theme.colorScheme.tertiary,
                      ),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: Text(context.l10n.homeReadMore),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Width of a bulletin's category stripe.
  static const double _accentWidth = 5;

  String _categoryLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (announcement.category) {
      AnnouncementCategory.urgent => l10n.homeCategoryUrgent,
      AnnouncementCategory.notice => l10n.homeCategoryNotice,
      AnnouncementCategory.information => l10n.homeCategoryInformation,
    };
  }
}
