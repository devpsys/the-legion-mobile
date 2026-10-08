import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../models/staff/exam_office_models.dart';
import 'clash_card.dart';
import 'exam_office_block.dart';
import 'exam_office_labels.dart';
import 'issued_card_tile.dart';
import 'paper_tile.dart';

/// One session: its dates, any clashes, its papers and the cards issued in it.
class SessionDetailBody extends StatelessWidget {
  const SessionDetailBody({required this.session, super.key});

  final ExamSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session.name,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  StatusTag(
                    label: ExamOfficeLabels.sessionStatus(l10n, session.status),
                    tone: ExamOfficeLabels.sessionTone(session.status),
                  ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                l10n.examOfficeSessionDates(
                  ExamOfficeLabels.date(l10n, session.endsOn),
                  ExamOfficeLabels.date(l10n, session.startsOn),
                ),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                l10n.examOfficeSessionCardsFrom(
                  ExamOfficeLabels.date(l10n, session.cardsOpenOn),
                ),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              ExamOfficeMetricRow(
                metrics: [
                  ExamOfficeMetric(
                    value: '${session.papers.length}',
                    caption: l10n.examOfficeSessionMetricPapers,
                  ),
                  ExamOfficeMetric(
                    value: '${session.clashes.length}',
                    caption: l10n.examOfficeSessionMetricClashes,
                  ),
                  ExamOfficeMetric(
                    value: '${session.issuedCards.length}',
                    caption: l10n.examOfficeSessionMetricCards,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (session.clashes.isNotEmpty) ...[
          AppSpacing.verticalGap(AppSpacing.lg),
          Text(
            l10n.examOfficeClashesHeading,
            style: theme.textTheme.titleMedium,
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          for (final clash in session.clashes) ...[
            ClashCard(session: session, clash: clash),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
        ],
        AppSpacing.verticalGap(AppSpacing.lg),
        Text(l10n.examOfficePapersHeading, style: theme.textTheme.titleMedium),
        AppSpacing.verticalGap(AppSpacing.sm),
        for (final paper in session.papers) ...[
          PaperTile(session: session, paper: paper),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
        if (session.issuedCards.isNotEmpty) ...[
          AppSpacing.verticalGap(AppSpacing.lg),
          Text(l10n.examOfficeCardsHeading, style: theme.textTheme.titleMedium),
          AppSpacing.verticalGap(AppSpacing.sm),
          for (final card in session.issuedCards) ...[
            IssuedCardTile(session: session, card: card),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
        ],
      ],
    );
  }
}
