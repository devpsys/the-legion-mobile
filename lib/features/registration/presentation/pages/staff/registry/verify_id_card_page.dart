import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/router/route_names.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../../../../core/widgets/brand_block.dart';
import '../../../../../../core/widgets/surface_card.dart';
import '../../../bloc/staff/id_card_verification_cubit.dart';
import '../../../models/staff/registry_models.dart';
import '../../../widgets/staff/registry/id_card_verification_result_card.dart';
import '../../../widgets/staff/registry/verify_id_card_code_field.dart';

/// Public check of a student ID card.
///
/// Outside every shell: no session, no tab bar, no bell. A valid card shows
/// five facts — never a photo, a contact detail or a fee balance.
class VerifyIdCardPage extends StatefulWidget {
  const VerifyIdCardPage({this.initialCode, super.key});

  final String? initialCode;

  @override
  VerifyIdCardPageState createState() => VerifyIdCardPageState();
}

/// State of [VerifyIdCardPage].
class VerifyIdCardPageState extends State<VerifyIdCardPage> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    final initialCode = normaliseIdCardVerificationCode(
      widget.initialCode ?? '',
    );
    _codeController = TextEditingController(text: initialCode);
    if (initialCode.isNotEmpty) {
      context.read<IdCardVerificationCubit>().verifyCode(initialCode);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() {
    FocusScope.of(context).unfocus();
    context.read<IdCardVerificationCubit>().verify();
  }

  void _toSignIn() => context.goNamed(Routes.loginName);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final cubit = context.read<IdCardVerificationCubit>();

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
                        IdCardVerificationCubit,
                        IdCardVerificationState
                      >(
                        builder: (context, state) {
                          final isComplete =
                              normaliseIdCardVerificationCode(state.code)
                                  .length ==
                              idCardVerificationCodeLength;
                          final checked =
                              state.result.outcome !=
                              IdCardVerificationOutcome.idle;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              BrandBlock(caption: l10n.verifyIdCardBrandCaption),
                              AppSpacing.verticalGap(AppSpacing.sm),
                              Text(
                                l10n.verifyIdCardOffice,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.xl),
                              Text(
                                l10n.verifyIdCardTitle,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.xs),
                              Text(
                                l10n.verifyIdCardSubtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: AppTextStyles.relaxedLineHeight,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.xl),
                              VerifyIdCardCodeField(
                                controller: _codeController,
                                isComplete: isComplete,
                                enabled: true,
                                onChanged: cubit.setCode,
                                onSubmitted: (_) {
                                  if (isComplete) _verify();
                                },
                              ),
                              AppSpacing.verticalGap(AppSpacing.md),
                              FilledButton.icon(
                                onPressed: isComplete ? _verify : null,
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
                                label: Text(l10n.verifyIdCardAction),
                              ),
                              if (checked) ...[
                                AppSpacing.verticalGap(AppSpacing.xl),
                                IdCardVerificationResultCard(
                                  result: state.result,
                                ),
                              ],
                              AppSpacing.verticalGap(AppSpacing.xl),
                              SurfaceCard(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      l10n.verifyIdCardPrivacyTitle,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: AppTextStyles.bold,
                                          ),
                                    ),
                                    AppSpacing.verticalGap(AppSpacing.sm),
                                    Text(
                                      l10n.verifyIdCardPrivacyBody,
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
                                label: Text(l10n.verifyIdCardSignIn),
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
