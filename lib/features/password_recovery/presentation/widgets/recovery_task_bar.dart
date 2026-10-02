import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Shared chrome for the focused recovery task.
///
/// Extracted from the four recovery designs: a sticky task bar with a back
/// affordance, the institutional mark and a trailing slot for status chips.
class RecoveryTaskBar extends StatelessWidget {
  const RecoveryTaskBar({
    required this.onBack,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.isDocked = false,
    super.key,
  });

  /// Returns to the previous step; cancels the flow when there is none.
  final VoidCallback onBack;

  final String title;
  final String? subtitle;

  /// Institutional mark shown before the title; the portal mark is used when
  /// omitted.
  final Widget? leading;

  /// Status chip shown at the end of the bar (`SEC-L4`, verified, …).
  final Widget? trailing;

  /// Renders at 44px instead of 56px, as on the success screen.
  final bool isDocked;

  static final Widget defaultLeading = Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      color: Color(0xFF0F3F6B),
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
    alignment: Alignment.center,
    child: Icon(
      Icons.account_balance_outlined,
      size: 14,
      color: Color(0xFFFFFFFF),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final height = isDocked ? 56.0 : AppDimensions.minTapTarget + 8;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxFormWidth,
            ),
            child: SizedBox(
              height: height,
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    tooltip: MaterialLocalizations.of(context)
                        .backButtonTooltip,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.xs),
                  leading ?? defaultLeading,
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    trailing!,
                  ],
                  AppSpacing.horizontalGap(AppSpacing.md),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
