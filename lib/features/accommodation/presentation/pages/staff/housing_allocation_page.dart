import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/allocation_detail_body.dart';
import '../../widgets/staff/housing_page_scaffold.dart';

/// The allocation screen of the housing office.
class HousingAllocationPage extends StatelessWidget {
  const HousingAllocationPage({required this.allocationId, super.key});

  final String allocationId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingDetailTitle,
      subtitle: l10n.housingDetailSubtitle,
      breadcrumb: [l10n.housingQueueTitle],
      builder: (context, state) =>
          AllocationDetailBody(state: state, allocationId: allocationId),
    );
  }
}
