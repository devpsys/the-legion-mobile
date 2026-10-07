import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/dates.dart';
import '../../../../../core/utils/money.dart';
import '../../../../../core/widgets/labelled_value_row.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import '../../models/staff/housing_models.dart';
import 'housing_confirm_dialog.dart';
import 'housing_empty_card.dart';
import 'housing_labels.dart';
import 'housing_section.dart';

/// One allocation: the student, the bed, the fee, and the way to cancel it.
class AllocationDetailBody extends StatelessWidget {
  const AllocationDetailBody({
    required this.state,
    required this.allocationId,
    super.key,
  });

  final HousingState state;
  final String allocationId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final record = state.allocationById(allocationId);
    if (record == null) {
      return HousingEmptyCard(
        icon: Icons.search_off,
        title: l10n.housingDetailMissingTitle,
        body: l10n.housingDetailMissingBody,
      );
    }
    final dates = AppDateFormats.longDateTime(l10n.localeName);
    final cancellable =
        record.state != StaffAllocationState.cancelled &&
        record.state != StaffAllocationState.checkedIn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HousingSection(
          title: record.studentName,
          description: l10n.accommodationMatricLevel(
            record.matricNumber,
            record.level,
          ),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: StatusTag(
                label: HousingLabels.allocationState(l10n, record.state),
                tone: HousingLabels.allocationTone(record.state),
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            LabelledValueRow(
              label: l10n.housingDetailProgramme,
              value: record.programme,
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        HousingSection(
          title: l10n.housingDetailBedTitle,
          children: [
            LabelledValueRow(
              label: l10n.housingDetailHostel,
              value: record.bed.hostelBlock,
            ),
            LabelledValueRow(
              label: l10n.housingDetailRoom,
              value: l10n.accommodationRoomBed(record.bed.room, record.bed.bed),
            ),
            LabelledValueRow(
              label: l10n.housingDetailRoomType,
              value: record.bed.roomType,
            ),
            LabelledValueRow(
              label: l10n.housingDetailTerm,
              value: record.termLabel,
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        HousingSection(
          title: l10n.housingDetailRecordTitle,
          children: [
            LabelledValueRow(
              label: l10n.housingDetailFee,
              value: record.feeMinorUnits == 0
                  ? l10n.accommodationPriceFree
                  : formatNaira(record.feeMinorUnits),
              isCode: true,
            ),
            if (record.invoiceReference != null)
              LabelledValueRow(
                label: l10n.housingDetailInvoice,
                value: record.invoiceReference!,
                isCode: true,
              ),
            LabelledValueRow(
              label: l10n.housingDetailMethod,
              value: HousingLabels.method(l10n, record.method),
            ),
            LabelledValueRow(
              label: l10n.housingDetailCreated,
              value: dates.format(record.createdOn),
            ),
          ],
        ),
        if (cancellable) ...[
          AppSpacing.verticalGap(AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () async {
              final cubit = context.read<HousingCubit>();
              final confirmed = await confirmHousingAction(
                context,
                title: l10n.housingCancelTitle,
                body: l10n.housingCancelBody(record.studentName),
                confirmLabel: l10n.housingCancelConfirm,
              );
              if (confirmed) cubit.cancelAllocation(record.id);
            },
            icon: const Icon(Icons.event_busy_outlined),
            label: Text(l10n.housingCancelAction),
          ),
        ],
      ],
    );
  }
}
