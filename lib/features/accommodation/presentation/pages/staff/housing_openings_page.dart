import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/housing_page_scaffold.dart';
import '../../widgets/staff/openings_body.dart';

/// The openings screen of the housing office.
class HousingOpeningsPage extends StatelessWidget {
  const HousingOpeningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolOpeningsTitle,
      subtitle: l10n.housingOpeningsSubtitle,
      builder: (context, state) => OpeningsBody(state: state),
    );
  }
}
