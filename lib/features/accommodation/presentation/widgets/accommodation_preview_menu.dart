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
import '../bloc/accommodation_cubit.dart';
import '../mock/accommodation_fixtures.dart';

/// Debug-only control that loads every student Accommodation fixture ledger.
///
/// Hidden outside [kDebugMode]. Use it to walk the hub phases, then open
/// History from the tab bar, or Terms / Rooms from the states that lead there.
class AccommodationPreviewFab extends StatelessWidget {
  const AccommodationPreviewFab({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return FloatingActionButton.extended(
      onPressed: () => AccommodationPreviewSheet.show(context),
      icon: const Icon(Icons.tune),
      label: Text(context.l10n.accommodationPreviewAction),
    );
  }
}

/// Bottom sheet listing every student preview scenario.
class AccommodationPreviewSheet extends StatelessWidget {
  const AccommodationPreviewSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.canvas(context.theme.brightness),
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<AccommodationCubit>(),
        child: const AccommodationPreviewSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final cubit = context.read<AccommodationCubit>();

    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: AppSpacing.sheet,
        children: [
          Text(l10n.accommodationPreviewTitle, style: theme.textTheme.titleLarge),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.accommodationPreviewSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          for (final scenario in AccommodationPreviewScenario.values)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_label(l10n, scenario)),
              subtitle: Text(
                _hint(l10n, scenario),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                cubit.previewScenario(scenario);
                Navigator.of(context).pop();
                _openLinkedScreen(context, scenario);
              },
            ),
        ],
      ),
    );
  }

  static String _label(AppLocalizations l10n, AccommodationPreviewScenario s) {
    return switch (s) {
      AccommodationPreviewScenario.heldAndOffer =>
        l10n.accommodationPreviewHeldAndOffer,
      AccommodationPreviewScenario.notScheduled =>
        l10n.accommodationPreviewNotScheduled,
      AccommodationPreviewScenario.needsTerms =>
        l10n.accommodationPreviewNeedsTerms,
      AccommodationPreviewScenario.roomList =>
        l10n.accommodationPreviewRoomList,
      AccommodationPreviewScenario.confirmed =>
        l10n.accommodationPreviewConfirmed,
      AccommodationPreviewScenario.freeBed => l10n.accommodationPreviewFreeBed,
      AccommodationPreviewScenario.checkedIn =>
        l10n.accommodationPreviewCheckedIn,
      AccommodationPreviewScenario.sessionHeld =>
        l10n.accommodationPreviewSessionHeld,
      AccommodationPreviewScenario.noHistory =>
        l10n.accommodationPreviewNoHistory,
    };
  }

  static String _hint(AppLocalizations l10n, AccommodationPreviewScenario s) {
    return switch (s) {
      AccommodationPreviewScenario.heldAndOffer =>
        l10n.accommodationPreviewHeldAndOfferHint,
      AccommodationPreviewScenario.notScheduled =>
        l10n.accommodationPreviewNotScheduledHint,
      AccommodationPreviewScenario.needsTerms =>
        l10n.accommodationPreviewNeedsTermsHint,
      AccommodationPreviewScenario.roomList =>
        l10n.accommodationPreviewRoomListHint,
      AccommodationPreviewScenario.confirmed =>
        l10n.accommodationPreviewConfirmedHint,
      AccommodationPreviewScenario.freeBed =>
        l10n.accommodationPreviewFreeBedHint,
      AccommodationPreviewScenario.checkedIn =>
        l10n.accommodationPreviewCheckedInHint,
      AccommodationPreviewScenario.sessionHeld =>
        l10n.accommodationPreviewSessionHeldHint,
      AccommodationPreviewScenario.noHistory =>
        l10n.accommodationPreviewNoHistoryHint,
    };
  }

  static void _openLinkedScreen(
    BuildContext context,
    AccommodationPreviewScenario scenario,
  ) {
    switch (scenario) {
      case AccommodationPreviewScenario.needsTerms:
        context.goNamed(Routes.accommodationTermsName);
      case AccommodationPreviewScenario.roomList:
        context.goNamed(Routes.accommodationRoomsName);
      case AccommodationPreviewScenario.noHistory:
        context.goNamed(Routes.accommodationHistoryName);
      case AccommodationPreviewScenario.heldAndOffer:
      case AccommodationPreviewScenario.notScheduled:
      case AccommodationPreviewScenario.confirmed:
      case AccommodationPreviewScenario.freeBed:
      case AccommodationPreviewScenario.checkedIn:
      case AccommodationPreviewScenario.sessionHeld:
        context.goNamed(Routes.accommodationName);
    }
  }
}
