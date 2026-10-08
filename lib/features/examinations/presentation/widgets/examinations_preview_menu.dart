import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/examinations_cubit.dart';
import '../models/examinations_models.dart';

/// Debug-only control that loads every student Examinations fixture ledger.
///
/// Hidden outside [kDebugMode]. Choosing a ledger loads it and opens the tab
/// that shows it.
class ExaminationsPreviewFab extends StatelessWidget {
  const ExaminationsPreviewFab({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return FloatingActionButton.extended(
      onPressed: () => ExaminationsPreviewSheet.show(context),
      icon: const Icon(Icons.tune),
      label: Text(context.l10n.examPreviewAction),
    );
  }
}

/// Bottom sheet listing every student preview ledger.
class ExaminationsPreviewSheet extends StatelessWidget {
  const ExaminationsPreviewSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.canvas(context.theme.brightness),
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<ExaminationsCubit>(),
        child: const ExaminationsPreviewSheet(),
      ),
    );
  }

  /// The route name of the tab that shows [scenario].
  static String routeNameFor(ExaminationsPreviewScenario scenario) {
    return switch (scenario) {
      ExaminationsPreviewScenario.publishedGood ||
      ExaminationsPreviewScenario.unpublished ||
      ExaminationsPreviewScenario.probation => Routes.examinationsName,
      ExaminationsPreviewScenario.cardNotIssued ||
      ExaminationsPreviewScenario.cardIssued ||
      ExaminationsPreviewScenario.cardRevoked => Routes.examinationsCardName,
      ExaminationsPreviewScenario.resitsOpen ||
      ExaminationsPreviewScenario.resitsClosed => Routes.examinationsResitsName,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final cubit = context.read<ExaminationsCubit>();

    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: AppSpacing.sheet,
        children: [
          Text(l10n.examPreviewTitle, style: theme.textTheme.titleLarge),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.examPreviewSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          for (final scenario in ExaminationsPreviewScenario.values)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(label(l10n, scenario)),
              subtitle: Text(
                hint(l10n, scenario),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                cubit.previewScenario(scenario);
                Navigator.of(context).pop();
                context.goNamed(routeNameFor(scenario));
              },
            ),
        ],
      ),
    );
  }

  /// The menu title of [scenario].
  static String label(AppLocalizations l10n, ExaminationsPreviewScenario s) {
    return switch (s) {
      ExaminationsPreviewScenario.publishedGood =>
        l10n.examPreviewPublishedGood,
      ExaminationsPreviewScenario.unpublished => l10n.examPreviewUnpublished,
      ExaminationsPreviewScenario.probation => l10n.examPreviewProbation,
      ExaminationsPreviewScenario.cardNotIssued =>
        l10n.examPreviewCardNotIssued,
      ExaminationsPreviewScenario.cardIssued => l10n.examPreviewCardIssued,
      ExaminationsPreviewScenario.cardRevoked => l10n.examPreviewCardRevoked,
      ExaminationsPreviewScenario.resitsOpen => l10n.examPreviewResitsOpen,
      ExaminationsPreviewScenario.resitsClosed => l10n.examPreviewResitsClosed,
    };
  }

  /// The one-line hint of [scenario].
  static String hint(AppLocalizations l10n, ExaminationsPreviewScenario s) {
    return switch (s) {
      ExaminationsPreviewScenario.publishedGood =>
        l10n.examPreviewPublishedGoodHint,
      ExaminationsPreviewScenario.unpublished =>
        l10n.examPreviewUnpublishedHint,
      ExaminationsPreviewScenario.probation => l10n.examPreviewProbationHint,
      ExaminationsPreviewScenario.cardNotIssued =>
        l10n.examPreviewCardNotIssuedHint,
      ExaminationsPreviewScenario.cardIssued => l10n.examPreviewCardIssuedHint,
      ExaminationsPreviewScenario.cardRevoked =>
        l10n.examPreviewCardRevokedHint,
      ExaminationsPreviewScenario.resitsOpen => l10n.examPreviewResitsOpenHint,
      ExaminationsPreviewScenario.resitsClosed =>
        l10n.examPreviewResitsClosedHint,
    };
  }
}
