import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../bloc/examinations_cubit.dart';
import '../bloc/examinations_state.dart';

/// Tells the student the outcome of what they just did, once, then clears it.
class ExaminationsNoticeListener extends StatelessWidget {
  const ExaminationsNoticeListener({required this.child, super.key});

  final Widget child;

  /// The sentence that reports [notice].
  static String message(AppLocalizations l10n, ExaminationsNotice notice) {
    return switch (notice) {
      ExaminationsNotice.resitRegistered => l10n.examNoticeResitRegistered,
      ExaminationsNotice.resitWindowClosed => l10n.examNoticeResitClosed,
      ExaminationsNotice.resitOverBudget => l10n.examNoticeResitOverBudget,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExaminationsCubit, ExaminationsState>(
      listenWhen: (previous, current) =>
          previous.notice != current.notice && current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        final text = message(context.l10n, notice);
        if (notice == ExaminationsNotice.resitRegistered) {
          context.showMessage(text);
        } else {
          context.showErrorMessage(text);
        }
        context.read<ExaminationsCubit>().clearNotice();
      },
      child: child,
    );
  }
}
