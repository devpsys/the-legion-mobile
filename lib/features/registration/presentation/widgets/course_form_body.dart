import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
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

    return SingleChildScrollView(
      child: ResponsiveContent(
        maxWidth: AppDimensions.maxContentWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.courseFormTitle(form.versionLabel),
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  CourseFormSavePdfButton(
                    compact: context.isCompact,
                    onPressed: () =>
                        context.showMessage(context.l10n.commonComingSoon),
                  ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              CourseFormDocument(student: student, window: window, form: form),
            ],
          ),
        ),
      ),
    );
  }
}

/// Save PDF control: icon-only on phones, labelled from medium upward.
class CourseFormSavePdfButton extends StatelessWidget {
  const CourseFormSavePdfButton({
    required this.compact,
    required this.onPressed,
    super.key,
  });

  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (compact) {
      return IconButton(
        onPressed: onPressed,
        tooltip: l10n.courseFormSavePdf,
        icon: const Icon(Icons.picture_as_pdf_outlined),
      );
    }

    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.picture_as_pdf_outlined),
      label: Text(l10n.courseFormSavePdf),
    );
  }
}
