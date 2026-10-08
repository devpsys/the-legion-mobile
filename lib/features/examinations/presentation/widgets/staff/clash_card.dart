import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../models/staff/exam_office_models.dart';

/// A student with two papers at the same time, and a way to the paper to move.
class ClashCard extends StatelessWidget {
  const ClashCard({required this.session, required this.clash, super.key});

  final ExamSession session;
  final ExamClash clash;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final paper = session.paperForCourse(clash.secondCourse);
    final danger = AppTone.danger.foreground(theme.brightness);

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: danger),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.examOfficeClashTitle(
                    clash.firstCourse,
                    clash.secondCourse,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.examOfficeClashBody(clash.matric),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (paper != null)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => context.goNamed(
                  Routes.examOfficePaperName,
                  pathParameters: {
                    Routes.examOfficeSessionIdParam: session.id,
                    Routes.examOfficePaperIdParam: paper.id,
                  },
                ),
                child: Text(l10n.examOfficeClashResolve(clash.secondCourse)),
              ),
            ),
        ],
      ),
    );
  }
}
