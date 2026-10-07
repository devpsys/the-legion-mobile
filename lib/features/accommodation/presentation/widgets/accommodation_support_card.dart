import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/surface_card.dart';

/// Who to ask about a bed: the housing directorate and its extension.
class AccommodationSupportCard extends StatelessWidget {
  const AccommodationSupportCard({
    required this.title,
    required this.detail,
    this.body,
    super.key,
  });

  final String title;

  /// The extension or desk hours, in the mono face.
  final String detail;

  /// A line of guidance under the title.
  final String? body;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final body = this.body;

    return SurfaceCard(
      child: Row(
        children: [
          Icon(
            Icons.support_agent_outlined,
            size: AppDimensions.iconMedium,
            color: theme.colorScheme.primary,
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  detail,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (body != null) ...[
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    body,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: AppTextStyles.relaxedLineHeight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.showMessage(l10n.commonComingSoon),
            tooltip: l10n.accommodationSupportCall,
            icon: const Icon(Icons.call_outlined),
          ),
        ],
      ),
    );
  }
}
