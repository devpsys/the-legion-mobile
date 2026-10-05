import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/registration_state.dart';
import 'registered_course_card.dart';

/// Tabbed-ledger "Your Courses" table plus the units-minimum callout.
class RegisteredCoursesSection extends StatelessWidget {
  const RegisteredCoursesSection({
    required this.state,
    required this.onDrop,
    required this.onReadd,
    super.key,
  });

  final RegistrationState state;
  final ValueChanged<String> onDrop;
  final ValueChanged<String> onReadd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final courses = state.courses;
    final showMinimumWarning =
        state.meetsMinimum && state.registeredUnits == state.minimumUnits;
    final showBelowMinimum = !state.meetsMinimum && state.courses.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      l10n.registrationYourCoursesTitle.toUpperCase(),
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: AppTextStyles.trackingCaps,
                        fontWeight: AppTextStyles.semiBold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: AppRadii.tagRadius,
                    ),
                    child: Text(
                      l10n.registrationCoursesTotal(courses.length),
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.sm),
            Text(
              l10n.registrationStandardLoad(
                state.maximumUnits,
                state.minimumUnits,
              ),
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        if (courses.isEmpty)
          SurfaceCard(
            borderRadius: AppRadii.blockRadius,
            child: Column(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: AppDimensions.iconLarge,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                Text(
                  l10n.registrationEmptyCoursesTitle,
                  style: theme.textTheme.titleMedium,
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.registrationEmptyCoursesBody,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: AppRadii.blockRadius,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  color: theme.colorScheme.surfaceContainerHigh.withValues(
                    alpha: 0.6,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text(
                          l10n.registrationLedgerCourseTitle.toUpperCase(),
                          style: AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            letterSpacing: AppTextStyles.trackingCaps,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.registrationLedgerUnits.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            letterSpacing: AppTextStyles.trackingCaps,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.registrationLedgerAction.toUpperCase(),
                          textAlign: TextAlign.right,
                          style: AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            letterSpacing: AppTextStyles.trackingCaps,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                for (var i = 0; i < courses.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  RegisteredCourseCard(
                    course: courses[i],
                    onDrop: () => onDrop(courses[i].id),
                    onReadd: () => onReadd(courses[i].id),
                  ),
                ],
              ],
            ),
          ),
        if (showMinimumWarning) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          ToneCallout(
            tone: AppTone.warning,
            icon: Icons.warning_amber_outlined,
            title: l10n.registrationCountingUnitsTitle(state.registeredUnits),
            body: l10n.registrationCountingUnitsBody(state.minimumUnits),
          ),
        ] else if (showBelowMinimum) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          ToneCallout(
            tone: AppTone.warning,
            icon: Icons.warning_amber_outlined,
            body: l10n.registrationMinUnitsNote(state.minimumUnits),
          ),
        ],
      ],
    );
  }
}
