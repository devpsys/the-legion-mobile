import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/examinations_models.dart';
import 'clearance_gate_tile.dart';
import 'examinations_labels.dart';

/// A student without a card: the gate that is blocking it, then the five
/// clearances as a stepped pipeline.
class CardNotIssuedSection extends StatelessWidget {
  const CardNotIssuedSection({
    required this.student,
    required this.card,
    super.key,
  });

  final ExamStudent student;
  final ExaminationCard card;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final blocking = card.blockingGate;
    final blockingIndex = blocking == null
        ? -1
        : card.gates.indexWhere((gate) => gate.id == blocking.id);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CardMetaPill(
              label: card.examinationName,
              pip: theme.colorScheme.primary,
              background: theme.colorScheme.surfaceContainer,
              foreground: theme.colorScheme.primary,
            ),
            CardMetaPill(
              label: l10n.examCardStatusNotIssued,
              pip: theme.colorScheme.outline,
              background: theme.colorScheme.surfaceContainerHighest,
              foreground: muted,
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        CardHolderBanner(student: student, blocking: blocking),
        if (blocking != null) ...[
          AppSpacing.verticalGap(AppSpacing.lg),
          BlockingGateCard(
            card: card,
            gate: blocking,
            position: blockingIndex + 1,
          ),
        ],
        AppSpacing.verticalGap(AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                l10n.examCardNotIssuedTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
            ),
            if (blocking != null) ...[
              AppSpacing.horizontalGap(AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppTone.danger.surface(theme.brightness),
                  borderRadius: AppRadii.tagRadius,
                ),
                child: Text(
                  l10n
                      .examCardGateOf(blockingIndex + 1, card.gates.length)
                      .toUpperCase(),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppTone.danger.foreground(theme.brightness),
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
            ],
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          l10n.examCardNotIssuedBody,
          style: theme.textTheme.bodySmall?.copyWith(
            color: muted,
            height: AppTextStyles.relaxedLineHeight,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.examGatesTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.sm),
            Text(
              l10n.examCardAuditLedger.toUpperCase(),
              style: AppTextStyles.codeSmall.copyWith(
                color: muted,
                letterSpacing: AppTextStyles.trackingCaps,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          l10n.examGatesBody,
          style: theme.textTheme.bodySmall?.copyWith(color: muted),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        ClearancePipeline(card: card),
        AppSpacing.verticalGap(AppSpacing.lg),
        const CardPolicyNote(),
      ],
    );
  }
}

/// Name, programme and the standing of the clearance that is in the way.
class CardHolderBanner extends StatelessWidget {
  const CardHolderBanner({
    required this.student,
    required this.blocking,
    super.key,
  });

  final ExamStudent student;
  final ClearanceGate? blocking;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final muted = theme.colorScheme.onSurfaceVariant;
    final gate = blocking;
    final tone = gate == null
        ? AppTone.neutral
        : ExaminationsLabels.gateTone(gate.state);

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.iconLarge,
            height: AppDimensions.iconLarge,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: AppRadii.elementRadius,
            ),
            child: Icon(
              Icons.badge_outlined,
              size: AppDimensions.iconMedium,
              color: theme.colorScheme.primary,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
                Text(
                  l10n.examCardIdentityLine(
                    student.programme,
                    student.department,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: muted),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.examCardLevel(student.level),
                style: AppTextStyles.codeSmall.copyWith(color: muted),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              StatusTag(
                label: gate == null
                    ? l10n.examCardStatusNotIssued
                    : ExaminationsLabels.gateState(l10n, gate.state),
                tone: tone,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The clearance that has to pass before a card can be issued.
class BlockingGateCard extends StatelessWidget {
  const BlockingGateCard({
    required this.card,
    required this.gate,
    required this.position,
    super.key,
  });

  final ExaminationCard card;
  final ClearanceGate gate;
  final int position;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final danger = AppTone.danger.foreground(theme.brightness);
    final isFees = gate.id == ClearanceGateId.fees;
    final minimum = formatNaira(card.minimumToPayMinorUnits);

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.rowRadius,
        border: Border.all(color: AppTone.danger.border(theme.brightness)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: AppDimensions.iconTileSmall,
                height: AppDimensions.iconTileSmall,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: danger,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  position.toString(),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onError,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n
                      .examCardGateMark(
                        position,
                        ExaminationsLabels.gateTitle(l10n, gate.id),
                      )
                      .toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: danger,
                    fontWeight: AppTextStyles.semiBold,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              StatusTag(
                label: l10n.examCardBlockingTitle,
                tone: AppTone.danger,
                icon: Icons.circle,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Divider(
            height: AppDimensions.hairline,
            color: theme.colorScheme.outlineVariant,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppDimensions.iconLarge,
                height: AppDimensions.iconLarge,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTone.danger.surface(theme.brightness),
                  borderRadius: AppRadii.blockRadius,
                ),
                child: Icon(
                  ClearanceGateTile.iconFor(gate.id),
                  size: AppDimensions.iconMedium,
                  color: danger,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFees
                          ? l10n.examCardFeesBlocking(minimum)
                          : ClearanceGateTile.hint(l10n, gate.id),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: danger,
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                    if (isFees) ...[
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        l10n.examCardPayUnder,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (isFees) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            FeeThresholdSplit(
              minimumLabel: l10n.examCardMinimumToPay,
              minimumValue: minimum,
              outstandingLabel: l10n.examCardOutstanding,
              outstandingValue: formatNaira(card.outstandingMinorUnits),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            FilledButton(
              onPressed: () => context.goNamed(Routes.feesName),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(
                  AppDimensions.primaryActionHeight,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.blockRadius,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.examCardPayAction(minimum)),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  const Icon(
                    Icons.arrow_forward,
                    size: AppDimensions.iconDense,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Minimum to pay beside everything still outstanding.
class FeeThresholdSplit extends StatelessWidget {
  const FeeThresholdSplit({
    required this.minimumLabel,
    required this.minimumValue,
    required this.outstandingLabel,
    required this.outstandingValue,
    super.key,
  });

  final String minimumLabel;
  final String minimumValue;
  final String outstandingLabel;
  final String outstandingValue;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final muted = theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    minimumLabel,
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    minimumValue,
                    style: AppTextStyles.tabular(
                      AppTextStyles.codeLarge.copyWith(
                        color: AppTone.danger.foreground(theme.brightness),
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: AppDimensions.hairline,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      outstandingLabel,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      outstandingValue,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.tabular(
                        AppTextStyles.codeMedium.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The five clearances, joined by a line through their step numbers.
class ClearancePipeline extends StatelessWidget {
  const ClearancePipeline({required this.card, super.key});

  final ExaminationCard card;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final minimum = formatNaira(card.minimumToPayMinorUnits);

    return Stack(
      children: [
        Positioned(
          left: (AppDimensions.iconLarge - AppDimensions.hairline) / 2,
          top: AppDimensions.iconLarge / 2,
          bottom: AppDimensions.iconLarge / 2,
          child: Container(
            width: AppDimensions.hairline,
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        Column(
          children: [
            for (var i = 0; i < card.gates.length; i++) ...[
              if (i > 0) AppSpacing.verticalGap(AppSpacing.md),
              ClearanceGateTile(
                position: i + 1,
                gate: card.gates[i],
                note: _note(l10n, card.gates[i], minimum),
                noteAction: _noteAction(l10n, card.gates[i]),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String? _note(AppLocalizations l10n, ClearanceGate gate, String minimum) {
    if (gate.state == GateState.passed) return null;
    if (gate.id == ClearanceGateId.fees) {
      return l10n.examCardFeesBlocking(minimum);
    }
    return ClearanceGateTile.hint(l10n, gate.id);
  }

  String? _noteAction(AppLocalizations l10n, ClearanceGate gate) {
    if (gate.state == GateState.passed) return null;
    if (gate.id == ClearanceGateId.fees) return l10n.examCardPayUnder;
    return null;
  }
}

/// Senate rule that a card stays unprinted until the bursary clears.
class CardPolicyNote extends StatelessWidget {
  const CardPolicyNote({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.policy_outlined,
                size: AppDimensions.iconDense,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Expanded(
                child: Text(
                  l10n.examCardPolicyTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.examCardPolicyBody,
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

/// A status pip and a short label above the not-issued card.
class CardMetaPill extends StatelessWidget {
  const CardMetaPill({
    required this.label,
    required this.pip,
    required this.background,
    required this.foreground,
    super.key,
  });

  final String label;
  final Color pip;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.indicator,
            height: AppDimensions.indicator,
            decoration: BoxDecoration(color: pip, shape: BoxShape.circle),
          ),
          AppSpacing.horizontalGap(AppSpacing.xs),
          Text(
            label,
            style: context.theme.textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
