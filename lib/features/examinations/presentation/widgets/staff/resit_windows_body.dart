import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/responsive.dart';
import '../../bloc/staff/exam_office_state.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_empty_card.dart';
import 'resit_signup_tile.dart';
import 'resit_window_tile.dart';

/// The resit windows, open and closed, and the registrations in the open one.
class ResitWindowsBody extends StatelessWidget {
  const ResitWindowsBody({required this.state, super.key});

  final ExamOfficeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final open = state.windows.where((window) => window.isOpen).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: AppDimensions.primaryActionHeight,
          child: FilledButton(
            onPressed: () => context.goNamed(Routes.examOfficeResitsOpenName),
            child: Text(l10n.examOfficeWindowOpenAction),
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        if (state.windows.isEmpty)
          ExamOfficeEmptyCard(
            icon: Icons.event_repeat_outlined,
            title: l10n.examOfficeWindowsEmptyTitle,
            body: l10n.examOfficeWindowsEmptyBody,
          )
        else
          for (final window in state.windows) ...[
            ResitWindowTile(window: window),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
        for (final ResitWindow window in open) ...[
          if (window.signups.isNotEmpty) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              l10n.examOfficeSignupsHeading(window.name),
              style: theme.textTheme.titleMedium,
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            for (final signup in window.signups) ...[
              ResitSignupTile(window: window, signup: signup),
              AppSpacing.verticalGap(AppSpacing.sm),
            ],
          ],
        ],
      ],
    );
  }
}
