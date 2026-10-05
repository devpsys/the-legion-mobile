import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/registration_state.dart';
import '../models/registration_models.dart';
import 'registration_card.dart';
import 'registration_labels.dart';

/// Three-column micro-dashboard from the tabbed-ledger layout.
class RegistrationDeck extends StatelessWidget {
  const RegistrationDeck({required this.state, super.key});

  final RegistrationState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final brightness = theme.brightness;
    final formSubmitted = state.formStatus == CourseFormStatus.submitted;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _MetricTile(
              label: l10n.registrationUnitsLabel,
              trailing: _UnitsRing(brightness: brightness),
              value: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${state.registeredUnits}',
                      style: AppTextStyles.codeLarge.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    TextSpan(
                      text: ' / ${state.maximumUnits}',
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              hint: l10n.registrationUnitsDegreePlan(state.minimumUnits),
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: _MetricTile(
              label: l10n.registrationApprovalLabel,
              trailing: Container(
                width: AppDimensions.iconDense,
                height: AppDimensions.iconDense,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTone.warning.surface(brightness),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${state.pendingCount}',
                  style: AppTextStyles.codeSmall.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppTone.warning.foreground(brightness),
                  ),
                ),
              ),
              value: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${state.pendingCount}',
                      style: AppTextStyles.codeLarge.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppTone.warning.foreground(brightness),
                      ),
                    ),
                    TextSpan(
                      text: ' ${l10n.registrationPendingCoursesHint}',
                      style: AppTextStyles.codeSmall.copyWith(
                        color: AppTone.warning.foreground(brightness),
                      ),
                    ),
                  ],
                ),
              ),
              hint: l10n.registrationApprovalHint,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: _MetricTile(
              label: l10n.registrationFormShortLabel,
              trailing: Icon(
                formSubmitted
                    ? Icons.check_circle_outline
                    : Icons.pending_actions_outlined,
                size: AppDimensions.iconSmall,
                color: AppTone.success.foreground(brightness),
              ),
              value: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppTone.success.surface(brightness),
                  borderRadius: AppRadii.tagRadius,
                ),
                child: Text(
                  RegistrationLabels.formStatus(l10n, state.formStatus),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppTone.success.foreground(brightness),
                  ),
                ),
              ),
              hint: formSubmitted
                  ? l10n.registrationFormSubmittedHint
                  : l10n.registrationFormPendingSubmit,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitsRing extends StatelessWidget {
  const _UnitsRing({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final success = AppTone.success.foreground(brightness);

    return SizedBox(
      width: AppDimensions.iconDense,
      height: AppDimensions.iconDense,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 0.75,
            strokeWidth: 2,
            backgroundColor: theme.colorScheme.outlineVariant,
            color: success,
          ),
          Container(
            width: AppDimensions.indicator,
            height: AppDimensions.indicator,
            decoration: BoxDecoration(color: success, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.trailing,
    required this.value,
    required this.hint,
  });

  final String label;
  final Widget trailing;
  final Widget value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return RegistrationCard(
      clip: false,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              trailing,
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          value,
          const Spacer(),
          Text(
            hint,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
