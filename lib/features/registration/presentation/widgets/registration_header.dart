import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../models/registration_models.dart';
import 'registration_card.dart';
import 'registration_labels.dart';

/// Tabbed-ledger header: breadcrumb, title, formal student docket.
class RegistrationHeader extends StatelessWidget {
  const RegistrationHeader({
    required this.student,
    required this.window,
    super.key,
  });

  final RegistrationStudent student;
  final RegistrationWindow window;

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
            Flexible(
              child: Text(
                l10n.registrationTitle,
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
        Text(l10n.registrationTitle, style: theme.textTheme.headlineMedium),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          l10n.registrationSessionHeadline(window.session, window.termLabel),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        RegistrationStudentDocket(student: student, window: window),
      ],
    );
  }
}

/// Formal identity card with window status and schedule strip.
class RegistrationStudentDocket extends StatelessWidget {
  const RegistrationStudentDocket({
    required this.student,
    required this.window,
    super.key,
  });

  final RegistrationStudent student;
  final RegistrationWindow window;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh.withValues(
                alpha: 0.3,
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimensions.avatarSmall,
                  height: AppDimensions.avatarSmall,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: AppRadii.elementRadius,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Icon(
                    Icons.badge_outlined,
                    size: AppDimensions.iconDense,
                    color: theme.colorScheme.primary,
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              student.name,
                              style: AppTextStyles.codeMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          AppSpacing.horizontalGap(AppSpacing.sm),
                          RegistrationWindowPill(
                            label: RegistrationLabels.windowState(
                              l10n,
                              window,
                            ),
                            tone: window.state.tone,
                          ),
                        ],
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        student.programme,
                        style: AppTextStyles.codeSmall.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        l10n.registrationMatricBulletLevel(
                          l10n.registrationLevel(student.level),
                          student.matricNumber,
                        ),
                        style: AppTextStyles.codeSmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.event_note_outlined,
                  size: AppDimensions.iconDense,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    window.scheduleLine,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: AppTextStyles.relaxedLineHeight,
                    ),
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

/// Window status pill with a tone-coloured leading pip.
class RegistrationWindowPill extends StatelessWidget {
  const RegistrationWindowPill({
    required this.label,
    required this.tone,
    super.key,
  });

  final String label;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final brightness = theme.brightness;
    final foreground = tone.foreground(brightness);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tone.surface(brightness),
        borderRadius: AppRadii.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.indicator,
            height: AppDimensions.indicator,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.codeSmall.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
