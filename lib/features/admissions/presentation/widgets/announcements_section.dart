import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/admissions_models.dart';
import 'section_surface.dart';
import 'striped_card.dart';

/// The candidate's announcement board.
class AnnouncementsSection extends StatelessWidget {
  const AnnouncementsSection({
    required this.bulletins,
    this.onSeeAll,
    this.onBulletinTap,
    super.key,
  });

  final List<Bulletin> bulletins;
  final VoidCallback? onSeeAll;
  final void Function(Bulletin bulletin)? onBulletinTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
            title: l10n.admissionsAnnouncements,
            action: onSeeAll == null
                ? null
                : TextButton(
                    onPressed: onSeeAll,
                    style: TextButton.styleFrom(
                      foregroundColor: context.colors.tertiary,
                      minimumSize: const Size(0, AppDimensions.buttonCompact),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                    ),
                    child: Text(l10n.admissionsSeeAll),
                  ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          for (var index = 0; index < bulletins.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == bulletins.length - 1 ? 0 : AppSpacing.md,
              ),
              child: BulletinCard(
                bulletin: bulletins[index],
                onTap: onBulletinTap == null
                    ? null
                    : () => onBulletinTap!(bulletins[index]),
              ),
            ),
        ],
      ),
    );
  }
}

/// One bulletin: category stripe, headline, summary and a read-more action.
class BulletinCard extends StatelessWidget {
  const BulletinCard({required this.bulletin, this.onTap, super.key});

  final Bulletin bulletin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return StripedCard(
      tone: bulletin.category.tone,
      isRaised: true,
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  bulletin.title,
                  style: theme.textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Text(bulletin.publishedLabel, style: theme.textTheme.bodySmall),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            bulletin.body,
            style: theme.textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: onTap,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.tertiary,
                minimumSize: const Size(0, AppDimensions.buttonCompact),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                textStyle: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
              icon: const Icon(
                Icons.arrow_forward,
                size: AppDimensions.iconSmall,
              ),
              label: Text(l10n.admissionsReadMore),
            ),
          ),
        ],
      ),
    );
  }
}
