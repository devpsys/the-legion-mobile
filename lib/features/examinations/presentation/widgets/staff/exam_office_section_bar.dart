import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/l10n/gen/app_localizations.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/responsive.dart';

/// The lists of the examinations office.
enum ExamOfficeSection {
  results,
  sessions,
  grading,
  incidents,
  resits,
  broadsheets,
}

/// A strip of chips that moves between the office's lists.
class ExamOfficeSectionBar extends StatelessWidget {
  const ExamOfficeSectionBar({required this.selected, super.key});

  final ExamOfficeSection selected;

  /// The route name of [section].
  static String routeNameFor(ExamOfficeSection section) {
    return switch (section) {
      ExamOfficeSection.results => Routes.examOfficeResultsName,
      ExamOfficeSection.sessions => Routes.examOfficeSessionsName,
      ExamOfficeSection.grading => Routes.examOfficeGradingName,
      ExamOfficeSection.incidents => Routes.examOfficeIncidentsName,
      ExamOfficeSection.resits => Routes.examOfficeResitsName,
      ExamOfficeSection.broadsheets => Routes.examOfficeBroadsheetsName,
    };
  }

  /// The chip label of [section].
  static String label(AppLocalizations l10n, ExamOfficeSection section) {
    return switch (section) {
      ExamOfficeSection.results => l10n.examOfficeSectionResults,
      ExamOfficeSection.sessions => l10n.examOfficeSectionSessions,
      ExamOfficeSection.grading => l10n.examOfficeSectionGrading,
      ExamOfficeSection.incidents => l10n.examOfficeSectionIncidents,
      ExamOfficeSection.resits => l10n.examOfficeSectionResits,
      ExamOfficeSection.broadsheets => l10n.examOfficeSectionBroadsheets,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: AppDimensions.filterChipRowHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final section in ExamOfficeSection.values) ...[
            ChoiceChip(
              label: Text(label(l10n, section)),
              selected: section == selected,
              onSelected: (_) => context.goNamed(routeNameFor(section)),
            ),
            AppSpacing.horizontalGap(AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
