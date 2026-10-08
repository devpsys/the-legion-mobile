import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../models/examinations_models.dart';
import 'results_empty_card.dart';
import 'results_identity_card.dart';
import 'results_standing_banner.dart';
import 'standing_card.dart';
import 'term_results_card.dart';

/// The results hub body: the dossier when results are published, otherwise
/// the empty state.
class ResultsBody extends StatelessWidget {
  const ResultsBody({required this.student, required this.record, super.key});

  final ExamStudent student;
  final ResultsRecord record;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.lg,
            bottom: AppSpacing.huge + AppSpacing.xxl,
          ),
          child: switch (record.status) {
            ResultsStatus.unpublished => UnpublishedResults(
              student: student,
              record: record,
            ),
            ResultsStatus.published => ResultsDossier(
              student: student,
              record: record,
            ),
          },
        ),
      ),
    );
  }
}

/// Results before the registry has published a semester.
class UnpublishedResults extends StatelessWidget {
  const UnpublishedResults({
    required this.student,
    required this.record,
    super.key,
  });

  final ExamStudent student;
  final ResultsRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ResultsIdentityCard(student: student),
        AppSpacing.verticalGap(AppSpacing.lg),
        Text(l10n.examResultsTitle, style: theme.textTheme.headlineMedium),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          l10n.examResultsSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        ResultsEmptyCard(sessionLabel: record.sessionLabel),
      ],
    );
  }
}

/// Published results as the segmented dossier: standing, the latest semester,
/// then any earlier ones.
class ResultsDossier extends StatefulWidget {
  const ResultsDossier({required this.student, required this.record, super.key});

  final ExamStudent student;
  final ResultsRecord record;

  @override
  State<ResultsDossier> createState() => ResultsDossierState();
}

/// State of [ResultsDossier].
class ResultsDossierState extends State<ResultsDossier> {
  bool _showEarlier = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final record = widget.record;
    final latest = record.terms.isEmpty ? null : record.terms.first;
    final earlier = record.terms.skip(1).toList(growable: false);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ResultsIdentityCard(student: widget.student),
        AppSpacing.verticalGap(AppSpacing.lg),
        Text(l10n.examResultsTitle, style: theme.textTheme.headlineMedium),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          l10n.examResultsSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(color: muted),
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        ResultsStandingBanner(record: record),
        if (record.standing != StandingKind.good) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          StandingAdvisory(record: record, student: widget.student),
        ],
        if (latest != null) ...[
          AppSpacing.verticalGap(AppSpacing.lg),
          TermResultsCard(term: latest, cumulativeCgpa: record.cgpa),
        ],
        if (_showEarlier)
          for (final term in earlier) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            TermResultsCard(term: term, cumulativeCgpa: record.cgpa),
          ],
        AppSpacing.verticalGap(AppSpacing.lg),
        FilledButton.icon(
          onPressed: () => context.showMessage(l10n.commonComingSoon),
          icon: const Icon(Icons.download_outlined),
          label: Text(l10n.examResultsDownloadSlip),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () {
            if (earlier.isEmpty) {
              context.showMessage(l10n.examResultsNoEarlier);
              return;
            }
            setState(() => _showEarlier = !_showEarlier);
          },
          icon: const Icon(Icons.history_edu_outlined),
          label: Text(
            _showEarlier
                ? l10n.examResultsHidePrevious
                : l10n.examResultsViewPrevious,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        Container(
          padding: AppSpacing.card,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: AppRadii.blockRadius,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(
                Icons.gavel_outlined,
                size: AppDimensions.iconSmall,
                color: muted,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.examResultsLedgerStatus,
                  style: AppTextStyles.codeSmall.copyWith(color: muted),
                ),
              ),
              Text(
                l10n.examResultsSenateSection,
                style: theme.textTheme.bodySmall?.copyWith(color: muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
