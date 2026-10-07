import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/draw_body.dart';
import '../../widgets/staff/housing_page_scaffold.dart';

/// The draw screen of the housing office.
class HousingDrawPage extends StatelessWidget {
  const HousingDrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolDrawTitle,
      subtitle: l10n.housingDrawSubtitle,
      builder: (context, state) => DrawBody(state: state),
    );
  }
}
