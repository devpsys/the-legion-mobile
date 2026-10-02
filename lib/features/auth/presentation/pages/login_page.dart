import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../bloc/auth_cubit.dart';
import '../widgets/audit_protocol_notice.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header_banner.dart';
import '../widgets/credential_card.dart';
import '../widgets/rate_limit/lockout_notice_card.dart';
import '../widgets/rate_limit/rate_limit_banner.dart';
import '../widgets/secondary_action_deck.dart';

/// Sign-in screen.
///
/// Layout follows
/// `ui-designs/auth/_variants/sign_in_standard__sign_in_integrated_header_action_deck_layout/code.html`:
/// institutional header banner, credential deck, secondary action deck and the
/// statutory notice, with the footer docked to the bottom.
///
/// The page is purely compositional — it reads [AuthCubit] and forwards user
/// input. No validation logic and no repository call live here.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  /// Presentation-only until the API defines the session policy.
  bool _keepSignedIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    _passwordFocus.unfocus();
    context.read<AuthCubit>().signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  /// Destinations that ship with a later release.
  void _notAvailable() {
    context.showMessage(context.l10n.commonComingSoon);
  }

  @override
  Widget build(BuildContext context) {
    // Granular selectors: the countdown ticks every second without rebuilding
    // the rest of the page.
    final isLocked = context.select<AuthCubit, bool>(
      (cubit) => cubit.state.isRateLimited,
    );
    final cooldown = context.select<AuthCubit, Duration>(
      (cubit) => cubit.state.cooldownRemaining,
    );

    return Scaffold(
      body: SafeArea(
        // The banner and footer stay docked; only the credential content
        // scrolls, so the institutional identity remains visible at every
        // screen size and with the software keyboard open.
        child: Column(
          children: [
            const AuthHeaderBanner(),
            Expanded(
              child: SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide =
                        constraints.maxWidth >=
                        AppDimensions.expandedBreakpoint;

                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: AppDimensions.maxFormWidth,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.canvasGutter,
                            vertical: isWide ? AppSpacing.xxl : AppSpacing.lg,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (isLocked) ...[
                                RateLimitAlertBanner(remaining: cooldown),
                                AppSpacing.verticalGap(AppSpacing.md),
                              ],
                              CredentialCard(
                                emailController: _emailController,
                                passwordController: _passwordController,
                                passwordFocus: _passwordFocus,
                                onSubmit: _submit,
                                keepSignedIn: _keepSignedIn,
                                onKeepSignedInChanged: (value) =>
                                    setState(() => _keepSignedIn = value),
                                onForgotPassword: () =>
                                    context.goNamed(Routes.forgotPasswordName),
                                cooldownRemaining: isLocked ? cooldown : null,
                              ),
                              AppSpacing.verticalGap(AppSpacing.lg),
                              if (isLocked)
                                LockoutNoticeCard(
                                  onContactRegistry: _notAvailable,
                                  onCallRegistry: _notAvailable,
                                )
                              else
                                SecondaryActionDeck(
                                  createAccountLabel:
                                      context.l10n.loginActionCreateAccount,
                                  verifyLetterLabel:
                                      context.l10n.loginActionVerifyLetter,
                                  onCreateAccount: _notAvailable,
                                  onVerifyLetter: _notAvailable,
                                ),
                              AppSpacing.verticalGap(AppSpacing.md),
                              const AuditProtocolNotice(),
                              AppSpacing.verticalGap(AppSpacing.lg),
                              AuthFooter(language: AuthFooter.languages.first),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
