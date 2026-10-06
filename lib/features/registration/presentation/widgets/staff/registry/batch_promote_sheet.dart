import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radii.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/responsive.dart';
import '../staff_filter_chips.dart';

/// Sheet to promote the selected students to a new level.
class BatchPromoteSheet extends StatefulWidget {
  const BatchPromoteSheet({
    required this.selectedCount,
    required this.initialLevel,
    required this.onLevelChanged,
    required this.onConfirm,
    super.key,
  });

  /// Levels a batch can be promoted to.
  static const List<int> levels = [200, 300, 400, 500];

  final int selectedCount;
  final int initialLevel;
  final ValueChanged<int> onLevelChanged;
  final VoidCallback onConfirm;

  /// Opens the sheet; [onDismissed] runs however it closes.
  static Future<void> show(
    BuildContext context, {
    required int selectedCount,
    required int initialLevel,
    required ValueChanged<int> onLevelChanged,
    required VoidCallback onConfirm,
    required VoidCallback onDismissed,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: AppColors.transparent,
      builder: (context) => BatchPromoteSheet(
        selectedCount: selectedCount,
        initialLevel: initialLevel,
        onLevelChanged: onLevelChanged,
        onConfirm: onConfirm,
      ),
    ).whenComplete(onDismissed);
  }

  @override
  BatchPromoteSheetState createState() => BatchPromoteSheetState();
}

/// State of [BatchPromoteSheet].
class BatchPromoteSheetState extends State<BatchPromoteSheet> {
  late int _level;

  @override
  void initState() {
    super.initState();
    _level = widget.initialLevel;
  }

  void _select(int level) {
    setState(() => _level = level);
    widget.onLevelChanged(level);
  }

  void _confirm() {
    Navigator.of(context).pop();
    widget.onConfirm();
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
          AppSpacing.xl + AppSpacing.sm,
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
            Text(l10n.staffRegistryPromoteTitle, style: theme.textTheme.titleLarge),
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              l10n.staffRegistryPromoteBody(widget.selectedCount),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            Text(
              l10n.staffRegistryPromoteLevelLabel,
              style: AppTextStyles.codeSmall.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            StaffFilterChips<int>(
              values: BatchPromoteSheet.levels,
              selected: _level,
              labelOf: l10n.registrationLevel,
              onSelected: _select,
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            FilledButton(
              onPressed: _confirm,
              style: FilledButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  AppDimensions.sheetActionHeight,
                ),
              ),
              child: Text(l10n.staffRegistryPromoteConfirm(_level)),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  AppDimensions.sheetActionHeight,
                ),
              ),
              child: Text(l10n.commonCancel),
            ),
          ],
        ),
      ),
    );
  }
}
