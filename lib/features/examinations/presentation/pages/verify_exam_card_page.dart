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
import '../bloc/exam_card_verification_cubit.dart';
import '../models/examinations_models.dart';
import '../widgets/exam_card_check_result_card.dart';
import '../widgets/exam_card_code_field.dart';

/// Public hall-door check of an examination card.
///
/// Outside every shell: no session, no tab bar, no bell. A valid card shows
/// five facts — never a photo, a contact detail or a fee balance.
class VerifyExamCardPage extends StatefulWidget {
  const VerifyExamCardPage({this.initialCode, super.key});

  final String? initialCode;

  @override
  VerifyExamCardPageState createState() => VerifyExamCardPageState();
}

/// State of [VerifyExamCardPage].
class VerifyExamCardPageState extends State<VerifyExamCardPage> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    final code = normaliseExamCardCode(widget.initialCode ?? '');
    _codeController = TextEditingController(text: code);
    if (code.isNotEmpty) {
      context.read<ExamCardVerificationCubit>().verify(code);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() {
    FocusScope.of(context).unfocus();
    context.read<ExamCardVerificationCubit>().verify();
  }

  void _toSignIn() => context.goNamed(Routes.loginName);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final cubit = context.read<ExamCardVerificationCubit>();

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
                        ExamCardVerificationCubit,
                        ExamCardVerificationState
                      >(
                        builder: (context, state) {
                          final isComplete =
                              state.code.length == examCardCodeLength;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              BrandBlock(caption: l10n.examVerifyBrandCaption),
                              AppSpacing.verticalGap(AppSpacing.xl),
                              Text(
                                l10n.examVerifyTitle,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.xs),
                              Text(
                                l10n.examVerifySubtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: AppTextStyles.relaxedLineHeight,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.xl),
                              ExamCardCodeField(
                                controller: _codeController,
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
                                label: Text(l10n.examVerifyAction),
                              ),
                              if (state.result.status !=
                                  ExamCardCheckStatus.idle) ...[
                                AppSpacing.verticalGap(AppSpacing.xl),
                                ExamCardCheckResultCard(result: state.result),
                              ],
                              AppSpacing.verticalGap(AppSpacing.xl),
                              SurfaceCard(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      l10n.examVerifyPrivacyTitle,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: AppTextStyles.bold,
                                          ),
                                    ),
                                    AppSpacing.verticalGap(AppSpacing.sm),
                                    Text(
                                      l10n.examVerifyPrivacyBody,
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
                                label: Text(l10n.examVerifySignIn),
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
