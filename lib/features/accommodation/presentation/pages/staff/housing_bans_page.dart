import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/bans_body.dart';
import '../../widgets/staff/housing_page_scaffold.dart';

/// The bans screen of the housing office.
class HousingBansPage extends StatelessWidget {
  const HousingBansPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolBansTitle,
      subtitle: l10n.housingBansSubtitle,
      builder: (context, state) => BansBody(state: state),
    );
  }
}
