import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// What a candidate does with the letter: keep a copy, pass it on, or copy
/// the code somebody is about to type into the verification page.
///
/// Three equal controls on one row, 44px tall, filled for the one most will
/// want and outlined for the other two — the letter is the thing on this
/// screen, and the actions are a toolbar above it, not a decision beneath it.
class AdmissionLetterActions extends StatelessWidget {
  const AdmissionLetterActions({
    required this.onSavePdf,
    required this.onShare,
    required this.onCopyCode,
    super.key,
  });

  final VoidCallback onSavePdf;
  final VoidCallback onShare;
  final VoidCallback onCopyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const size = Size(0, AppDimensions.buttonHeight);
    const padding = EdgeInsets.symmetric(horizontal: AppSpacing.md);

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: onSavePdf,
            style: FilledButton.styleFrom(minimumSize: size, padding: padding),
            icon: const Icon(
              Icons.picture_as_pdf_outlined,
              size: AppDimensions.iconDense,
            ),
            label: Text(l10n.admissionsLetterSavePdf),
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onShare,
            style: OutlinedButton.styleFrom(
              minimumSize: size,
              padding: padding,
            ),
            icon: const Icon(
              Icons.ios_share_outlined,
              size: AppDimensions.iconDense,
            ),
            label: Text(l10n.admissionsLetterShare),
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCopyCode,
            style: OutlinedButton.styleFrom(
              minimumSize: size,
              padding: padding,
            ),
            icon: const Icon(
              Icons.content_copy_outlined,
              size: AppDimensions.iconDense,
            ),
            label: Text(l10n.admissionsLetterCopyCode),
          ),
        ),
      ],
    );
  }
}
