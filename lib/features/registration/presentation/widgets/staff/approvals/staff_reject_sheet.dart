import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radii.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/responsive.dart';

/// Confirmation sheet for a destructive staff decision.
///
/// Two shapes share the chrome: with [onReasonChanged] the sheet collects a
/// reason and keeps the confirm action disabled until one is written (reject
/// courses, cancel an ID card); without it the sheet only confirms, and shows
/// the reason already given as [quote] (reject a student request).
class StaffRejectSheet extends StatefulWidget {
  const StaffRejectSheet({
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.onConfirm,
    this.reasonLabel,
    this.reasonHint,
    this.initialReason = '',
    this.onReasonChanged,
    this.quote,
    super.key,
  });

  final String title;
  final String body;
  final String confirmLabel;
  final VoidCallback onConfirm;

  /// Label above the reason field; only used with [onReasonChanged].
  final String? reasonLabel;
  final String? reasonHint;
  final String initialReason;

  /// Shows the reason field and reports each edit.
  final ValueChanged<String>? onReasonChanged;

  /// A reason already written, shown read-only above the actions.
  final String? quote;

  /// Opens the sheet. [onDismissed] runs once the sheet closes by any route
  /// (confirm, cancel, drag or barrier tap), so the cubit never keeps a
  /// stale sheet state.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
    required VoidCallback onConfirm,
    required VoidCallback onDismissed,
    String? reasonLabel,
    String? reasonHint,
    String initialReason = '',
    ValueChanged<String>? onReasonChanged,
    String? quote,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: AppColors.transparent,
      builder: (context) => StaffRejectSheet(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        reasonLabel: reasonLabel,
        reasonHint: reasonHint,
        initialReason: initialReason,
        onReasonChanged: onReasonChanged,
        quote: quote,
      ),
    ).whenComplete(onDismissed);
  }

  @override
  StaffRejectSheetState createState() => StaffRejectSheetState();
}

/// State of [StaffRejectSheet].
class StaffRejectSheetState extends State<StaffRejectSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialReason);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canConfirm =>
      widget.onReasonChanged == null || _controller.text.trim().isNotEmpty;

  void _onChanged(String value) {
    setState(() {});
    widget.onReasonChanged?.call(value);
  }

  void _confirm() {
    Navigator.of(context).pop();
    widget.onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final quote = widget.quote;
    final collectsReason = widget.onReasonChanged != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
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
          child: SingleChildScrollView(
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
                Text(widget.title, style: theme.textTheme.titleLarge),
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(
                  widget.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: AppTextStyles.relaxedLineHeight,
                  ),
                ),
                if (collectsReason) ...[
                  AppSpacing.verticalGap(AppSpacing.lg),
                  if (widget.reasonLabel != null) ...[
                    Text(
                      widget.reasonLabel!,
                      style: AppTextStyles.codeSmall.copyWith(
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                  ],
                  TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    minLines: 3,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(hintText: widget.reasonHint),
                  ),
                ],
                if (quote != null && quote.isNotEmpty) ...[
                  AppSpacing.verticalGap(AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: AppRadii.elementRadius,
                    ),
                    child: Text(
                      quote,
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: AppTextStyles.relaxedLineHeight,
                      ),
                    ),
                  ),
                ],
                AppSpacing.verticalGap(AppSpacing.lg),
                FilledButton(
                  onPressed: _canConfirm ? _confirm : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    minimumSize: const Size(
                      double.infinity,
                      AppDimensions.sheetActionHeight,
                    ),
                  ),
                  child: Text(widget.confirmLabel),
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
        ),
      ),
    );
  }
}
