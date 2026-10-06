import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/registration_cubit.dart';
import '../bloc/registration_state.dart';
import '../models/registration_models.dart';
import 'discipline_appeal_form.dart';
import 'registration_card.dart';
import 'registration_chrome.dart';
import 'registration_labels.dart';

/// Scrollable body of one disciplinary case detail screen.
class DisciplineCaseBody extends StatelessWidget {
  const DisciplineCaseBody({
    required this.state,
    required this.cubit,
    required this.caseId,
    super.key,
  });

  final RegistrationState state;
  final RegistrationCubit cubit;
  final String caseId;

  @override
  Widget build(BuildContext context) {
    final student = state.student;
    final record = state.discipline;
    final item = record?.caseById(caseId);
    if (student == null || record == null) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    if (item == null) {
      return ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ToneCallout(
            tone: AppTone.warning,
            icon: Icons.search_off_outlined,
            body: l10n.disciplineCaseNotFound,
          ),
        ),
      );
    }

    final dateFormat = AppDateFormats.medium(l10n.localeName);
    final longDate = AppDateFormats.long(l10n.localeName);
    final hearingFormat = AppDateFormats.weekdayLongDateTime(l10n.localeName);

    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            AppSpacing.md,
            0,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DisciplineCasePageHeader(reference: item.reference),
              AppSpacing.verticalGap(AppSpacing.md),
              if (!record.standing.isInGoodStanding) ...[
                ToneCallout(
                  tone: AppTone.danger,
                  icon: Icons.lock_outline,
                  title: RegistrationLabels.studentStanding(
                    l10n,
                    record.standing,
                  ),
                  body: l10n.disciplineSuspendedBanner,
                ),
                AppSpacing.verticalGap(AppSpacing.md),
              ],
              DisciplineCaseHero(
                student: student,
                item: item,
                dateFormat: dateFormat,
              ),
              if (item.status == DisciplineCaseStatus.underAppeal) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                ToneCallout(
                  tone: AppTone.warning,
                  icon: Icons.gavel_outlined,
                  title: l10n.disciplineAppealFiledBanner,
                  body: l10n.disciplineAppealAbeyanceNote,
                ),
              ],
              if (record.appealWindowClosed(item) &&
                  item.appealWindowClosesOn != null) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                ToneCallout(
                  tone: AppTone.neutral,
                  icon: Icons.verified_outlined,
                  title: l10n.disciplineDecisionFinalized,
                  body: l10n.disciplineDecisionFinalizedBody(
                    longDate.format(item.appealWindowClosesOn!),
                  ),
                ),
              ],
              if (item.finding != null && item.decisionReason != null) ...[
                AppSpacing.verticalGap(AppSpacing.lg),
                DisciplineDecisionSection(item: item, dateFormat: longDate),
              ],
              if (item.sanction != null) ...[
                AppSpacing.verticalGap(AppSpacing.lg),
                DisciplineSanctionDetail(sanction: item.sanction!),
              ],
              AppSpacing.verticalGap(AppSpacing.lg),
              DisciplineAppealSection(
                record: record,
                item: item,
                cubit: cubit,
              ),
              if (item.hearing != null) ...[
                AppSpacing.verticalGap(AppSpacing.lg),
                DisciplineHearingSection(
                  hearing: item.hearing!,
                  format: hearingFormat,
                ),
              ],
              AppSpacing.verticalGap(AppSpacing.lg),
              DisciplineAllegationSection(
                item: item,
                dateFormat: dateFormat,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              DisciplineEvidenceSection(evidence: item.evidence),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationAboutCard(
                title: l10n.disciplineAboutTitle,
                body: l10n.disciplineAboutBody,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Breadcrumb for a case detail screen.
class DisciplineCasePageHeader extends StatelessWidget {
  const DisciplineCasePageHeader({required this.reference, super.key});

  final String reference;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              l10n.registrationBreadcrumbStudent,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Icon(
              Icons.chevron_right,
              size: AppDimensions.iconMicro,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Text(
              l10n.disciplineBreadcrumb,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Icon(
              Icons.chevron_right,
              size: AppDimensions.iconMicro,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Flexible(
              child: Text(
                reference,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Text(
          l10n.disciplineCaseTitle(reference),
          style: theme.textTheme.headlineMedium,
        ),
      ],
    );
  }
}

/// Case summary header with status tags.
class DisciplineCaseHero extends StatelessWidget {
  const DisciplineCaseHero({
    required this.student,
    required this.item,
    required this.dateFormat,
    super.key,
  });

  final RegistrationStudent student;
  final DisciplineCase item;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final statusLabel = RegistrationLabels.disciplineCaseStatus(
      l10n,
      item.status,
    );
    final severityLabel = RegistrationLabels.disciplineSeverity(
      l10n,
      item.severity,
    );

    return RegistrationCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              student.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              l10n.registrationMatricLevel(
                l10n.registrationLevel(student.level),
                student.matricNumber,
              ),
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              item.reference,
              style: AppTextStyles.codeMedium.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                StatusTag(label: statusLabel, tone: item.status.tone),
                StatusTag(label: severityLabel, tone: item.severity.tone),
                if (item.finding != null)
                  StatusTag(
                    label: RegistrationLabels.disciplineFinding(
                      l10n,
                      item.finding!,
                    ),
                    tone: item.finding == DisciplineFinding.foundLiable
                        ? AppTone.danger
                        : AppTone.success,
                  ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              item.summary,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            if (item.decidedOn != null) ...[
              AppSpacing.verticalGap(AppSpacing.sm),
              Text(
                l10n.disciplineDecidedOn(dateFormat.format(item.decidedOn!)),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Finding and decision reason block.
class DisciplineDecisionSection extends StatelessWidget {
  const DisciplineDecisionSection({
    required this.item,
    required this.dateFormat,
    super.key,
  });

  final DisciplineCase item;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final finding = item.finding!;

    return RegistrationCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatusTag(
              label: RegistrationLabels.disciplineFinding(l10n, finding),
              tone: finding == DisciplineFinding.foundLiable
                  ? AppTone.danger
                  : AppTone.success,
            ),
            if (item.decidedOn != null) ...[
              AppSpacing.verticalGap(AppSpacing.sm),
              Text(
                l10n.disciplineDecidedOn(dateFormat.format(item.decidedOn!)),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              item.decisionReason!,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sanction detail with lifecycle note.
class DisciplineSanctionDetail extends StatelessWidget {
  const DisciplineSanctionDetail({required this.sanction, super.key});

  final DisciplineSanction sanction;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    RegistrationLabels.sanctionType(l10n, sanction.type),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
                ),
                StatusTag(
                  label: RegistrationLabels.sanctionLifecycle(
                    l10n,
                    sanction.lifecycle,
                  ),
                  tone: sanction.lifecycle.tone,
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              sanction.summary,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            if (sanction.statusNote.isNotEmpty) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              ToneCallout(
                tone: AppTone.success,
                icon: Icons.check_circle_outline,
                body: sanction.statusNote,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Hearing appointment or held-hearing record.
class DisciplineHearingSection extends StatelessWidget {
  const DisciplineHearingSection({
    required this.hearing,
    required this.format,
    super.key,
  });

  final DisciplineHearing hearing;
  final DateFormat format;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  hearing.scheduled
                      ? Icons.event_note_outlined
                      : Icons.event_available_outlined,
                  size: AppDimensions.iconDense,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    hearing.scheduled
                        ? l10n.disciplineHearingScheduledTitle
                        : l10n.disciplineHearingHeldTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
                ),
                if (hearing.scheduled)
                  StatusTag(
                    label: l10n.disciplineHearingSessionMandatory,
                    tone: AppTone.warning,
                  ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              format.format(hearing.heldOn),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              l10n.disciplineHearingAtVenue(hearing.venue),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (hearing.note.isNotEmpty) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                hearing.note,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Allegation narrative and meta.
class DisciplineAllegationSection extends StatelessWidget {
  const DisciplineAllegationSection({
    required this.item,
    required this.dateFormat,
    super.key,
  });

  final DisciplineCase item;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.disciplineAllegationTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            DisciplineCaseMetaRow(
              label: l10n.disciplineAllegationCategory,
              value: RegistrationLabels.disciplineCategory(l10n, item.category),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            DisciplineCaseMetaRow(
              label: l10n.disciplineAllegationIncident,
              value: l10n.disciplineIncidentLine(
                dateFormat.format(item.incidentOn),
                item.incidentVenue,
                item.sessionLabel,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            DisciplineCaseMetaRow(
              label: l10n.disciplineAllegationReportedBy,
              value: l10n.disciplineReportedLine(
                item.reportedBy,
                dateFormat.format(item.reportedOn),
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              item.narrative,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Label / value pair inside a case allegation block.
class DisciplineCaseMetaRow extends StatelessWidget {
  const DisciplineCaseMetaRow({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.codeSmall.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: AppTextStyles.trackingCaps,
            fontWeight: AppTextStyles.semiBold,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: AppTextStyles.relaxedLineHeight,
          ),
        ),
      ],
    );
  }
}

/// Evidence list the student may inspect before a hearing.
class DisciplineEvidenceSection extends StatelessWidget {
  const DisciplineEvidenceSection({required this.evidence, super.key});

  final List<DisciplineEvidence> evidence;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RegistrationSectionHeader(
              title: l10n.disciplineEvidenceTitle,
              countLabel: l10n.disciplineEvidenceCount(evidence.length),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            for (var i = 0; i < evidence.length; i++) ...[
              if (i > 0) AppSpacing.verticalGap(AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    evidence[i].kind == EvidenceKind.document
                        ? Icons.description_outlined
                        : Icons.edit_note_outlined,
                    size: AppDimensions.iconDense,
                    color: theme.colorScheme.primary,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evidence[i].title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: AppTextStyles.semiBold,
                          ),
                        ),
                        AppSpacing.verticalGap(AppSpacing.xs),
                        Text(
                          evidence[i].detail.isEmpty
                              ? RegistrationLabels.evidenceKind(
                                  l10n,
                                  evidence[i].kind,
                                )
                              : '${RegistrationLabels.evidenceKind(l10n, evidence[i].kind)} · ${evidence[i].detail}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            AppSpacing.verticalGap(AppSpacing.md),
            ToneCallout(
              tone: AppTone.info,
              icon: Icons.info_outline,
              body: l10n.disciplineEvidenceInspectHint,
            ),
          ],
        ),
      ),
    );
  }
}
