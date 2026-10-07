import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/housing_page_scaffold.dart';
import '../../widgets/staff/occupants_body.dart';

/// The occupants screen of the housing office.
class HousingOccupantsPage extends StatelessWidget {
  const HousingOccupantsPage({required this.hostelId, super.key});

  final String hostelId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingOccupantsTitle,
      subtitle: l10n.housingOccupantsSubtitle,
      breadcrumb: [l10n.housingToolHostelsTitle],
      builder: (context, state) =>
          OccupantsBody(state: state, hostelId: hostelId),
    );
  }
}
