import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/widgets/status_tag.dart';

/// Top bar of the checkout: a way back, the task's name, and the one word a
/// payment screen must say — that it is secure.
///
/// No bell and no avatar: a student choosing how to pay is in a task, not
/// moving about the portal, so the bar carries nothing that leads elsewhere.
class CheckoutTopBar extends StatelessWidget implements PreferredSizeWidget {
  const CheckoutTopBar({required this.onBack, super.key});

  /// Unwinds to the fees tab.
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
        tooltip: l10n.feesCheckoutBackTooltip,
        icon: const Icon(Icons.arrow_back),
      ),
      centerTitle: false,
      titleSpacing: 0,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.feesCheckoutTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            l10n.feesCheckoutSubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          child: StatusTag(
            label: l10n.feesSecure,
            tone: AppTone.success,
            isUppercase: true,
            icon: Icons.lock_outline,
          ),
        ),
      ],
    );
  }
}
