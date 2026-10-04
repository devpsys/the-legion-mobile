import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/application_detail_models.dart';
import 'section_surface.dart';

/// The registry's answers to the questions a refusal raises, and the two ways
/// out of the screen.
///
/// Answers are folded: a candidate who wants one reads one, and the list stays
/// the length of a screen. The footer is the end of the file — back to the
/// record, or to a person — so the last thing on a hard page is somewhere to
/// go.
class ApplicationFaqCard extends StatelessWidget {
  const ApplicationFaqCard({
    required this.faqs,
    required this.onReturn,
    required this.onHelpDesk,
    super.key,
  });

  final List<AdmissionFaq> faqs;

  /// Returns to the list of applications.
  final VoidCallback onReturn;

  final VoidCallback onHelpDesk;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (faqs.isNotEmpty) ...[
            SectionHeader(title: l10n.admissionsInquiriesTitle),
            AppSpacing.verticalGap(AppSpacing.md),
            for (final faq in faqs) ...[
              ApplicationFaqTile(faq: faq),
              AppSpacing.verticalGap(AppSpacing.sm),
            ],
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
          Divider(
            height: AppDimensions.hairline,
            color: theme.colorScheme.outlineVariant,
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TextButton.icon(
                onPressed: onReturn,
                icon: const Icon(
                  Icons.arrow_back,
                  size: AppDimensions.iconDense,
                ),
                label: Text(l10n.admissionsReturnToApplications),
              ),
              TextButton(
                onPressed: onHelpDesk,
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                ),
                child: Text(l10n.admissionsHelpDesk),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One folded question: the question on a recessed row, the answer under it.
class ApplicationFaqTile extends StatelessWidget {
  const ApplicationFaqTile({required this.faq, super.key});

  final AdmissionFaq faq;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    const shape = RoundedRectangleBorder(borderRadius: AppRadii.blockRadius);

    // The tile draws a rule above and below itself unless the theme's divider
    // is invisible, and the recessed fill already separates the rows.
    return Theme(
      data: theme.copyWith(dividerColor: AppColors.transparent),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: AppTextStyles.medium,
          ),
        ),
        backgroundColor: AppColors.subtle(theme.brightness),
        collapsedBackgroundColor: AppColors.subtle(theme.brightness),
        shape: shape,
        collapsedShape: shape,
        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faq.answer,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
