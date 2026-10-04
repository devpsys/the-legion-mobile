import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/widgets/status_tag.dart';

/// Top bar of the card checkout: back, bursary eyebrow, title, PCI tag.
class CardCheckoutTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CardCheckoutTopBar({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: AppColors.transparent,
      shape: Border(
        bottom: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: onBack,
        tooltip: l10n.feesCardCheckoutBackTooltip,
        icon: const Icon(Icons.arrow_back),
      ),
      centerTitle: false,
      titleSpacing: 0,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.feesCardCheckoutEyebrow,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: AppTextStyles.bold,
              letterSpacing: AppTextStyles.trackingCaps,
            ),
          ),
          Text(
            l10n.feesCardCheckoutTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          child: StatusTag(
            label: l10n.feesPciCompliant,
            tone: AppTone.neutral,
            isUppercase: true,
            icon: Icons.verified_user_outlined,
          ),
        ),
      ],
    );
  }
}
