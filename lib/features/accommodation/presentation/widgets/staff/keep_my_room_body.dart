import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/widgets/labelled_value_row.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import 'housing_confirm_dialog.dart';
import 'housing_field.dart';
import 'housing_labels.dart';
import 'housing_section.dart';

/// Keep-my-room: offers last term's residents their own bed back, for a
/// window. The form, then the outcome with whoever had to be skipped.
class KeepMyRoomBody extends StatefulWidget {
  const KeepMyRoomBody({required this.state, super.key});

  final HousingState state;

  @override
  KeepMyRoomBodyState createState() => KeepMyRoomBodyState();
}

/// State of [KeepMyRoomBody]: the window being drafted.
class KeepMyRoomBodyState extends State<KeepMyRoomBody> {
  int _windowDays = 7;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final state = widget.state;
    final outcome = state.keepOutcome;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HousingSection(
          title: l10n.housingKeepTitle,
          description: l10n.housingKeepBody,
          children: [
            HousingMetricRow(
              metrics: [
                HousingMetric(
                  value: '${state.keepEligible}',
                  caption: l10n.housingMetricEligible,
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            HousingStepper(
              label: l10n.housingKeepWindow,
              value: _windowDays,
              min: 1,
              max: 30,
              suffix: l10n.housingDaysSuffix,
              onChanged: (value) => setState(() => _windowDays = value),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ToneCallout(
              tone: AppTone.info,
              icon: Icons.mark_email_unread_outlined,
              body: l10n.housingKeepNote,
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        FilledButton.icon(
          onPressed: outcome != null || state.keepEligible == 0
              ? null
              : () async {
                  final cubit = context.read<HousingCubit>();
                  final confirmed = await confirmHousingAction(
                    context,
                    title: l10n.housingKeepConfirmTitle,
                    body: l10n.housingKeepConfirmBody(
                      state.keepEligible,
                      _windowDays,
                    ),
                    confirmLabel: l10n.housingKeepSend,
                  );
                  if (confirmed) cubit.sendKeepMyRoom(windowDays: _windowDays);
                },
          icon: const Icon(Icons.send_outlined),
          label: Text(l10n.housingKeepSend),
        ),
        if (outcome != null) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          HousingSection(
            title: l10n.housingKeepResultTitle,
            children: [
              ToneCallout(
                tone: AppTone.success,
                icon: Icons.check_circle_outline,
                body: l10n.housingKeepResultBody(
                  outcome.offered,
                  outcome.windowDays,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.housingKeepSkippedTitle(outcome.skipped.length),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              for (final skip in outcome.skipped)
                LabelledValueRow(
                  label: skip.studentName,
                  value: HousingLabels.skipReason(l10n, skip.reason),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
