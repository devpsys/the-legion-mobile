import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../models/examinations_models.dart';
import 'examinations_labels.dart';

/// What the hall-door check found: a valid card with its five facts, or one
/// of the reasons the card is not valid. Never a photo.
class ExamCardCheckResultCard extends StatelessWidget {
  const ExamCardCheckResultCard({required this.result, super.key});

  final ExamCardCheckResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reason = result.withdrawnReason;

    return switch (result.status) {
      ExamCardCheckStatus.idle => const SizedBox.shrink(),
      ExamCardCheckStatus.valid => SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ToneCallout(
              tone: AppTone.success,
              icon: Icons.check_circle_outline,
              title: l10n.examVerifyValidTitle,
              body: l10n.examVerifyValidBody,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            LabelledValueRow(label: l10n.examVerifyName, value: result.name),
            AppSpacing.verticalGap(AppSpacing.xs),
            LabelledValueRow(
              label: l10n.examVerifyMatric,
              value: result.matricNumber,
              isCode: true,
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            LabelledValueRow(
              label: l10n.examVerifyProgramme,
              value: result.programme,
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            LabelledValueRow(
              label: l10n.examVerifyCard,
              value: result.cardNumber,
              isCode: true,
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            LabelledValueRow(
              label: l10n.examVerifyPapers,
              value: l10n.examVerifyPapersValue(
                result.eligiblePapers,
                result.sessionLabel,
              ),
            ),
          ],
        ),
      ),
      ExamCardCheckStatus.withdrawn => SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ToneCallout(
              tone: AppTone.danger,
              icon: Icons.cancel_outlined,
              title: l10n.examVerifyInvalidTitle,
              body: reason == null
                  ? l10n.examVerifyWithdrawnBody
                  : l10n.examVerifyWithdrawnWhy(
                      ExaminationsLabels.revokedReason(l10n, reason),
                    ),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            LabelledValueRow(
              label: l10n.examVerifyCard,
              value: result.cardNumber,
              isCode: true,
            ),
          ],
        ),
      ),
      ExamCardCheckStatus.standingBlocked => SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ToneCallout(
              tone: AppTone.danger,
              icon: Icons.cancel_outlined,
              title: l10n.examVerifyInvalidTitle,
              body: l10n.examVerifyStandingBody,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            LabelledValueRow(
              label: l10n.examVerifyCard,
              value: result.cardNumber,
              isCode: true,
            ),
          ],
        ),
      ),
      ExamCardCheckStatus.notFound => ToneCallout(
        tone: AppTone.warning,
        icon: Icons.error_outline,
        title: l10n.examVerifyNotFoundTitle,
        body: l10n.examVerifyNotFoundBody(examCardCodeLength),
      ),
    };
  }
}
