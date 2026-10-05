import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/verification_qr_mark.dart';
import '../models/registration_models.dart';
import 'registration_labels.dart';

/// Official course registration form as modular credential pods on paper.
///
/// White in both themes with document ink colours — the same contract as the
/// admission letter: what the student sees is what the registry prints.
class CourseFormDocument extends StatelessWidget {
  const CourseFormDocument({
    required this.student,
    required this.window,
    required this.form,
    super.key,
  });

  final RegistrationStudent student;
  final RegistrationWindow window;
  final CourseFormRecord form;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final longDateTime = AppDateFormats.longDateTime(l10n.localeName);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: AppRadii.cardRadius,
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.paperStroke),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Opacity(
                  opacity: 0.03,
                  child: Icon(
                    Icons.shield_outlined,
                    size: AppDimensions.statusMark * 4,
                    color: AppColors.inkBrand,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CourseFormLetterheadPod(window: window),
              AppSpacing.verticalGap(AppSpacing.lg),
              CourseFormStudentIdentificationPod(
                student: student,
                submissionLog: l10n.courseFormSubmissionLogLine(
                  longDateTime.format(form.submittedOn),
                  form.versionLabel,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              CourseFormRegisteredCoursesSection(form: form),
              AppSpacing.verticalGap(AppSpacing.lg),
              const CourseFormDeclarationPod(),
              AppSpacing.verticalGap(AppSpacing.lg),
              const CourseFormSignaturesDock(),
              AppSpacing.verticalGap(AppSpacing.lg),
              CourseFormAttestationFooter(form: form),
            ],
          ),
        ],
      ),
    );
  }
}

/// Archival certificate banner / letterhead.
class CourseFormLetterheadPod extends StatelessWidget {
  const CourseFormLetterheadPod({required this.window, super.key});

  final RegistrationWindow window;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final trim = AppColors.inkBrand.withValues(alpha: 0.35);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md + AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.paperInset.withValues(alpha: 0.55),
        borderRadius: AppRadii.blockRadius,
        border: Border.all(
          color: AppColors.inkBrand.withValues(alpha: 0.2),
          width: AppDimensions.ruleHeavy,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(height: AppDimensions.hairline, color: trim)),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Container(
                width: AppDimensions.monogramSize,
                height: AppDimensions.monogramSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.paper,
                  border: Border.all(
                    color: AppColors.inkBrand.withValues(alpha: 0.3),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.shield_outlined,
                  size: AppDimensions.iconSmall,
                  color: AppColors.inkBrand,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(child: Container(height: AppDimensions.hairline, color: trim)),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.feesInstitution.toUpperCase(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.inkBrand,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.courseFormOffice.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextStyles.codeSmall.copyWith(
              color: AppColors.inkMuted,
              letterSpacing: AppTextStyles.trackingCaps,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.courseFormSessionLine(window.session, window.termLabel),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.inkMuted,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: AppRadii.chipRadius,
              border: Border.all(
                color: AppColors.inkBrand.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppDimensions.timelineDot,
                  height: AppDimensions.timelineDot,
                  decoration: const BoxDecoration(
                    color: AppColors.inkBrand,
                    shape: BoxShape.circle,
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Text(
                  l10n.courseFormOfficialBadge.toUpperCase(),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppColors.inkBrand,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Student identification credential pod.
class CourseFormStudentIdentificationPod extends StatelessWidget {
  const CourseFormStudentIdentificationPod({
    required this.student,
    required this.submissionLog,
    super.key,
  });

  final RegistrationStudent student;
  final String submissionLog;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: AppColors.paperStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.paperInset,
              border: Border(
                bottom: BorderSide(color: AppColors.paperStroke.withValues(alpha: 0.8)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.badge_outlined,
                  size: AppDimensions.iconSmall,
                  color: AppColors.inkBrand,
                ),
                AppSpacing.horizontalGap(AppSpacing.xs),
                Text(
                  l10n.courseFormStudentHeading.toUpperCase(),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppColors.inkBrand,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    submissionLog,
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.codeSmall.copyWith(
                      color: AppColors.inkSubtle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.courseFormFullName.toUpperCase(),
                            style: AppTextStyles.codeSmall.copyWith(
                              color: AppColors.inkSubtle,
                              letterSpacing: AppTextStyles.trackingCaps,
                            ),
                          ),
                          AppSpacing.verticalGap(AppSpacing.xs),
                          Text(
                            student.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.ink,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l10n.courseFormMatric.toUpperCase(),
                          style: AppTextStyles.codeSmall.copyWith(
                            color: AppColors.inkSubtle,
                            letterSpacing: AppTextStyles.trackingCaps,
                          ),
                        ),
                        AppSpacing.verticalGap(AppSpacing.xs),
                        Text(
                          student.matricNumber,
                          style: AppTextStyles.codeMedium.copyWith(
                            color: AppColors.inkBrand,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                Container(height: AppDimensions.hairline, color: AppColors.paperStroke),
                AppSpacing.verticalGap(AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CourseFormIdentityField(
                        label: l10n.courseFormLevel,
                        value: l10n.registrationLevel(student.level),
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.md),
                    Expanded(
                      child: CourseFormIdentityField(
                        label: l10n.courseFormProgramme,
                        value: student.programme,
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                Container(
                  height: AppDimensions.hairline,
                  color: AppColors.paperStroke.withValues(alpha: 0.7),
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                CourseFormIdentityField(
                  label: l10n.courseFormFacultyDept,
                  value: l10n.courseFormFacultyDeptValue(
                    student.department,
                    student.faculty,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CourseFormIdentityField extends StatelessWidget {
  const CourseFormIdentityField({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.codeSmall.copyWith(color: AppColors.inkMuted),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.ink,
            fontWeight: AppTextStyles.semiBold,
            height: AppTextStyles.denseLineHeight,
          ),
        ),
      ],
    );
  }
}

/// Registered courses as stacked modular pods plus a total-units metric.
class CourseFormRegisteredCoursesSection extends StatelessWidget {
  const CourseFormRegisteredCoursesSection({required this.form, super.key});

  final CourseFormRecord form;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            children: [
              Icon(
                Icons.view_module_outlined,
                size: AppDimensions.iconSmall,
                color: AppColors.inkMuted,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.courseFormRegisteredCourses.toUpperCase(),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppColors.inkMuted,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
              ),
              Text(
                l10n.courseFormUnitsColumn,
                style: AppTextStyles.codeSmall.copyWith(color: AppColors.inkSubtle),
              ),
            ],
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        for (var i = 0; i < form.courses.length; i++) ...[
          if (i > 0) AppSpacing.verticalGap(AppSpacing.sm),
          CourseFormCoursePod(course: form.courses[i]),
        ],
        AppSpacing.verticalGap(AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md + AppSpacing.xs,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.paperInset,
            borderRadius: AppRadii.blockRadius,
            border: Border.all(
              color: AppColors.inkBrand.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: AppDimensions.iconDense,
                color: AppColors.inkBrand,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.courseFormTotalRegisteredUnits.toUpperCase(),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppColors.ink,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
              ),
              Text(
                l10n.courseFormUnitsAbbrev,
                style: AppTextStyles.codeSmall.copyWith(color: AppColors.inkSubtle),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Text(
                '${form.totalUnits}',
                style: AppTextStyles.tabular(
                  AppTextStyles.codeLarge.copyWith(
                    color: AppColors.inkBrand,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One registered course as a modular pod.
class CourseFormCoursePod extends StatelessWidget {
  const CourseFormCoursePod({required this.course, super.key});

  final RegisteredCourse course;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final status = RegistrationLabels.courseStatus(l10n, course.status);
    final approved = course.status == CourseApprovalStatus.approved ||
        course.status == CourseApprovalStatus.clashAccepted;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paper.withValues(alpha: 0.9),
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: AppColors.paperStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.paperInset,
                    borderRadius: AppRadii.tagRadius,
                    border: Border.all(
                      color: AppColors.paperStroke.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Text(
                    course.code,
                    style: AppTextStyles.codeMedium.copyWith(
                      color: AppColors.inkBrand,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Text(
                  l10n.courseFormSectionLabel(course.section),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppColors.inkSubtle,
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.paperInset,
                    borderRadius: AppRadii.tagRadius,
                    border: Border.all(
                      color: AppColors.paperStroke.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Text(
                    l10n
                        .courseFormUnitsStatus(status, course.units)
                        .toUpperCase(),
                    softWrap: false,
                    style: AppTextStyles.codeSmall.copyWith(
                      color: approved ? AppColors.ink : AppColors.inkMuted,
                      fontWeight: approved
                          ? AppTextStyles.bold
                          : AppTextStyles.medium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              course.title,
              softWrap: false,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.ink,
                fontWeight: AppTextStyles.semiBold,
                height: AppTextStyles.denseLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseFormDeclarationPod extends StatelessWidget {
  const CourseFormDeclarationPod({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paperInset.withValues(alpha: 0.55),
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: AppColors.paperStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: AppDimensions.iconSmall,
                color: AppColors.inkSubtle,
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Text(
                l10n.courseFormDeclarationHeading.toUpperCase(),
                style: AppTextStyles.codeSmall.copyWith(
                  color: AppColors.inkSubtle,
                  letterSpacing: AppTextStyles.trackingCaps,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Container(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.inkBrand.withValues(alpha: 0.4),
                  width: AppDimensions.ruleHeavy,
                ),
              ),
            ),
            child: Text(
              l10n.courseFormDeclarationBody,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.ink,
                fontStyle: FontStyle.italic,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Container(height: AppDimensions.hairline, color: AppColors.paperStroke),
          AppSpacing.verticalGap(AppSpacing.sm),
          Row(
            children: [
              Flexible(
                child: Text(
                  l10n.courseFormAuthDigital,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppColors.inkSubtle,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Flexible(
                child: Text(
                  l10n.courseFormStatusValidated,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppColors.inkSubtle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CourseFormSignaturesDock extends StatelessWidget {
  const CourseFormSignaturesDock({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: AppColors.paperStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.draw_outlined,
                size: AppDimensions.iconSmall,
                color: AppColors.inkSubtle,
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Expanded(
                child: Text(
                  l10n.courseFormSignatures.toUpperCase(),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppColors.inkSubtle,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Container(height: AppDimensions.hairline, color: AppColors.paperStroke),
          AppSpacing.verticalGap(AppSpacing.md),
          CourseFormSignatureBlock(label: l10n.courseFormStudentSignature),
          AppSpacing.verticalGap(AppSpacing.md),
          CourseFormSignatureBlock(label: l10n.courseFormAdviserSignature),
          AppSpacing.verticalGap(AppSpacing.md),
          CourseFormSignatureBlock(label: l10n.courseFormHodSignature),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            l10n.courseFormSignaturePrintNote,
            textAlign: TextAlign.center,
            style: AppTextStyles.codeSmall.copyWith(
              color: AppColors.inkSubtle,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class CourseFormAttestationFooter extends StatelessWidget {
  const CourseFormAttestationFooter({required this.form, super.key});

  final CourseFormRecord form;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paperInset.withValues(alpha: 0.4),
        borderRadius: AppRadii.blockRadius,
        border: Border.all(
          color: AppColors.paperStroke.withValues(alpha: 0.9),
          width: AppDimensions.ruleHeavy,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: AppDimensions.iconTile + AppSpacing.md,
                      height: AppDimensions.iconTile + AppSpacing.md,
                      child: FittedBox(
                        child: VerificationQrMark(code: form.documentId),
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.courseFormVerifyAuthenticity.toUpperCase(),
                            style: AppTextStyles.codeSmall.copyWith(
                              color: AppColors.ink,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          AppSpacing.verticalGap(AppSpacing.xs),
                          Text(
                            l10n.courseFormDocId(form.documentId),
                            style: AppTextStyles.codeSmall.copyWith(
                              color: AppColors.inkSubtle,
                            ),
                          ),
                          Text(
                            l10n.courseFormRegistrarArchive.toUpperCase(),
                            style: AppTextStyles.codeSmall.copyWith(
                              color: AppColors.inkSubtle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              SizedBox(
                width: AppDimensions.monogramSize + AppSpacing.md,
                height: AppDimensions.monogramSize + AppSpacing.md,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.paper,
                    border: Border.all(
                      color: AppColors.inkBrand.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: FittedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.courseFormSealed.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.codeSmall.copyWith(
                              color: AppColors.inkBrand,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Icon(
                            Icons.verified_outlined,
                            size: AppDimensions.iconSmall,
                            color: AppColors.inkBrand,
                          ),
                          Text(
                            l10n.courseFormAcademicReg.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.codeSmall.copyWith(
                              color: AppColors.inkMuted,
                              fontWeight: AppTextStyles.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Container(height: AppDimensions.hairline, color: AppColors.paperStroke),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.courseFormFormId(form.formId),
            textAlign: TextAlign.center,
            style: AppTextStyles.codeSmall.copyWith(
              color: AppColors.inkSubtle,
              letterSpacing: AppTextStyles.trackingCaps,
            ),
          ),
        ],
      ),
    );
  }
}

/// Signature underline block for the printed copy.
class CourseFormSignatureBlock extends StatelessWidget {
  const CourseFormSignatureBlock({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.paperInset.withValues(alpha: 0.35),
        borderRadius: AppRadii.elementRadius,
        border: Border.all(
          color: AppColors.paperStroke,
          // Design uses dashed; Flutter solid hairline keeps print crisp.
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppColors.inkMuted,
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              Text(
                l10n.courseFormSignatureDateBlank,
                style: AppTextStyles.codeSmall.copyWith(color: AppColors.inkSubtle),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Container(
            height: AppDimensions.hairline,
            color: AppColors.ink.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}
