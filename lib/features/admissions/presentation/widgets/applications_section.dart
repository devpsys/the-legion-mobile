import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../models/admissions_models.dart';
import 'application_summary_card.dart';
import 'applications_empty_state.dart';
import 'section_surface.dart';

/// "Your applications" — the list, or the reason it is empty.
///
/// The header carries the only always-available action on the screen (Apply);
/// the body either lists applications or explains why there are none.
class ApplicationsSection extends StatelessWidget {
  const ApplicationsSection({
    required this.applications,
    required this.openCycleCount,
    required this.onApply,
    required this.onBrowse,
    super.key,
  });

  final List<ApplicationSummary> applications;

  /// Drives the empty state's copy: "2 admission cycles are open".
  final int openCycleCount;

  final VoidCallback onApply;
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
            title: l10n.admissionsYourApplications,
            action: FilledButton.icon(
              onPressed: onApply,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, AppDimensions.buttonCompact),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              ),
              icon: const Icon(Icons.add, size: AppDimensions.iconDense),
              label: Text(l10n.admissionsApply),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          if (applications.isEmpty)
            ApplicationsEmptyState(
              openCycleCount: openCycleCount,
              onBrowse: onBrowse,
            )
          else
            for (final application in applications)
              ApplicationSummaryCard(application: application),
        ],
      ),
    );
  }
}
