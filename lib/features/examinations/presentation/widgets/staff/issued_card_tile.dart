import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_reason_dialog.dart';

/// An examination card issued in a session, with the act of withdrawing it.
class IssuedCardTile extends StatelessWidget {
  const IssuedCardTile({required this.session, required this.card, super.key});

  final ExamSession session;
  final IssuedCard card;

  Future<void> _withdraw(BuildContext context) async {
    final l10n = context.l10n;
    final cubit = context.read<ExamOfficeCubit>();
    final reason = await ExamOfficeReasonDialog.show(
      context,
      title: l10n.examOfficeWithdrawTitle(card.name),
      body: l10n.examOfficeWithdrawBody,
      confirmLabel: l10n.examOfficeWithdrawConfirm,
    );
    if (reason == null) return;
    cubit.withdrawCard(session.id, card.matric, reason);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final reason = card.withdrawnReason;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                    Text(
                      l10n.examOfficeIssuedCardLine(
                        card.cardNumber,
                        card.matric,
                      ),
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              StatusTag(
                label: card.isWithdrawn
                    ? l10n.examOfficeCardWithdrawnTag
                    : l10n.examOfficeCardValidTag,
                tone: card.isWithdrawn ? AppTone.danger : AppTone.success,
              ),
            ],
          ),
          if (reason != null) ...[
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              l10n.examOfficeCardWithdrawnReason(reason),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ] else
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => _withdraw(context),
                child: Text(l10n.examOfficeWithdrawAction),
              ),
            ),
        ],
      ),
    );
  }
}
