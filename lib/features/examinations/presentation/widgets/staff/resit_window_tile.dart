import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/money.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_labels.dart';

/// One resit window: its name, dates, fee, how many registered, and whether
/// it is open.
class ResitWindowTile extends StatelessWidget {
  const ResitWindowTile({required this.window, super.key});

  final ResitWindow window;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final cap = window.unitCap;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(window.name, style: theme.textTheme.titleMedium),
              ),
              StatusTag(
                label: window.isOpen
                    ? l10n.examOfficeWindowOpen
                    : l10n.examOfficeWindowClosed,
                tone: window.isOpen ? AppTone.success : AppTone.neutral,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.examOfficeSessionDates(
              ExamOfficeLabels.date(l10n, window.closesOn),
              ExamOfficeLabels.date(l10n, window.opensOn),
            ),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            l10n.examOfficeWindowFee(
              cap == null ? l10n.examOfficeWindowNoCap : '$cap',
              formatNaira(window.feePerUnitMinorUnits),
            ),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            l10n.examOfficeWindowRegistered(window.registeredCount),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
