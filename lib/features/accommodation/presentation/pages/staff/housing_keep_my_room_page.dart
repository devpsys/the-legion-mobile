import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/housing_page_scaffold.dart';
import '../../widgets/staff/keep_my_room_body.dart';

/// The keep my room screen of the housing office.
class HousingKeepMyRoomPage extends StatelessWidget {
  const HousingKeepMyRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolKeepTitle,
      subtitle: l10n.housingKeepSubtitle,
      builder: (context, state) => KeepMyRoomBody(state: state),
    );
  }
}
