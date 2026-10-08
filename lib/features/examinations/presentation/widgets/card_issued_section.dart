import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../../core/widgets/verification_qr_mark.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../models/examinations_models.dart';
import 'card_paper_tile.dart';

/// The card on screen: who it is for, its number and check code, the QR mark
/// and the timetable of papers.
///
/// Printing has no service yet, so the print button reports that.
class CardIssuedSection extends StatelessWidget {
  const CardIssuedSection({
    required this.student,
    required this.card,
    super.key,
  });

  final ExamStudent student;
  final ExaminationCard card;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final issuedOn = card.issuedOn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SurfaceCard(
          padding: AppSpacing.sheet,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.examCardInstitution,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  StatusTag(label: l10n.examCardOfficial, tone: AppTone.info),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                l10n.examCardSession(card.sessionLabel),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              LabelledValueRow(
                label: l10n.examCardCandidate,
                value: student.name,
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              LabelledValueRow(
                label: l10n.examCardMatric,
                value: student.matricNumber,
                isCode: true,
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              LabelledValueRow(
                label: l10n.examCardProgramme,
                value: l10n.examStudentLine(student.level, student.programme),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.examCardNumberLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SelectableText(
                          card.cardNumber,
                          style: AppTextStyles.codeLarge.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        AppSpacing.verticalGap(AppSpacing.sm),
                        Text(
                          l10n.examCardCheckCodeLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SelectableText(
                          card.checkCode,
                          style: AppTextStyles.codeMedium.copyWith(
                            fontWeight: AppTextStyles.semiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  VerificationQrMark(code: card.checkCode),
                ],
              ),
              if (issuedOn != null) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                Text(
                  l10n.examCardIssuedOn(
                    AppDateFormats.long(l10n.localeName).format(issuedOn),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.examCardPapersTitle,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Text(
              l10n.examCardPapersCount(card.papers.length),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        for (final paper in card.papers) ...[
          CardPaperTile(paper: paper),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
        ToneCallout(
          tone: AppTone.info,
          icon: Icons.info_outline,
          body: l10n.examCardPersonalNote,
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () => context.showMessage(l10n.commonComingSoon),
          icon: const Icon(Icons.print_outlined),
          label: Text(l10n.examCardPrint),
        ),
      ],
    );
  }
}
