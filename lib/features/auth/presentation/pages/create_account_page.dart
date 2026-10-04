import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/brand_block.dart';
import '../bloc/auth_cubit.dart';
import '../widgets/auth_footer.dart';
import '../widgets/registration_card.dart';

/// Opening an applicant account.
///
/// Design: `ui-designs/auth/create_applicant_account/code.html`.
///
/// Composed from the same parts as sign-in — the card, its compartments, the
/// docked footer — under the brand block the public pages wear, because an
/// applicant arrives from outside the institution and the first thing they
/// should recognise is the institution. The page forwards input to
/// [AuthCubit] and reads it back; no validation and no repository call live
/// here. Success is a session, and the router's redirect takes it from there.
class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  CreateAccountPageState createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  final _controllers = RegistrationControllers();

  @override
  void initState() {
    super.initState();
    // Sign-in and registration share one state: a wrong password from the
    // screen before must not greet a blank form.
    context.read<AuthCubit>().clearFailure();
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final c = _controllers;
    context.read<AuthCubit>().register(
      firstName: c.firstName.text,
      surname: c.surname.text,
      otherNames: c.otherNames.text,
      email: c.email.text,
      phone: c.phone.text,
      password: c.password.text,
      confirmPassword: c.confirmPassword.text,
    );
  }

  /// Back to sign-in, leaving no registration failure behind for it.
  void _toSignIn() {
    context.read<AuthCubit>().clearFailure();
    context.goNamed(Routes.loginName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _toSignIn();
      },
      child: Scaffold(
        body: SafeArea(
          // The footer stays docked, as on sign-in; only the form scrolls.
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppDimensions.maxFormWidth,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.canvasGutter,
                          vertical: AppSpacing.sm,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: IconButton(
                                onPressed: _toSignIn,
                                tooltip: l10n.createAccountBackTooltip,
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ),
                            AppSpacing.verticalGap(AppSpacing.sm),
                            BrandBlock(
                              caption: l10n.createAccountBrandCaption,
                              isCentered: true,
                            ),
                            AppSpacing.verticalGap(AppSpacing.xl),
                            RegistrationCard(
                              controllers: _controllers,
                              onSubmit: _submit,
                              onSignIn: _toSignIn,
                            ),
                            AppSpacing.verticalGap(AppSpacing.lg),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AuthFooter(language: AuthFooter.languages.first),
            ],
          ),
        ),
      ),
    );
  }
}
