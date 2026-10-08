import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/responsive_content.dart';

/// The scrolling, width-capped frame of a student examinations tab: a title,
/// one sentence, then the sections.
class ExaminationsScrollBody extends StatelessWidget {
  const ExaminationsScrollBody({
    required this.title,
    required this.subtitle,
    required this.children,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.lg,
            bottom: AppSpacing.huge + AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: theme.textTheme.headlineMedium),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) AppSpacing.verticalGap(AppSpacing.lg),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
