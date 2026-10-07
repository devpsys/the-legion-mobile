import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';

/// The allocation slip: its code in the mono face, a copy action and the
/// download action, with the line telling the student what to bring.
class SlipCodeRow extends StatelessWidget {
  const SlipCodeRow({
    required this.code,
    required this.hint,
    this.downloadLabel,
    super.key,
  });

  final String code;

  /// What to do with the slip, e.g. "Bring your slip and your ID card…".
  final String hint;

  /// The download button's label; null hides the button.
  final String? downloadLabel;

  Future<void> _copy(BuildContext context) async {
    final message = context.l10n.accommodationSlipCopied;
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    context.showMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final downloadLabel = this.downloadLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: AppRadii.blockRadius,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(
                Icons.verified_outlined,
                size: AppDimensions.iconMedium,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.accommodationSlipCode,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    SelectableText(
                      code,
                      style: AppTextStyles.codeMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                        letterSpacing: AppTextStyles.trackingCode,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _copy(context),
                tooltip: l10n.accommodationSlipCopy,
                icon: const Icon(Icons.content_copy_outlined),
              ),
            ],
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Text(
          hint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: AppTextStyles.relaxedLineHeight,
          ),
        ),
        if (downloadLabel != null) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () => context.showMessage(l10n.commonComingSoon),
            icon: const Icon(Icons.download_outlined),
            label: Text(downloadLabel),
          ),
        ],
      ],
    );
  }
}
