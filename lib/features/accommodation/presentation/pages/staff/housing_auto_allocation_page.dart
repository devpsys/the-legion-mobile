import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/auto_allocation_body.dart';
import '../../widgets/staff/housing_page_scaffold.dart';

/// The auto allocation screen of the housing office.
class HousingAutoAllocationPage extends StatelessWidget {
  const HousingAutoAllocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolAutoTitle,
      subtitle: l10n.housingAutoSubtitle,
      builder: (context, state) => AutoAllocationBody(state: state),
    );
  }
}
