import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../models/application_detail_models.dart';
import 'section_surface.dart';

/// "History" — everything the record has recorded, newest first.
///
/// A rail rather than a list because order is the content: a candidate reads
/// this log to find out *when* something happened, and a dot on a line says
/// "after this, before that" faster than two dates ever will. The rail is
/// drawn per row so it never runs past the last event — a log that appears to
/// continue implies there is more of it.
class ApplicationHistoryCard extends StatelessWidget {
  const ApplicationHistoryCard({required this.events, super.key});

  final List<ApplicationHistoryEvent> events;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(title: l10n.admissionsHistoryTitle),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.admissionsHistorySubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          for (final (index, event) in events.indexed)
            ApplicationHistoryRow(
              event: event,
              isLast: index == events.length - 1,
            ),
        ],
      ),
    );
  }
}

/// One event: dot, date, what happened, and the note where there is one.
class ApplicationHistoryRow extends StatelessWidget {
  const ApplicationHistoryRow({
    required this.event,
    required this.isLast,
    super.key,
  });

  final ApplicationHistoryEvent event;

  /// The rail stops at the last event, so a log never looks longer than it is.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final tone = event.kind.tone;
    final dotColor = tone.foreground(theme.brightness);
    final dateFormatter = DateFormat.MMMd(l10n.localeName);

    // The rail is painted rather than laid out. This row sits inside a scroll
    // view, where the height is unbounded, and a `Row` stretched to fill a
    // height that does not exist asks Flutter for the one constraint it
    // refuses to draw.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // From under this event's dot down to the next row's top, and four
        // pixels past it so the line meets the next dot instead of stopping
        // in the gap its inset leaves. Rows are painted in order, so that dot
        // covers the tail.
        if (!isLast)
          Positioned(
            top: AppSpacing.xs + AppDimensions.indicator,
            bottom: -AppSpacing.xs,
            left: (AppDimensions.indicator - AppDimensions.hairline) / 2,
            width: AppDimensions.hairline,
            child: ColoredBox(color: theme.colorScheme.outlineVariant),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppDimensions.indicator,
              height: AppDimensions.indicator,
              margin: const EdgeInsets.only(top: AppSpacing.xs),
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.sm),
            Expanded(
              child: Padding(
                // Inside the content rather than around the row: padding the
                // row would leave a gap in the rail between these two events.
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          dateFormatter.format(event.occurredOn),
                          style: AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        AppSpacing.horizontalGap(AppSpacing.sm),
                        Expanded(
                          child: Text(
                            event.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  event.kind ==
                                      ApplicationHistoryKind.screeningNote
                                  ? dotColor
                                  : theme.colorScheme.onSurface,
                              fontWeight:
                                  event.kind ==
                                      ApplicationHistoryKind.screeningNote
                                  ? AppTextStyles.semiBold
                                  : AppTextStyles.regular,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (event.note != null) ...[
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        event.note!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: AppTextStyles.relaxedLineHeight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
