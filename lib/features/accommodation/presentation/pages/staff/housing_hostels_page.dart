import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/hostels_body.dart';
import '../../widgets/staff/housing_page_scaffold.dart';

/// The hostels screen of the housing office.
class HousingHostelsPage extends StatelessWidget {
  const HousingHostelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolHostelsTitle,
      subtitle: l10n.housingHostelsSubtitle,
      builder: (context, state) => HostelsBody(state: state),
    );
  }
}
