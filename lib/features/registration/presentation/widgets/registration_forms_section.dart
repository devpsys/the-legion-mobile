import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/registration_models.dart';

/// Submitted course forms list, with a link into the Form tab.
class RegistrationFormsSection extends StatelessWidget {
  const RegistrationFormsSection({required this.forms, super.key});

  final List<CourseFormRecord> forms;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final dateFormat = AppDateFormats.medium(l10n.localeName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: l10n.registrationSubmittedForms),
        AppSpacing.verticalGap(AppSpacing.md),
        if (forms.isEmpty)
          SurfaceCard(
            borderRadius: AppRadii.blockRadius,
            child: Text(
              l10n.registrationNoForms,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          for (var i = 0; i < forms.length; i++) ...[
            if (i > 0) AppSpacing.verticalGap(AppSpacing.md),
            CourseFormRecordRow(
              title: l10n.registrationViewForm(forms[i].versionLabel),
              subtitle: dateFormat.format(forms[i].submittedOn),
              onTap: () => context.goNamed(Routes.registrationFormName),
            ),
          ],
        AppSpacing.verticalGap(AppSpacing.md),
        Text(
          l10n.registrationHelpLine,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// One submitted form row that opens the Form tab.
class CourseFormRecordRow extends StatelessWidget {
  const CourseFormRecordRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.blockRadius,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Icon(
                Icons.chevron_right,
                size: AppDimensions.iconMedium,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
