import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../models/application_detail_models.dart';
import '../models/programme_models.dart';
import 'status_tag.dart';

/// The localized label of a checklist row's trailing action.
///
/// Lives beside the row rather than in the model because the wording is a
/// question of copy and the model is data: `uploadDocument` reads "Upload"
/// here and would read it on any other screen that ever offers it.
String checklistActionLabel(AppLocalizations l10n, ChecklistAction action) =>
    switch (action) {
      ChecklistAction.none => '',
      ChecklistAction.resendEmail => l10n.admissionsChecklistActionResend,
      ChecklistAction.completePersonalDetails =>
        l10n.admissionsChecklistActionComplete,
      ChecklistAction.claimJamb => l10n.admissionsChecklistActionClaim,
      ChecklistAction.uploadDocument => l10n.admissionsChecklistActionUpload,
      ChecklistAction.inviteReferee => l10n.admissionsChecklistActionInvite,
      ChecklistAction.checkPayment => l10n.admissionsChecklistActionCheck,
    };

/// The glyph that carries a [RequirementState] on this screen.
///
/// Shape first, colour second: a tick, a cross and a clock read apart without
/// the tone at all, which is what keeps the three states honest on a screen
/// where one of them is neither good nor bad.
IconData checklistStateIcon(RequirementState state) => switch (state) {
  RequirementState.met => Icons.check,
  RequirementState.notMet => Icons.close,
  RequirementState.notTracked => Icons.schedule,
};

/// One row of the readiness checklist.
///
/// Three shapes, from the same three states the programme browser evaluates
/// requirements with — the module README's rule, and the reason the amber row
/// carries a "Not tracked" label *and* a clock: an item nobody could answer
/// for must not look like one the candidate failed.
class ApplicationChecklistRow extends StatelessWidget {
  const ApplicationChecklistRow({
    required this.item,
    required this.onAction,
    super.key,
  });

  final ChecklistItem item;

  /// Runs the row's action, or `null` when the row has none to offer — a
  /// completed item is a statement of fact, not a control.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final tone = item.state.tone;
    final action = onAction;

    final title = Text(
      item.title,
      style: theme.textTheme.labelLarge?.copyWith(
        color: action == null
            ? theme.colorScheme.onSurface
            : theme.colorScheme.tertiary,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimensions.checkboxSize,
            height: AppDimensions.checkboxSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tone.surface(theme.brightness),
              shape: BoxShape.circle,
            ),
            child: Icon(
              checklistStateIcon(item.state),
              size: AppDimensions.iconSmall,
              color: tone.foreground(theme.brightness),
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // The link is a second target for the same action rather
                    // than a decorative colour: a candidate reads down the
                    // column and taps the words they have just read, so
                    // leaving them inert would make the row look broken.
                    if (action == null)
                      title
                    else
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: action,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.xs,
                            ),
                            child: title,
                          ),
                        ),
                      ),
                    // Sentence case, the way the light design and the README
                    // both write it: the dark design's capitals are a
                    // flourish, not a different word.
                    if (item.state == RequirementState.notTracked)
                      StatusTag(
                        label: l10n.admissionsNotTracked,
                        tone: AppTone.warning,
                      ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  item.detail,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: AppTextStyles.relaxedLineHeight,
                  ),
                ),
              ],
            ),
          ),
          // The trailing action is the row's real target: 44px tall, as the
          // design gives it. Where there is nothing to do the space stays
          // empty so the detail column ends at the same line on every row.
          action == null
              ? const SizedBox(width: AppDimensions.minTapTarget)
              : TextButton(
                  onPressed: action,
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.tertiary,
                    // Bounded width: the theme's buttons ask for infinite
                    // width, which a `Row` cannot give them.
                    minimumSize: const Size(0, AppDimensions.buttonHeight),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.elementRadius,
                    ),
                  ),
                  child: Text(checklistActionLabel(l10n, item.action)),
                ),
        ],
      ),
    );
  }
}
