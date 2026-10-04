import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/jamb_claim_state.dart';
import 'section_surface.dart';
import 'tone_callout.dart';
import 'verification_code_field.dart';

/// The text controllers behind [JambClaimForm], owned by the page so they
/// outlive rebuilds and are disposed with it.
class JambClaimControllers {
  JambClaimControllers();

  final registrationNumber = TextEditingController();
  final surname = TextEditingController();

  /// Display only: the date itself lives on the cubit, and this shows it.
  final dateOfBirth = TextEditingController();

  final surnameFocus = FocusNode();

  void dispose() {
    registrationNumber.dispose();
    surname.dispose();
    dateOfBirth.dispose();
    surnameFocus.dispose();
  }
}

/// The three facts CAPS is asked to match, and the caution under them.
///
/// The number is set in the mono face and forced to capitals, as on the slip
/// the candidate is copying it from; the tick in its suffix appears once it
/// has the right shape — a reading aid, not a verdict. The date is picked,
/// not typed: a candidate's own birthday is not something to mistype, and a
/// picker cannot produce the 31st of February.
class JambClaimForm extends StatelessWidget {
  const JambClaimForm({
    required this.controllers,
    required this.state,
    required this.onRegistrationNumberChanged,
    required this.onSurnameChanged,
    required this.onPickDateOfBirth,
    required this.onSubmit,
    super.key,
  });

  final JambClaimControllers controllers;
  final JambClaimState state;
  final ValueChanged<String> onRegistrationNumberChanged;
  final ValueChanged<String> onSurnameChanged;
  final VoidCallback onPickDateOfBirth;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final enabled = state.status != JambClaimStatus.matching;

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          JambFormField(
            label: l10n.admissionsJambRegistrationLabel,
            helper: l10n.admissionsJambRegistrationHelper,
            child: TextField(
              controller: controllers.registrationNumber,
              enabled: enabled,
              onChanged: onRegistrationNumberChanged,
              onSubmitted: (_) => controllers.surnameFocus.requestFocus(),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.characters,
              autocorrect: false,
              enableSuggestions: false,
              inputFormatters: const [UpperCaseTextFormatter()],
              style: AppTextStyles.codeLarge.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: AppTextStyles.semiBold,
                letterSpacing: AppTextStyles.trackingCode,
              ),
              decoration: InputDecoration(
                hintText: l10n.admissionsJambRegistrationHint,
                hintStyle: AppTextStyles.codeLarge.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: AppTextStyles.trackingCode,
                ),
                suffixIcon: state.isRegistrationNumberComplete
                    ? Icon(
                        Icons.check_circle,
                        size: AppDimensions.iconMedium,
                        color: AppTone.success.foreground(theme.brightness),
                      )
                    : null,
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          JambFormField(
            label: l10n.admissionsJambSurnameLabel,
            helper: l10n.admissionsJambSurnameHelper,
            child: TextField(
              controller: controllers.surname,
              focusNode: controllers.surnameFocus,
              enabled: enabled,
              onChanged: onSurnameChanged,
              // Done with the keyboard: on to the date if it is still
              // missing, otherwise straight to the match.
              onSubmitted: (_) =>
                  state.dateOfBirth == null ? onPickDateOfBirth() : onSubmit(),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.characters,
              autocorrect: false,
              enableSuggestions: false,
              inputFormatters: const [UpperCaseTextFormatter()],
              autofillHints: const [AutofillHints.familyName],
              decoration: InputDecoration(
                hintText: l10n.admissionsJambSurnameHint,
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          JambFormField(
            label: l10n.admissionsJambDateOfBirthLabel,
            helper: l10n.admissionsJambDateOfBirthHelper,
            child: TextField(
              controller: controllers.dateOfBirth,
              enabled: enabled,
              readOnly: true,
              onTap: onPickDateOfBirth,
              decoration: InputDecoration(
                hintText: l10n.admissionsJambDateOfBirthHint,
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  size: AppDimensions.iconMedium,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          ToneCallout(
            tone: AppTone.warning,
            icon: Icons.warning_rounded,
            body: l10n.admissionsJambPermanentWarning,
          ),
        ],
      ),
    );
  }
}

/// One labelled input of the claim form: a required label, the field, and
/// the sentence under it saying what the field is checked against.
///
/// Every field here is required, so the marker is not optional: a candidate
/// cannot be matched on two facts out of three.
class JambFormField extends StatelessWidget {
  const JambFormField({
    required this.label,
    required this.helper,
    required this.child,
    super.key,
  });

  final String label;
  final String helper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurface,
      fontWeight: AppTextStyles.semiBold,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: labelStyle,
            children: [
              const TextSpan(text: ' '),
              TextSpan(
                text: context.l10n.fieldRequiredMarker,
                style: labelStyle?.copyWith(color: theme.colorScheme.error),
              ),
            ],
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        child,
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          helper,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: AppTextStyles.regular,
            height: AppTextStyles.denseLineHeight,
          ),
        ),
      ],
    );
  }
}
