import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/housing_page_scaffold.dart';
import '../../widgets/staff/notices_body.dart';

/// The notices screen of the housing office.
class HousingNoticesPage extends StatelessWidget {
  const HousingNoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolNoticesTitle,
      subtitle: l10n.housingNoticesSubtitle,
      builder: (context, state) => NoticesBody(state: state),
    );
  }
}
