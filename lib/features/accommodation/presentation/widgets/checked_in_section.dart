import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../models/accommodation_models.dart';
import 'accommodation_labels.dart';
import 'accommodation_support_card.dart';
import 'bed_docket_card.dart';
import 'slip_code_row.dart';

/// A resident: checked in, allocation closed. The docket, the slip, the
/// residence record and the porter lodge.
class CheckedInSection extends StatelessWidget {
  const CheckedInSection({required this.term, super.key});

  final TermAccommodation term;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final bed = term.bed;
    if (bed == null) return const SizedBox.shrink();
    final dates = AppDateFormats.long(l10n.localeName);
    final dateTime = AppDateFormats.longDateTime(l10n.localeName);
    final medium = AppDateFormats.medium(l10n.localeName);
    final checkedInOn = term.checkedInOn;
    final endsOn = term.termEndsOn;
    final code = term.slipCode;
    final keyTag = term.keyTag;
    final locker = term.locker;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BedDocketCard(
          bed: bed,
          statusLabel: l10n.accommodationStatusCheckedIn,
          tone: AppTone.success,
          eyebrow: l10n.accommodationOfficialResident,
          sections: [
            Text(
              checkedInOn == null
                  ? l10n.accommodationResidentDesignated(
                      AccommodationLabels.bedFull(l10n, bed),
                    )
                  : l10n.accommodationCheckedInLine(
                      dates.format(checkedInOn),
                      AccommodationLabels.bedFull(l10n, bed),
                    ),
              style: theme.textTheme.bodyMedium?.copyWith(
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            if (code != null)
              SlipCodeRow(
                code: code,
                hint: l10n.accommodationClearanceHint,
                downloadLabel: l10n.accommodationSlipDownloadPdf,
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.accommodationResidenceRecord,
                  style: theme.textTheme.titleSmall,
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                if (checkedInOn != null) ...[
                  LabelledValueRow(
                    label: l10n.accommodationCheckInDate,
                    value: dateTime.format(checkedInOn),
                    isCode: true,
                  ),
                  AppSpacing.verticalGap(AppSpacing.sm),
                ],
                LabelledValueRow(
                  label: l10n.accommodationTenancyTerm,
                  value: term.label,
                  isCode: true,
                  note: endsOn == null
                      ? null
                      : l10n.accommodationValidUntil(medium.format(endsOn)),
                ),
                if (keyTag != null) ...[
                  AppSpacing.verticalGap(AppSpacing.sm),
                  LabelledValueRow(
                    label: l10n.accommodationKeyTag,
                    value: keyTag,
                    isCode: true,
                  ),
                ],
                if (locker != null) ...[
                  AppSpacing.verticalGap(AppSpacing.sm),
                  LabelledValueRow(
                    label: l10n.accommodationLocker,
                    value: locker,
                  ),
                ],
              ],
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        AccommodationSupportCard(
          title: l10n.accommodationPorterTitle(bed.hostel),
          detail: l10n.accommodationPorterDetail,
          body: l10n.accommodationPorterBody,
        ),
      ],
    );
  }
}
