import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/examinations_models.dart';
import 'card_issued_section.dart';
import 'card_not_issued_section.dart';
import 'card_revoked_section.dart';
import 'examinations_labels.dart';
import 'examinations_page_header.dart';

/// The examination card tab: it switches on whether the card is not issued,
/// issued or withdrawn.
class CardBody extends StatelessWidget {
  const CardBody({required this.student, required this.card, super.key});

  final ExamStudent student;
  final ExaminationCard card;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExaminationsScrollBody(
      title: l10n.examCardTitle,
      subtitle: l10n.examCardSubtitle,
      children: [
        if (card.status == CardStatus.issued)
          Wrap(
            spacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                card.examinationName,
                style: context.theme.textTheme.titleMedium,
              ),
              StatusTag(
                label: ExaminationsLabels.cardStatus(l10n, card.status),
                tone: ExaminationsLabels.cardTone(card.status),
              ),
            ],
          ),
        switch (card.status) {
          CardStatus.notIssued => CardNotIssuedSection(
            student: student,
            card: card,
          ),
          CardStatus.issued => CardIssuedSection(student: student, card: card),
          CardStatus.revoked => CardRevokedSection(
            student: student,
            card: card,
          ),
        },
      ],
    );
  }
}
