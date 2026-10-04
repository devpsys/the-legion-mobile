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
import '../../../../core/widgets/surface_card.dart';
import '../bloc/receipt_verification_cubit.dart';
import '../bloc/receipt_verification_state.dart';
import '../models/fees_models.dart';
import '../widgets/receipt_verification_code_field.dart';
import '../widgets/receipt_verification_result_card.dart';

/// Public check of a bursary receipt.
///
/// Outside every shell: no session, no tab bar, no bell. Shows only the five
/// facts the fees README allows — never a matric or a contact detail.
class VerifyReceiptPage extends StatefulWidget {
  const VerifyReceiptPage({this.initialCode, super.key});

  final String? initialCode;

  @override
  VerifyReceiptPageState createState() => VerifyReceiptPageState();
}

/// State of [VerifyReceiptPage].
class VerifyReceiptPageState extends State<VerifyReceiptPage> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    final initialCode = widget.initialCode?.trim() ?? '';
    _codeController = TextEditingController(
      text: initialCode.isEmpty
          ? ''
          : formatReceiptVerificationCode(initialCode),
    );
    if (initialCode.isNotEmpty) {
      context.read<ReceiptVerificationCubit>().verifyCode(initialCode);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() {
    FocusScope.of(context).unfocus();
    context.read<ReceiptVerificationCubit>().verify();
  }

  void _toSignIn() => context.goNamed(Routes.loginName);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final cubit = context.read<ReceiptVerificationCubit>();

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
                        ReceiptVerificationCubit,
                        ReceiptVerificationState
                      >(
                        builder: (context, state) {
                          final isChecking =
                              state.status ==
                              ReceiptVerificationStatus.checking;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              BrandBlock(caption: l10n.feesVerifyBrandCaption),
                              AppSpacing.verticalGap(AppSpacing.sm),
                              Text(
                                l10n.feesVerifyOffice,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.xl),
                              Text(
                                l10n.feesVerifyTitle,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.xs),
                              Text(
                                l10n.feesVerifySubtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: AppTextStyles.relaxedLineHeight,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.xl),
                              ReceiptVerificationCodeField(
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
                                label: Text(l10n.feesVerifyAction),
                              ),
                              ...switch (state.status) {
                                ReceiptVerificationStatus.verified
                                    when state.result != null =>
                                  [
                                    AppSpacing.verticalGap(AppSpacing.xl),
                                    ReceiptVerificationResultCard(
                                      result: state.result!,
                                    ),
                                  ],
                                ReceiptVerificationStatus.notFound => [
                                  AppSpacing.verticalGap(AppSpacing.xl),
                                  const ReceiptVerificationNotFoundCard(),
                                ],
                                _ => const <Widget>[],
                              },
                              AppSpacing.verticalGap(AppSpacing.xl),
                              SurfaceCard(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      l10n.feesVerifyPrivacyTitle,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: AppTextStyles.bold,
                                          ),
                                    ),
                                    AppSpacing.verticalGap(AppSpacing.sm),
                                    Text(
                                      l10n.feesVerifyPrivacyBody,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                            height:
                                                AppTextStyles.relaxedLineHeight,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.sm),
                              TextButton.icon(
                                onPressed: _toSignIn,
                                icon: const Icon(
                                  Icons.chevron_right,
                                  size: AppDimensions.iconDense,
                                ),
                                label: Text(l10n.feesVerifySignIn),
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
