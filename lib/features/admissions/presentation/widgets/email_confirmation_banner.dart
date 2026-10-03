import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';

/// The unconfirmed-email gate.
///
/// This is the one banner on the screen that blocks work: an applicant cannot
/// submit an application or claim a JAMB result until the address is confirmed.
/// It states the address in full, because a typo there is the whole problem.
class EmailConfirmationBanner extends StatelessWidget {
  const EmailConfirmationBanner({
    required this.email,
    required this.onResend,
    required this.isSending,
    required this.hasSent,
    this.onDismiss,
    super.key,
  });

  /// The address awaiting confirmation, shown verbatim.
  final String email;

  final VoidCallback onResend;
  final bool isSending;

  /// A link was sent in this session; the banner confirms instead of nagging.
  final bool hasSent;

  /// Hides the banner for the rest of the session.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    const tone = AppTone.info;

    return Container(
      width: double.infinity,
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: tone.surface(theme.brightness),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.infoBorder(theme.brightness)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppDimensions.iconTileSmall,
                height: AppDimensions.iconTileSmall,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  hasSent ? Icons.mark_email_read_outlined : Icons.mail_outline,
                  size: AppDimensions.iconDense,
                  color: tone.foreground(theme.brightness),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Expanded(
                child: Text(
                  hasSent
                      ? l10n.admissionsConfirmEmailSent
                      : l10n.admissionsConfirmEmailBody(email),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (onDismiss != null && !hasSent)
                IconButton(
                  onPressed: onDismiss,
                  tooltip: l10n.commonDismiss,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.close,
                    size: AppDimensions.iconSmall,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          OutlinedButton.icon(
            onPressed: isSending ? null : onResend,
            style: OutlinedButton.styleFrom(
              foregroundColor: tone.foreground(theme.brightness),
              backgroundColor: theme.colorScheme.surface,
              side: BorderSide(color: AppColors.infoBorder(theme.brightness)),
              minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.elementRadius,
              ),
            ),
            icon: hasSent
                ? const Icon(Icons.check, size: AppDimensions.iconDense)
                : const Icon(
                    Icons.forward_to_inbox_outlined,
                    size: AppDimensions.iconDense,
                  ),
            label: Text(
              isSending
                  ? l10n.admissionsResendingLink
                  : l10n.admissionsResendLink,
            ),
          ),
        ],
      ),
    );
  }
}
