import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/allocations_queue_body.dart';
import '../../widgets/staff/housing_page_scaffold.dart';

/// The allocations screen of the housing office.
class HousingAllocationsPage extends StatelessWidget {
  const HousingAllocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingQueueTitle,
      subtitle: l10n.housingQueueSubtitle,
      builder: (context, state) => AllocationsQueueBody(state: state),
    );
  }
}
