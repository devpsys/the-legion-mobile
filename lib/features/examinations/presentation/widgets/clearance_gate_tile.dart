import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/examinations_models.dart';
import 'examinations_labels.dart';

/// One step on the clearance pipeline: a numbered node, then the gate card.
class ClearanceGateTile extends StatelessWidget {
  const ClearanceGateTile({
    required this.position,
    required this.gate,
    this.note,
    this.noteAction,
    super.key,
  });

  final int position;
  final ClearanceGate gate;

  /// The sentence that says what is still outstanding. Omitted once the gate
  /// has passed.
  final String? note;

  /// A second line under [note], such as where to pay.
  final String? noteAction;

  /// What a student does about [id] when it is the one in the way.
  static String hint(AppLocalizations l10n, ClearanceGateId id) {
    return switch (id) {
      ClearanceGateId.fees => l10n.examGateFeesHint,
      ClearanceGateId.standing => l10n.examGateStandingHint,
      ClearanceGateId.papers => l10n.examGatePapersHint,
      ClearanceGateId.schedule => l10n.examGateScheduleHint,
      ClearanceGateId.seats => l10n.examGateSeatsHint,
    };
  }

  static String detail(AppLocalizations l10n, ClearanceGateId id) {
    return switch (id) {
      ClearanceGateId.fees => l10n.examGateFeesDetail,
      ClearanceGateId.standing => l10n.examGateStandingDetail,
      ClearanceGateId.papers => l10n.examGatePapersDetail,
      ClearanceGateId.schedule => l10n.examGateScheduleDetail,
      ClearanceGateId.seats => l10n.examGateSeatsDetail,
    };
  }

  static IconData iconFor(ClearanceGateId id) {
    return switch (id) {
      ClearanceGateId.fees => Icons.account_balance_wallet_outlined,
      ClearanceGateId.standing => Icons.person_off_outlined,
      ClearanceGateId.papers => Icons.menu_book_outlined,
      ClearanceGateId.schedule => Icons.schedule_outlined,
      ClearanceGateId.seats => Icons.verified_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final tone = ExaminationsLabels.gateTone(gate.state);
    final blocked = gate.state == GateState.blocked;
    final fill = blocked
        ? tone.foreground(theme.brightness)
        : tone.surface(theme.brightness);
    final numberColor = blocked
        ? theme.colorScheme.onError
        : tone.foreground(theme.brightness);
    final noteText = note;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppDimensions.iconLarge,
          height: AppDimensions.iconLarge,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: Container(
            width: AppDimensions.iconTile,
            height: AppDimensions.iconTile,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
            child: Text(
              position.toString(),
              style: AppTextStyles.codeSmall.copyWith(
                color: numberColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Expanded(
          child: Container(
            padding: AppSpacing.card,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: AppRadii.blockRadius,
              border: Border.all(
                color: blocked
                    ? tone.border(theme.brightness)
                    : theme.colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: AppDimensions.iconTileSmall,
                      height: AppDimensions.iconTileSmall,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: tone.surface(theme.brightness),
                        borderRadius: AppRadii.elementRadius,
                      ),
                      child: Icon(
                        iconFor(gate.id),
                        size: AppDimensions.iconSmall,
                        color: tone.foreground(theme.brightness),
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${l10n.examGatePosition(position)} ${ExaminationsLabels.gateTitle(l10n, gate.id)}',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: AppTextStyles.semiBold,
                            ),
                          ),
                          Text(
                            detail(l10n, gate.id),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    StatusTag(
                      label: ExaminationsLabels.gateState(l10n, gate.state),
                      tone: tone,
                    ),
                  ],
                ),
                if (noteText != null) ...[
                  AppSpacing.verticalGap(AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: AppRadii.elementRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          noteText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: blocked
                                ? tone.foreground(theme.brightness)
                                : theme.colorScheme.primary,
                            fontWeight: AppTextStyles.medium,
                            height: AppTextStyles.relaxedLineHeight,
                          ),
                        ),
                        if (noteAction != null) ...[
                          AppSpacing.verticalGap(AppSpacing.xs),
                          Text(
                            noteAction!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
