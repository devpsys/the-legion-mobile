import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/examinations_models.dart';

/// One paper on the card's timetable: when, where and which seat.
class CardPaperTile extends StatelessWidget {
  const CardPaperTile({required this.paper, super.key});

  final CardPaper paper;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final venue = paper.venue;
    final seat = paper.seat;
    final when = l10n.examCardPaperWhen(
      AppDateFormats.short(locale).format(paper.startsAt),
      AppDateFormats.time(locale).format(paper.startsAt),
    );

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                paper.courseCode,
                style: AppTextStyles.codeMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Expanded(
                child: Text(
                  paper.title,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!paper.isAnnounced)
                StatusTag(
                  label: l10n.examCardVenueToBeAnnounced,
                  tone: AppTone.warning,
                ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: AppDimensions.iconSmall,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Text(when, style: AppTextStyles.codeSmall),
            ],
          ),
          if (venue != null) ...[
            AppSpacing.verticalGap(AppSpacing.xs),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: AppDimensions.iconSmall,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                AppSpacing.horizontalGap(AppSpacing.xs),
                Expanded(child: Text(venue, style: muted)),
                if (seat != null)
                  Text(
                    l10n.examCardSeat(seat),
                    style: AppTextStyles.codeSmall.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
