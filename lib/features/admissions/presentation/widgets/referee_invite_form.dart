import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// The inline form that invites the second referee.
///
/// Its own bordered block inside the card, because the design keeps the
/// invitation beside the list it feeds: a candidate who has just read
/// "1 of 2 invited" should be able to make it 2 without leaving the screen.
class RefereeInviteForm extends StatefulWidget {
  const RefereeInviteForm({required this.onSend, super.key});

  /// Runs when all four fields validate.
  ///
  /// The body reports that the invitation service is not live yet: the form
  /// is real, the send is not, and saying so is honest in a way a silently
  /// discarded invitation would not be.
  final VoidCallback onSend;

  @override
  RefereeInviteFormState createState() => RefereeInviteFormState();
}

/// State of [RefereeInviteForm].
///
/// Public because private widget classes are banned — and because the form's
/// only state is which fields have been judged, which is worth reading from a
/// test rather than inferring from pixels.
class RefereeInviteFormState extends State<RefereeInviteForm> {
  /// One key for all four fields: a send either validates the invitation or
  /// none of it, because half an invitation is not a thing.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleSend() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSend();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.admissionsRefereeInviteTitle,
              style: theme.textTheme.titleMedium,
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              l10n.admissionsRefereeInviteSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            _pair(
              _field(
                label: l10n.admissionsRefereeNameLabel,
                hint: l10n.admissionsRefereeNameHint,
                isRequired: true,
              ),
              _field(
                label: l10n.admissionsRefereeEmailLabel,
                hint: l10n.admissionsRefereeEmailHint,
                isRequired: true,
                isEmail: true,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            _pair(
              _field(
                label: l10n.admissionsRefereePhoneLabel,
                hint: l10n.admissionsRefereePhoneHint,
                keyboardType: TextInputType.phone,
              ),
              _field(
                label: l10n.admissionsRefereeOccupationLabel,
                hint: l10n.admissionsRefereeOccupationHint,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            FilledButton(
              onPressed: _handleSend,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, AppDimensions.buttonHeight),
              ),
              child: Text(l10n.admissionsRefereeSend),
            ),
          ],
        ),
      ),
    );
  }

  /// Two fields side by side from the tablet breakpoint up, stacked under it —
  /// the design's `sm:grid-cols-2`, which is this app's compact/medium split.
  Widget _pair(Widget first, Widget second) {
    if (context.isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [first, AppSpacing.verticalGap(AppSpacing.lg), second],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        AppSpacing.horizontalGap(AppSpacing.lg),
        Expanded(child: second),
      ],
    );
  }

  /// One labelled field. Validation runs on submit rather than per keystroke:
  /// a candidate who has not finished typing a name should not be told the
  /// name is missing.
  Widget _field({
    required String label,
    required String hint,
    bool isRequired = false,
    bool isEmail = false,
    TextInputType? keyboardType,
  }) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        AppSpacing.verticalGap(AppSpacing.xs),
        TextFormField(
          keyboardType: keyboardType,
          validator: (value) {
            final text = (value ?? '').trim();
            if (text.isEmpty) {
              return isRequired ? l10n.validationRequired : null;
            }
            if (isEmail && !text.isValidEmail) {
              return l10n.validationInvalidEmail;
            }
            return null;
          },
          decoration: InputDecoration(hintText: hint, isDense: true),
        ),
      ],
    );
  }
}
