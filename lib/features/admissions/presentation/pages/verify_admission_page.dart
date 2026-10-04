import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/brand_block.dart';
import '../bloc/admission_verification_cubit.dart';
import '../bloc/admission_verification_state.dart';
import '../widgets/verification_code_field.dart';
import '../widgets/verification_result_card.dart';

/// Public check of an admission letter.
///
/// Design: `ui-designs/admissions/admissions_public_verification_v1_v2`.
///
/// For the person a letter is shown to — a landlord, an employer — not the
/// candidate. So: no app bar, no tabs, no bell, no session; the brand block
/// stands in for all of them. One field, one button, and an answer that
/// repeats what the paper says and nothing more. Back leaves for sign-in,
/// which is where the link that brought most visitors here lives.
class VerifyAdmissionPage extends StatefulWidget {
  const VerifyAdmissionPage({this.initialCode, super.key});

  /// A code that arrived in the link — what the letter's QR mark encodes —
  /// checked on arrival so a scan needs no typing.
  final String? initialCode;

  @override
  VerifyAdmissionPageState createState() => VerifyAdmissionPageState();
}

/// State of [VerifyAdmissionPage].
///
/// Public because private widget classes are banned.
class VerifyAdmissionPageState extends State<VerifyAdmissionPage> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    final initialCode = widget.initialCode?.trim() ?? '';
    _codeController = TextEditingController(text: initialCode.toUpperCase());
    if (initialCode.isNotEmpty) {
      context.read<AdmissionVerificationCubit>().verifyCode(initialCode);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() {
    FocusScope.of(context).unfocus();
    context.read<AdmissionVerificationCubit>().verify();
  }

  void _toSignIn() => context.goNamed(Routes.loginName);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final cubit = context.read<AdmissionVerificationCubit>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _toSignIn();
      },
      child: Scaffold(
        backgroundColor: AppColors.canvas(theme.brightness),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppDimensions.maxFormWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.canvasGutter,
                    vertical: AppSpacing.xxl,
                  ),
                  child:
                      BlocBuilder<
                        AdmissionVerificationCubit,
                        AdmissionVerificationState
                      >(
                        builder: (context, state) {
                          final isChecking =
                              state.status ==
                              AdmissionVerificationStatus.checking;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              BrandBlock(
                                caption: l10n.admissionsVerifyBrandCaption,
                              ),
                              AppSpacing.verticalGap(AppSpacing.xl),
                              Text(
                                l10n.admissionsVerifyTitle,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.xs),
                              Text(
                                l10n.admissionsVerifySubtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: AppTextStyles.relaxedLineHeight,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.xl),
                              VerificationCodeField(
                                controller: _codeController,
                                isComplete: state.isCodeComplete,
                                enabled: !isChecking,
                                onChanged: cubit.codeChanged,
                                onSubmitted: (_) => _verify(),
                              ),
                              AppSpacing.verticalGap(AppSpacing.md),
                              FilledButton.icon(
                                onPressed: state.canVerify ? _verify : null,
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(
                                    double.infinity,
                                    AppDimensions.primaryActionHeight,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.verified_user_outlined,
                                  size: AppDimensions.iconDense,
                                ),
                                label: Text(l10n.admissionsVerifyAction),
                              ),
                              ...switch (state.status) {
                                AdmissionVerificationStatus.verified
                                    when state.result != null =>
                                  [
                                    AppSpacing.verticalGap(AppSpacing.xl),
                                    VerificationResultCard(
                                      result: state.result!,
                                    ),
                                  ],
                                AdmissionVerificationStatus.notFound => [
                                  AppSpacing.verticalGap(AppSpacing.xl),
                                  const VerificationNotFoundCard(),
                                ],
                                _ => const <Widget>[],
                              },
                              AppSpacing.verticalGap(AppSpacing.xl),
                              Text(
                                l10n.admissionsVerifyPrivacyNote,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.sm),
                              TextButton.icon(
                                onPressed: _toSignIn,
                                icon: const Icon(
                                  Icons.chevron_right,
                                  size: AppDimensions.iconDense,
                                ),
                                label: Text(l10n.admissionsVerifySignIn),
                              ),
                            ],
                          );
                        },
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
