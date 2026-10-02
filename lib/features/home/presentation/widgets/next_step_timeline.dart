import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/hub_models.dart';
import 'hub_card.dart';
import 'hub_tone_colors.dart';

/// "Do this next" — the sequential flow of everything standing between the
/// student and a registered term.
///
/// The steps are connected by a single vertical rail with a node per step, so
/// the dependency order is visible at a glance: a step further down the rail
/// cannot be reached before the ones above it clear.
class NextStepTimeline extends StatelessWidget {
  const NextStepTimeline({required this.steps, this.onStepTap, super.key});

  final List<TimelineStep> steps;

  /// Invoked for steps that lead somewhere; cleared steps ignore taps.
  final void Function(TimelineStep step)? onStepTap;

  @override
  Widget build(BuildContext context) {
    final outstanding = steps
        .where((step) => step.state != TimelineStepState.done)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HubSectionHeading(
          title: context.l10n.homeDoThisNext,
          subtitle: context.l10n.homeSequentialFlow,
          trailing: HubCountPill(count: outstanding),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        _TimelineRail(steps: steps, onStepTap: onStepTap),
      ],
    );
  }
}

/// The connector line, drawn once behind the step cards.
///
/// Each step is a row whose left gutter holds the rail: the line is painted
/// behind the card and the node marker sits on it. Segmenting it per row —
/// rather than as one tall line — is what keeps markers aligned with cards
/// whose heights differ.
class _TimelineRail extends StatelessWidget {
  const _TimelineRail({required this.steps, this.onStepTap});

  final List<TimelineStep> steps;
  final void Function(TimelineStep step)? onStepTap;

  /// Diameter of a rail node marker.
  static const double _nodeDiameter = 24;

  /// Vertical offset of the marker from the top of a card, aligned with the
  /// centre of the card's icon tile.
  static const double _nodeTop = AppSpacing.md + 8;

  @override
  Widget build(BuildContext context) {
    final lineColor = context.colors.outlineVariant;
    final lineInset = _nodeDiameter / 2 - 1;
    final cardInset = _nodeDiameter + AppSpacing.sm;
    final lastIndex = steps.length - 1;

    return Column(
      children: [
        for (var index = 0; index < steps.length; index++)
          Padding(
            padding: EdgeInsets.only(
              bottom: index == lastIndex ? 0 : AppSpacing.md,
            ),
            child: Stack(
              children: [
                // The rail is drawn only between markers: the first step has
                // nothing above it, and the last one stops at its own marker
                // instead of trailing off into empty space.
                if (index > 0)
                  Positioned(
                    left: lineInset,
                    top: 0,
                    bottom: index == lastIndex ? null : 0,
                    height: index == lastIndex
                        ? _nodeTop + _nodeDiameter / 2
                        : null,
                    child: Container(width: 2, color: lineColor),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: cardInset),
                    Expanded(
                      child: TimelineStepCard(
                        step: steps[index],
                        onTap: steps[index].isInteractive && onStepTap != null
                            ? () => onStepTap!(steps[index])
                            : null,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  top: _nodeTop,
                  child: _TimelineNode(
                    step: steps[index],
                    diameter: _nodeDiameter,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Marker on the rail: a solid dot for actionable work, a lock when blocked,
/// an hourglass while waiting on the institution, a check once cleared.
class _TimelineNode extends StatelessWidget {
  const _TimelineNode({required this.step, required this.diameter});

  final TimelineStep step;
  final double diameter;

  IconData get _icon => switch (step.state) {
    TimelineStepState.actionable => Icons.circle,
    TimelineStepState.blocked => Icons.lock_outline,
    TimelineStepState.waiting => Icons.hourglass_top,
    TimelineStepState.done => Icons.check,
  };

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final tone = step.state.tone;

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: tone.surface(theme.brightness),
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.surface, width: 2),
      ),
      alignment: Alignment.center,
      // The design marks actionable work with a filled pip rather than a
      // glyph, so the eye goes to the only step that can be taken now.
      child: step.state == TimelineStepState.actionable
          ? Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: tone.foreground(theme.brightness),
                shape: BoxShape.circle,
              ),
            )
          : Icon(_icon, size: 14, color: tone.foreground(theme.brightness)),
    );
  }
}

/// Width of a step card's status stripe.
const double _accentWidth = 4;

/// One step: a status-coloured card with a leading icon tile and a trailing tag.
class TimelineStepCard extends StatelessWidget {
  const TimelineStepCard({required this.step, this.onTap, super.key});

  final TimelineStep step;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final tone = step.state.tone;
    final isCleared = step.state == TimelineStepState.done;

    return Opacity(
      opacity: isCleared ? 0.95 : 1,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.rowRadius,
        // The status stripe is painted as a bar rather than as a bordered
        // side: Flutter rejects a non-uniform border on a rounded box.
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: _accentWidth,
                  color: tone.accent(theme.brightness),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  _accentWidth + AppSpacing.md + 2,
                  AppSpacing.md + 2,
                  AppSpacing.md + 2,
                  AppSpacing.md + 2,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: tone.surface(theme.brightness),
                        borderRadius: AppRadii.elementRadius,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        step.icon,
                        size: 19,
                        color: tone.foreground(theme.brightness),
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            step.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AppSpacing.verticalGap(AppSpacing.xs),
                          _StepDetail(step: step),
                        ],
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HubTag(label: _tagLabel(context), tone: tone),
                        AppSpacing.verticalGap(AppSpacing.sm),
                        Icon(
                          Icons.chevron_right,
                          size: AppDimensions.iconMedium,
                          color: context.colors.outline,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// `Due 3 October` for actionable work, otherwise the state's word.
  String _tagLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (step.state) {
      TimelineStepState.actionable =>
        step.dueOn == null
            ? l10n.homeStepActionable
            : l10n.homeDueOn(
                DateFormat.MMMd(l10n.localeName).format(step.dueOn!),
              ),
      TimelineStepState.blocked => l10n.homeStepBlocked,
      TimelineStepState.waiting => l10n.homeStepWaiting,
      TimelineStepState.done => l10n.homeStepDone,
    };
  }
}

/// Detail line of a step, with amounts set in the mono face.
class _StepDetail extends StatelessWidget {
  const _StepDetail({required this.step});

  final TimelineStep step;

  @override
  Widget build(BuildContext context) {
    final base = context.textStyles.bodySmall?.copyWith(fontSize: 13);

    return Text.rich(
      TextSpan(
        children: [
          for (final run in step.detail)
            TextSpan(
              text: run.text,
              style: run.isEmphasised
                  ? AppTextStyles.codeSmall.copyWith(
                      fontSize: 12,
                      color: context.colors.onSurface,
                      fontWeight: AppTextStyles.semiBold,
                    )
                  : base,
            ),
        ],
      ),
    );
  }
}
