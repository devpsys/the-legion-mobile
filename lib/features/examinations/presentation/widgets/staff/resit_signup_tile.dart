import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/money.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_confirm_dialog.dart';

/// A student's resit registration, with the act of cancelling it.
class ResitSignupTile extends StatelessWidget {
  const ResitSignupTile({
    required this.window,
    required this.signup,
    super.key,
  });

  final ResitWindow window;
  final ResitSignup signup;

  Future<void> _cancel(BuildContext context) async {
    final l10n = context.l10n;
    final cubit = context.read<ExamOfficeCubit>();
    final confirmed = await confirmExamOfficeAction(
      context,
      title: l10n.examOfficeSignupCancelTitle(signup.matric),
      body: l10n.examOfficeSignupCancelBody,
      confirmLabel: l10n.examOfficeSignupCancelConfirm,
    );
    if (!confirmed) return;
    cubit.cancelResitRegistration(window.id, signup.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.examOfficeCourseLine(signup.courseCode, signup.title),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              StatusTag(
                label: signup.isAwaitingPayment
                    ? l10n.examOfficeSignupAwaiting
                    : l10n.examOfficeSignupPaid,
                tone: signup.isAwaitingPayment
                    ? AppTone.warning
                    : AppTone.success,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.examOfficeSignupLine(
              formatNaira(signup.feeMinorUnits),
              signup.matric,
              signup.units,
            ),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () => _cancel(context),
              child: Text(l10n.examOfficeSignupCancel),
            ),
          ),
        ],
      ),
    );
  }
}
