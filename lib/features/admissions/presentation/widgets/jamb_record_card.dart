import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../models/jamb_models.dart';
import 'section_surface.dart';
import 'status_tag.dart';

/// The CAPS record the candidate's facts matched — or, once claimed, the one
/// on their record.
///
/// Shows the candidate what the university holds before asking them to bind
/// it: the name, so they can see it is theirs; the aggregate, set large because
/// it is the number the whole admission turns on; and the subjects under it.
/// The notice at the foot names the application the record binds to, in the
/// future tense before linking and the present after — the same card, telling
/// the truth at both moments.
class JambRecordCard extends StatelessWidget {
  const JambRecordCard({
    required this.result,
    required this.isLinked,
    this.linkedReference,
    super.key,
  });

  final JambResult result;

  /// `false` while the record is only matched; `true` once it is on file.
  final bool isLinked;

  /// The tracking code of the application the record binds to; `null` when
  /// the record does not carry one, in which case no notice is drawn.
  final String? linkedReference;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final reference = linkedReference;
    final divider = BorderSide(color: theme.colorScheme.outlineVariant);

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(border: Border(bottom: divider)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.admissionsJambRecordEyebrow.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: AppTextStyles.semiBold,
                          letterSpacing: AppTextStyles.trackingCapsWide,
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        l10n.admissionsJambRecordTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                StatusTag(
                  label: isLinked
                      ? l10n.admissionsJambRecordLinked
                      : l10n.admissionsJambRecordFound,
                  tone: AppTone.success,
                  icon: isLinked ? Icons.link : Icons.check,
                ),
              ],
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          JambFactRow(
            label: l10n.admissionsJambCandidate,
            value: result.candidateName,
            isEmphasised: true,
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          JambFactRow(
            label: l10n.admissionsJambExaminationYear,
            value: l10n.admissionsJambExaminationValue(result.examinationYear),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          JambAggregateRow(score: result.aggregateScore),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            l10n.admissionsJambSubjects.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: AppTextStyles.semiBold,
              letterSpacing: AppTextStyles.trackingCaps,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          JambSubjectGrid(subjects: result.subjects),
          if (reference != null) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Container(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              decoration: BoxDecoration(border: Border(top: divider)),
              child: JambBindingNotice(
                reference: reference,
                isLinked: isLinked,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One fact of the record: label left, value right.
class JambFactRow extends StatelessWidget {
  const JambFactRow({
    required this.label,
    required this.value,
    this.isEmphasised = false,
    super.key,
  });

  final String label;
  final String value;

  /// Bold rather than medium — for the name, which the candidate checks is
  /// their own.
  final bool isEmphasised;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.md),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isEmphasised
                  ? AppTextStyles.semiBold
                  : AppTextStyles.medium,
            ),
          ),
        ),
      ],
    );
  }
}

/// The aggregate, on its own raised row: the number the admission turns on.
class JambAggregateRow extends StatelessWidget {
  const JambAggregateRow({required this.score, super.key});

  final int score;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              context.l10n.admissionsJambAggregate,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          Text(
            '$score',
            style: AppTextStyles.tabular(
              AppTextStyles.codeDisplay.copyWith(
                color: theme.colorScheme.primaryContainer,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The subjects, two to a row: name left, score right in the mono face.
class JambSubjectGrid extends StatelessWidget {
  const JambSubjectGrid({required this.subjects, super.key});

  final List<JambSubjectScore> subjects;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Two columns with one gutter between them; the tiles take exactly
        // half each so a four-subject result sits as a 2×2 block.
        final tileWidth = (constraints.maxWidth - AppSpacing.sm) / 2;
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final subject in subjects)
              SizedBox(
                width: tileWidth,
                child: JambSubjectTile(subject: subject),
              ),
          ],
        );
      },
    );
  }
}

/// One subject and its score.
class JambSubjectTile extends StatelessWidget {
  const JambSubjectTile({required this.subject, super.key});

  final JambSubjectScore subject;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: AppRadii.blockRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              subject.subject,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: AppTextStyles.regular,
              ),
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Text(
            '${subject.score}',
            style: AppTextStyles.tabular(
              AppTextStyles.codeMedium.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Which application the record binds to — a promise before linking, a fact
/// after.
class JambBindingNotice extends StatelessWidget {
  const JambBindingNotice({
    required this.reference,
    required this.isLinked,
    super.key,
  });

  final String reference;
  final bool isLinked;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final style = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final sentence = isLinked
        ? l10n.admissionsJambLinkedNotice(reference)
        : l10n.admissionsJambBindingNotice(reference);
    // The reference is set bold inside the sentence, wherever the language
    // puts it.
    final at = sentence.indexOf(reference);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.lock_outline,
          size: AppDimensions.iconSmall,
          color: AppTone.info.foreground(theme.brightness),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Expanded(
          child: at < 0
              ? Text(sentence, style: style)
              : Text.rich(
                  TextSpan(
                    style: style,
                    children: [
                      TextSpan(text: sentence.substring(0, at)),
                      TextSpan(
                        text: reference,
                        style: style?.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      TextSpan(text: sentence.substring(at + reference.length)),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
