import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../models/accommodation_models.dart';

/// "Confirm room hold": the bed fee and the hold window before an invoice is
/// raised for [room].
///
/// [show] resolves to `true` only when the student chooses to hold the bed.
class ConfirmRoomHoldSheet extends StatelessWidget {
  const ConfirmRoomHoldSheet({
    required this.room,
    required this.termLabel,
    required this.holdWindow,
    super.key,
  });

  final BookableRoom room;
  final String termLabel;
  final Duration holdWindow;

  static Future<bool> show(
    BuildContext context, {
    required BookableRoom room,
    required String termLabel,
    required Duration holdWindow,
  }) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: AppColors.transparent,
      builder: (context) => ConfirmRoomHoldSheet(
        room: room,
        termLabel: termLabel,
        holdWindow: holdWindow,
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadii.topSheet,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: AppDimensions.sheetHandleWidth,
                height: AppDimensions.sheetHandleHeight,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: AppRadii.chipRadius,
                ),
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            Text(
              l10n.accommodationHoldTitle,
              style: theme.textTheme.titleLarge,
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              l10n.accommodationRoomLine(room.hostelBlock, room.room),
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            LabelledValueRow(
              label: l10n.accommodationHoldSession,
              value: termLabel,
              isCode: true,
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            LabelledValueRow(
              label: l10n.accommodationHoldFee,
              value: formatNaira(room.priceMinorUnits),
              isCode: true,
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            LabelledValueRow(
              label: l10n.accommodationHoldExpiry,
              value: l10n.accommodationHoldMinutes(holdWindow.inMinutes),
              isCode: true,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              l10n.accommodationHoldBody,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.credit_card_outlined),
              label: Text(l10n.accommodationHoldConfirm),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.accommodationHoldCancel),
            ),
          ],
        ),
      ),
    );
  }
}
