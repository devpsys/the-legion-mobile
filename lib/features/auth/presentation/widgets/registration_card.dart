import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_localization.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/validation.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import 'auth_inputs.dart';
import 'credential_card.dart';
import 'field_compartment.dart';

/// The controllers behind the registration form, in the order its fields
/// are shown.
///
/// Owned by the page, which creates and disposes them; the card only reads.
class RegistrationControllers {
  RegistrationControllers();

  final firstName = TextEditingController();
  final surname = TextEditingController();
  final otherNames = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  /// Focus for every field after the first, so "next" on the keyboard walks
  /// the form in order.
  final surnameFocus = FocusNode();
  final otherNamesFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  void dispose() {
    for (final controller in [
      firstName,
      surname,
      otherNames,
      email,
      phone,
      password,
      confirmPassword,
    ]) {
      controller.dispose();
    }
    for (final node in [
      surnameFocus,
      otherNamesFocus,
      emailFocus,
      phoneFocus,
      passwordFocus,
      confirmPasswordFocus,
    ]) {
      node.dispose();
    }
  }
}

/// The registration deck: the applicant's details in the design's order,
/// and the one action.
///
/// Built from the same parts as the sign-in deck — the tinted card header,
/// the labelled field compartments, the primary action with its arrow — so
/// the two doors into the app look like doors into the same building. Reads
/// [AuthState] only; validation arrives from the domain as a failure naming
/// its field and is routed to that field's compartment.
class RegistrationCard extends StatelessWidget {
  const RegistrationCard({
    required this.controllers,
    required this.onSubmit,
    required this.onSignIn,
    super.key,
  });

  final RegistrationControllers controllers;
  final VoidCallback onSubmit;

  /// For the applicant who already has an account.
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardHeader(
            title: l10n.createAccountTitle,
            subtitle: l10n.createAccountSubtitle,
            icon: Icons.person_add_alt_outlined,
          ),
          Padding(
            padding: AppSpacing.card,
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final failure = state.failure;
                final isBusy = state.status == AuthStatus.registering;
                final c = controllers;

                String? errorFor(ValidationField field) =>
                    _errorFor(failure, l10n, field);

                final emailError = errorFor(ValidationField.email);
                final passwordError = errorFor(ValidationField.password);
                // A failure that names no field is shown once, under the form.
                final isFieldFailure =
                    failure is ValidationFailure &&
                    failure.field != ValidationField.generic;

                return AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FieldCompartment(
                        label: l10n.createAccountFirstName,
                        isRequired: true,
                        helper: errorFor(ValidationField.firstName),
                        isError: true,
                        child: TextInputField(
                          controller: c.firstName,
                          hint: l10n.createAccountFirstNameHint,
                          enabled: !isBusy,
                          autofillHints: const [AutofillHints.givenName],
                          onSubmitted: (_) => c.surnameFocus.requestFocus(),
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.md),
                      FieldCompartment(
                        label: l10n.createAccountSurname,
                        isRequired: true,
                        helper: errorFor(ValidationField.surname),
                        isError: true,
                        child: TextInputField(
                          controller: c.surname,
                          focusNode: c.surnameFocus,
                          hint: l10n.createAccountSurnameHint,
                          enabled: !isBusy,
                          autofillHints: const [AutofillHints.familyName],
                          onSubmitted: (_) => c.otherNamesFocus.requestFocus(),
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.md),
                      FieldCompartment(
                        label: l10n.createAccountOptionalLabel(
                          l10n.createAccountOtherNames,
                        ),
                        child: TextInputField(
                          controller: c.otherNames,
                          focusNode: c.otherNamesFocus,
                          hint: l10n.createAccountOtherNamesHint,
                          enabled: !isBusy,
                          autofillHints: const [AutofillHints.middleName],
                          onSubmitted: (_) => c.emailFocus.requestFocus(),
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.md),
                      FieldCompartment(
                        label: l10n.createAccountEmail,
                        isRequired: true,
                        helper: emailError ?? l10n.createAccountEmailHelper,
                        isError: emailError != null,
                        child: EmailTextField(
                          controller: c.email,
                          focusNode: c.emailFocus,
                          hint: l10n.createAccountEmailHint,
                          enabled: !isBusy,
                          onSubmitted: (_) => c.phoneFocus.requestFocus(),
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.md),
                      FieldCompartment(
                        label: l10n.createAccountOptionalLabel(
                          l10n.createAccountPhone,
                        ),
                        helper: errorFor(ValidationField.phone),
                        isError: true,
                        child: TextInputField(
                          controller: c.phone,
                          focusNode: c.phoneFocus,
                          hint: l10n.createAccountPhoneHint,
                          enabled: !isBusy,
                          keyboardType: TextInputType.phone,
                          textCapitalization: TextCapitalization.none,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          onSubmitted: (_) => c.passwordFocus.requestFocus(),
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.md),
                      FieldCompartment(
                        label: l10n.createAccountPassword,
                        isRequired: true,
                        helper:
                            passwordError ?? l10n.createAccountPasswordHelper,
                        isError: passwordError != null,
                        child: PasswordTextField(
                          controller: c.password,
                          focusNode: c.passwordFocus,
                          hint: l10n.createAccountPasswordHint,
                          enabled: !isBusy,
                          isNewPassword: true,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              c.confirmPasswordFocus.requestFocus(),
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.md),
                      FieldCompartment(
                        label: l10n.createAccountConfirmPassword,
                        isRequired: true,
                        helper: errorFor(ValidationField.confirmPassword),
                        isError: true,
                        child: PasswordTextField(
                          controller: c.confirmPassword,
                          focusNode: c.confirmPasswordFocus,
                          hint: l10n.createAccountConfirmPasswordHint,
                          enabled: !isBusy,
                          isNewPassword: true,
                          onSubmitted: (_) => onSubmit(),
                        ),
                      ),
                      if (failure != null && !isFieldFailure) ...[
                        AppSpacing.verticalGap(AppSpacing.md),
                        FailureBanner(message: failure.localize(l10n)),
                      ],
                      AppSpacing.verticalGap(AppSpacing.sm),
                      SubmitButton(
                        label: l10n.createAccountSubmit,
                        busyLabel: l10n.createAccountSubmitting,
                        isBusy: isBusy,
                        onPressed: onSubmit,
                      ),
                      AppSpacing.verticalGap(AppSpacing.sm),
                      SignInPrompt(onSignIn: onSignIn),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Renders a validation failure only under the field it belongs to.
  String? _errorFor(
    Failure? failure,
    AppLocalizations l10n,
    ValidationField field,
  ) {
    if (failure is! ValidationFailure || failure.field != field) return null;
    return failure.localize(l10n);
  }
}

/// "Already have an account? Sign in", centred under the action.
class SignInPrompt extends StatelessWidget {
  const SignInPrompt({required this.onSignIn, super.key});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          l10n.createAccountHaveAccount,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: onSignIn,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            minimumSize: const Size(0, AppDimensions.minTapTarget),
          ),
          child: Text(l10n.createAccountSignIn),
        ),
      ],
    );
  }
}
