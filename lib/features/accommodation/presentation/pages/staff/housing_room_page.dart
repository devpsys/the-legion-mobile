import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/housing_page_scaffold.dart';
import '../../widgets/staff/room_settings_body.dart';

/// The room screen of the housing office.
class HousingRoomPage extends StatelessWidget {
  const HousingRoomPage({
    required this.hostelId,
    required this.roomId,
    super.key,
  });

  final String hostelId;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingRoomTitle,
      subtitle: l10n.housingRoomSubtitle,
      breadcrumb: [l10n.housingToolHostelsTitle],
      builder: (context, state) =>
          RoomSettingsBody(state: state, hostelId: hostelId, roomId: roomId),
    );
  }
}
