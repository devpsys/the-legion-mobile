import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/brand_crest_tile.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/registration_models.dart';
import 'registration_labels.dart';

/// Official course registration form as a paper document on screen.
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
    final theme = context.theme;
    final dateFormat = AppDateFormats.longDateTime(l10n.localeName);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: AppRadii.blockRadius,
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: AppColors.paperStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const BrandCrestTile(),
              AppSpacing.horizontalGap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.feesInstitution,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.inkBrand,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.courseFormOffice,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Container(height: AppDimensions.ruleHeavy, color: AppColors.inkBrand),
          AppSpacing.verticalGap(AppSpacing.xs),
          Container(height: AppDimensions.hairline, color: AppColors.paperRule),
          AppSpacing.verticalGap(AppSpacing.lg),
          Text(
            l10n.courseFormSessionLine(window.session, window.termLabel),
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.ink,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: StatusTag(
              label: l10n.courseFormOfficialBadge,
              tone: AppTone.success,
              isUppercase: true,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xl),
          Text(
            l10n.courseFormStudentHeading,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.inkBrand,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          CourseFormFieldRow(
            label: l10n.courseFormFullName,
            value: student.name,
          ),
          CourseFormFieldRow(
            label: l10n.courseFormMatric,
            value: student.matricNumber,
            isCode: true,
          ),
          CourseFormFieldRow(
            label: l10n.courseFormLevel,
            value: l10n.registrationLevel(student.level),
          ),
          CourseFormFieldRow(
            label: l10n.courseFormProgramme,
            value: student.programme,
          ),
          CourseFormFieldRow(
            label: l10n.courseFormFacultyDept,
            value: l10n.courseFormFacultyDeptValue(
              student.department,
              student.faculty,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Text(
            l10n.courseFormSubmissionLog,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.inkBrand,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.courseFormVersionLine(
              dateFormat.format(form.submittedOn),
              form.versionLabel,
            ),
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.ink),
          ),
          AppSpacing.verticalGap(AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.courseFormRegisteredCourses,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.inkBrand,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                l10n.courseFormUnitsColumn,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          for (final course in form.courses) ...[
            CourseFormCourseRow(course: course),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
          AppSpacing.verticalGap(AppSpacing.md),
          Row(
            children: [
              Text(
                l10n.courseFormTotalUnits,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
              const Spacer(),
              Text(
                '${form.totalUnits}',
                style: AppTextStyles.tabular(
                  AppTextStyles.codeMedium.copyWith(
                    color: AppColors.ink,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xl),
          Text(
            l10n.courseFormDeclarationHeading,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.inkBrand,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.courseFormDeclarationBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.inkBody,
              height: AppTextStyles.documentLineHeight,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.courseFormAuthDigital,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.inkMuted,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xl),
          Text(
            l10n.courseFormSignatures,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.inkBrand,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Container(height: AppDimensions.hairline, color: AppColors.paperRule),
          AppSpacing.verticalGap(AppSpacing.md),
          CourseFormSignatureBlock(label: l10n.courseFormStudentSignature),
          AppSpacing.verticalGap(AppSpacing.md),
          CourseFormSignatureBlock(label: l10n.courseFormAdviserSignature),
          AppSpacing.verticalGap(AppSpacing.md),
          CourseFormSignatureBlock(label: l10n.courseFormHodSignature),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.courseFormSignaturePrintNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.inkSubtle,
              fontStyle: FontStyle.italic,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.paperInset,
              borderRadius: AppRadii.elementRadius,
              border: Border.all(color: AppColors.paperStroke),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.courseFormVerifyFooter,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(
                  l10n.courseFormDocId(form.documentId),
                  style: AppTextStyles.codeMedium.copyWith(
                    color: AppColors.ink,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.courseFormFormId(form.formId),
                  style: AppTextStyles.codeMedium.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(
                  l10n.courseFormSealed.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.inkBrand,
                    letterSpacing: AppTextStyles.trackingCaps,
                    fontWeight: AppTextStyles.bold,
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

/// Label/value row using document ink rather than theme surfaces.
class CourseFormFieldRow extends StatelessWidget {
  const CourseFormFieldRow({
    required this.label,
    required this.value,
    this.isCode = false,
    super.key,
  });

  final String label;
  final String value;
  final bool isCode;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final valueStyle = isCode
        ? AppTextStyles.codeMedium.copyWith(
            color: AppColors.ink,
            fontWeight: AppTextStyles.semiBold,
          )
        : theme.textTheme.bodyLarge!.copyWith(
            color: AppColors.ink,
            fontWeight: AppTextStyles.semiBold,
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.inkMuted,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: AppTextStyles.tabular(valueStyle)),
          ),
        ],
      ),
    );
  }
}

/// One registered course line on the form.
class CourseFormCourseRow extends StatelessWidget {
  const CourseFormCourseRow({required this.course, super.key});

  final RegisteredCourse course;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.paperInset,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: AppColors.paperStroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.code,
                  style: AppTextStyles.codeMedium.copyWith(
                    color: AppColors.ink,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  course.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.inkBody,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.registrationSectionUnits(course.section, course.units),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          StatusTag(
            label: RegistrationLabels.courseStatus(l10n, course.status),
            tone: course.status.tone,
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
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.inkMuted),
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        Container(
          width: AppDimensions.signatureBlockWidth,
          height: AppDimensions.hairline,
          color: AppColors.ink,
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Text(
          l10n.courseFormSignatureDate,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.inkSubtle,
          ),
        ),
      ],
    );
  }
}
