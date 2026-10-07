import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/allocate_body.dart';
import '../../widgets/staff/housing_page_scaffold.dart';

/// The allocate screen of the housing office.
class HousingAllocatePage extends StatelessWidget {
  const HousingAllocatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolAllocateTitle,
      subtitle: l10n.housingAllocateSubtitle,
      builder: (context, state) => AllocateBody(state: state),
    );
  }
}
