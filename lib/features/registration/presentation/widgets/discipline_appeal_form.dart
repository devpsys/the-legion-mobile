import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/registration_cubit.dart';
import '../models/registration_models.dart';
import 'registration_card.dart';
import 'registration_chrome.dart';

/// Appeal section on a decided case — open form, closed notice, or lodged view.
class DisciplineAppealSection extends StatelessWidget {
  const DisciplineAppealSection({
    required this.record,
    required this.item,
    required this.cubit,
    super.key,
  });

  final DisciplineRecord record;
  final DisciplineCase item;
  final RegistrationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dateFormat = AppDateFormats.long(l10n.localeName);
    final appeal = item.appeal;

    if (appeal != null) {
      return RegistrationCard(
        clip: false,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RegistrationFormHeader(
              title: l10n.disciplineAppealLodgedTitle,
              subtitle: l10n.disciplineAppealLodgedOn(
                dateFormat.format(appeal.lodgedOn),
              ),
              icon: Icons.assignment_turned_in_outlined,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ToneCallout(
              tone: AppTone.warning,
              icon: Icons.gavel_outlined,
              title: l10n.disciplineAppealAwaiting,
              body: l10n.disciplineAppealFiledBanner,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              appeal.grounds,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                height: AppTextStyles.relaxedLineHeight,
                fontStyle: FontStyle.italic,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ToneCallout(
              tone: AppTone.info,
              icon: Icons.info_outline,
              body: l10n.disciplineAppealReviewNote,
            ),
          ],
        ),
      );
    }

    if (record.appealWindowClosed(item)) {
      final closes = item.appealWindowClosesOn;
      final decided = item.decidedOn;
      return RegistrationCard(
        clip: false,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RegistrationFormHeader(
              title: l10n.disciplineAppealTitle,
              subtitle: l10n.disciplineAppealClosedTitle,
              icon: Icons.history_toggle_off_outlined,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            if (closes != null)
              ToneCallout(
                tone: AppTone.neutral,
                icon: Icons.event_busy_outlined,
                title: l10n.disciplineAppealClosedBody(
                  dateFormat.format(closes),
                ),
                body: decided == null
                    ? l10n.disciplineAppealLiableOnly
                    : l10n.disciplineAppealClosedDetail(
                        dateFormat.format(decided),
                      ),
              ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              l10n.disciplineAppealWrittenStill,
              style: context.theme.textTheme.bodySmall?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              l10n.disciplineAppealLiableOnly,
              style: context.theme.textTheme.bodySmall?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
        ),
      );
    }

    if (!record.canAppeal(item)) {
      return const SizedBox.shrink();
    }

    return DisciplineAppealForm(
      record: record,
      item: item,
      cubit: cubit,
    );
  }
}

/// Editable grounds form while the appeal window is open.
class DisciplineAppealForm extends StatefulWidget {
  const DisciplineAppealForm({
    required this.record,
    required this.item,
    required this.cubit,
    super.key,
  });

  final DisciplineRecord record;
  final DisciplineCase item;
  final RegistrationCubit cubit;

  @override
  DisciplineAppealFormState createState() => DisciplineAppealFormState();
}

/// State of [DisciplineAppealForm].
class DisciplineAppealFormState extends State<DisciplineAppealForm> {
  late final TextEditingController _groundsController;

  @override
  void initState() {
    super.initState();
    _groundsController = TextEditingController(
      text: widget.record.appealDraft,
    );
  }

  @override
  void dispose() {
    _groundsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final dateFormat = AppDateFormats.long(l10n.localeName);
    final closes = widget.item.appealWindowClosesOn!;
    final min = DisciplineCase.appealGroundsMinLength;
    final count = _groundsController.text.trim().length;
    final fieldStyle = AppTextStyles.codeSmall.copyWith(
      fontWeight: AppTextStyles.medium,
      color: theme.colorScheme.onSurface,
    );
    final hintStyle = AppTextStyles.codeSmall.copyWith(
      fontWeight: AppTextStyles.regular,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return RegistrationCard(
      clip: false,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RegistrationFormHeader(
            title: l10n.disciplineAppealTitle,
            subtitle:
                '${l10n.disciplineAppealUntil(dateFormat.format(closes))}\n'
                '${l10n.disciplineAppealWindowDays}',
            icon: Icons.balance_outlined,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          RegistrationFieldLabel(l10n.disciplineAppealGroundsLabel),
          AppSpacing.verticalGap(AppSpacing.xs),
          TextField(
            controller: _groundsController,
            style: fieldStyle,
            minLines: 4,
            maxLines: 8,
            textAlignVertical: TextAlignVertical.top,
            onChanged: (value) {
              widget.cubit.setDisciplineAppealDraft(value);
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: l10n.disciplineAppealGroundsHint,
              hintStyle: hintStyle,
              border: OutlineInputBorder(
                borderRadius: AppRadii.elementRadius,
              ),
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.all(AppSpacing.md),
              // Counter is drawn below so the long helper is not truncated.
              counterText: '',
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.disciplineAppealGroundsRequired(min),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: AppTextStyles.relaxedLineHeight,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Text(
                l10n.disciplineAppealGroundsCounter(count, min),
                style: AppTextStyles.codeSmall.copyWith(
                  color: count < min
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          FilledButton(
            onPressed: () {
              final ok = widget.cubit.requestLodgeAppeal(widget.item.id);
              if (!ok) {
                context.showErrorMessage(
                  l10n.disciplineAppealGroundsRequired(min),
                );
              }
            },
            child: Text(l10n.disciplineAppealLodge),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.disciplineAppealOnceNote,
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
