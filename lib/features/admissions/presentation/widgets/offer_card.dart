import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../models/application_detail_models.dart';
import '../models/programme_models.dart';
import 'faculty_filter_chips.dart';

/// The offer: what the candidate is being given, what it costs, and the date
/// it stops being theirs.
///
/// One card and nothing competing with it. An offer is the single moment in the
/// portal where a candidate has something to lose by not acting, so the
/// deadline gets the loudest block on the page and the two answers sit
/// together at the bottom, one filled and one outlined — declining is allowed,
/// but it is not the action the screen is leaning on, and a red fill beside a
/// navy one is one careless thumb away from an answer that cannot be taken
/// back.
class ApplicationOfferCard extends StatelessWidget {
  const ApplicationOfferCard({
    required this.detail,
    required this.offer,
    required this.programme,
    required this.onReadLetter,
    required this.onAccept,
    required this.onDecline,
    super.key,
  });

  final ApplicationDetail detail;

  final OfferTerms offer;

  /// The catalogue entry the offer is for, to name its faculty. `null` when the
  /// catalogue no longer carries it, in which case only the department is
  /// quoted.
  final Programme? programme;

  /// Opens the admission letter. Offered twice — above the card and below the
  /// deadline — because a candidate deciding wants to read the terms in full
  /// before they commit, wherever on the page that thought arrives.
  final VoidCallback onReadLetter;

  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final application = detail.application;
    final warning = AppTone.warning.foreground(theme.brightness);
    final dateFormat = AppDateFormats.long(l10n.localeName);
    final programme = this.programme;
    final subtitle = programme == null
        ? application.department
        : l10n.admissionsDepartmentInFaculty(
            application.department,
            facultyLabel(l10n, programme.faculty),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: OutlinedButton.icon(
            onPressed: onReadLetter,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, AppDimensions.buttonCompact),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            ),
            icon: const Icon(
              Icons.description_outlined,
              size: AppDimensions.iconDense,
            ),
            label: Text(l10n.admissionsOfferLetter),
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          // Clipped so the gold edge follows the card's own corners.
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: AppDimensions.accentStripeTop,
                color: AppColors.honeyGold,
              ),
              Padding(
                padding: AppSpacing.sheet,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.admissionsOfferEyebrow.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: warning,
                        fontWeight: AppTextStyles.bold,
                        letterSpacing: AppTextStyles.trackingCapsWide,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      application.programmeName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.lg),
                    Divider(
                      height: AppDimensions.hairline,
                      color: theme.colorScheme.outlineVariant,
                    ),
                    AppSpacing.verticalGap(AppSpacing.lg),
                    LabelledValueRow(
                      label: l10n.admissionsOfferLevel,
                      value: l10n.admissionsOfferLevelValue(offer.level),
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    LabelledValueRow(
                      label: l10n.admissionsOfferSession,
                      value: offer.session,
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    // Money is a figure: mono, like every other amount.
                    LabelledValueRow(
                      label: l10n.admissionsOfferFormFee,
                      value: formatNaira(offer.formFeeMinorUnits),
                      isCode: true,
                      note: l10n.admissionsOfferFormFeePaid(
                        dateFormat.format(offer.formFeePaidOn),
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    LabelledValueRow(
                      label: l10n.admissionsOfferAcceptanceFee,
                      value: formatNaira(offer.acceptanceFeeMinorUnits),
                      isCode: true,
                      note: l10n.admissionsOfferAcceptanceFeeDue,
                      noteColor: warning,
                    ),
                    AppSpacing.verticalGap(AppSpacing.xl),
                    OfferDeadlineNotice(acceptBy: offer.acceptBy),
                    AppSpacing.verticalGap(AppSpacing.lg),
                    Text(
                      l10n.admissionsOfferCondition(
                        formatNaira(offer.acceptanceFeeMinorUnits),
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: AppTextStyles.relaxedLineHeight,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xl),
                    FilledButton.icon(
                      onPressed: onAccept,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(
                          0,
                          AppDimensions.primaryActionHeight,
                        ),
                      ),
                      icon: const Icon(
                        Icons.check,
                        size: AppDimensions.iconMedium,
                      ),
                      label: Text(l10n.admissionsOfferAccept),
                    ),
                    AppSpacing.verticalGap(AppSpacing.sm),
                    TextButton.icon(
                      onPressed: onReadLetter,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTone.info.foreground(
                          theme.brightness,
                        ),
                      ),
                      // The arrow trails the label, so the icon sits after it.
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(
                        Icons.arrow_forward,
                        size: AppDimensions.iconSmall,
                      ),
                      label: Text(l10n.admissionsOfferReadLetter),
                    ),
                    AppSpacing.verticalGap(AppSpacing.sm),
                    OutlinedButton(
                      onPressed: onDecline,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTone.danger.foreground(
                          theme.brightness,
                        ),
                        side: BorderSide(
                          color: AppColors.dangerBorder(theme.brightness),
                        ),
                        minimumSize: const Size(
                          0,
                          AppDimensions.primaryActionHeight,
                        ),
                      ),
                      child: Text(l10n.admissionsOfferDecline),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The deadline, in the amber tint reserved for "yours to act on, and soon".
///
/// The most important block on the screen, so it is the only filled one: the
/// date is set larger than anything else in the card, and the sentence under
/// it says what happens at the end of it, because a deadline with no
/// consequence attached is the one that gets missed.
class OfferDeadlineNotice extends StatelessWidget {
  const OfferDeadlineNotice({required this.acceptBy, super.key});

  final DateTime acceptBy;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    const tone = AppTone.warning;
    final foreground = tone.foreground(theme.brightness);

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: tone.surface(theme.brightness),
        borderRadius: AppRadii.blockRadius,
        border: Border.all(color: AppColors.warningBorder(theme.brightness)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: AppDimensions.iconMedium,
                color: foreground,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.admissionsOfferAcceptBy(
                    AppDateFormats.long(l10n.localeName).format(acceptBy),
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foreground,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.admissionsOfferAcceptByNote,
            style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
