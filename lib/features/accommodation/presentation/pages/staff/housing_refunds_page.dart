import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/housing_page_scaffold.dart';
import '../../widgets/staff/refunds_body.dart';

/// The refunds screen of the housing office.
class HousingRefundsPage extends StatelessWidget {
  const HousingRefundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolRefundsTitle,
      subtitle: l10n.housingRefundsSubtitle,
      breadcrumb: [l10n.housingToolOpeningsTitle],
      builder: (context, state) => RefundsBody(state: state),
    );
  }
}
