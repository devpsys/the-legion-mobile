import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/hostel_grid_body.dart';
import '../../widgets/staff/housing_page_scaffold.dart';

/// The hostel screen of the housing office.
class HousingHostelPage extends StatelessWidget {
  const HousingHostelPage({required this.hostelId, super.key});

  final String hostelId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingHostelTitle,
      subtitle: l10n.housingHostelSubtitle,
      breadcrumb: [l10n.housingToolHostelsTitle],
      builder: (context, state) =>
          HostelGridBody(state: state, hostelId: hostelId),
    );
  }
}
