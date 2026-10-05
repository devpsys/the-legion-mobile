import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../bloc/registration_state.dart';
import 'course_form_document.dart';

/// Body of the Form tab: the official document, or an empty state.
class CourseFormBody extends StatelessWidget {
  const CourseFormBody({required this.state, super.key});

  final RegistrationState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final student = state.student;
    final window = state.window;
    final form = state.latestForm;

    if (student == null || window == null || form == null) {
      return Center(
        child: ResponsiveContent(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: AppDimensions.iconLarge,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                Text(
                  l10n.courseFormEmptyTitle,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(
                  l10n.courseFormEmptyBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalGap(AppSpacing.xl),
                FilledButton(
                  onPressed: () => context.goNamed(Routes.registrationName),
                  child: Text(l10n.navRegistration),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final versionLine = l10n.courseFormVersionLine(
      AppDateFormats.medium(l10n.localeName).format(form.submittedOn),
      form.versionLabel,
    );

    return SingleChildScrollView(
      child: ResponsiveContent(
        maxWidth: AppDimensions.maxContentWidth,
        // Tighter than the default canvas gutter so modular pods can breathe.
        padding: EdgeInsets.symmetric(
          horizontal: context.isCompact ? AppSpacing.sm : AppSpacing.md,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CourseFormActionBar(
                versionLine: versionLine,
                onSavePdf: () =>
                    context.showMessage(context.l10n.commonComingSoon),
                onShare: () =>
                    context.showMessage(context.l10n.commonComingSoon),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              CourseFormDocument(student: student, window: window, form: form),
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.courseFormPresentHint,
                textAlign: TextAlign.center,
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact utility bar above the document sheet (title, version, Save PDF).
class CourseFormActionBar extends StatelessWidget {
  const CourseFormActionBar({
    required this.versionLine,
    required this.onSavePdf,
    required this.onShare,
    super.key,
  });

  final String versionLine;
  final VoidCallback onSavePdf;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: AppRadii.blockRadius,
        border: Border.all(
          color: AppColors.stroke(theme.brightness).withValues(alpha: 0.8),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.courseFormShortTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  versionLine,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onSavePdf,
            icon: Icon(Icons.print_outlined, size: AppDimensions.iconSmall),
            label: Text(l10n.courseFormSavePdf),
            style: FilledButton.styleFrom(
              // Compact bar control — taller than a chip, softer than CTA radius.
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.lg,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.tagRadius,
              ),
              textStyle: AppTextStyles.codeSmall.copyWith(
                fontWeight: AppTextStyles.semiBold,
                color: theme.colorScheme.onPrimary,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.xs),
          IconButton(
            onPressed: onShare,
            tooltip: l10n.courseFormShare,
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.share_outlined, size: AppDimensions.iconDense),
          ),
        ],
      ),
    );
  }
}
