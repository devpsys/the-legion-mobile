import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/block_rooms_body.dart';
import '../../widgets/staff/housing_page_scaffold.dart';

/// The block screen of the housing office.
class HousingBlockPage extends StatelessWidget {
  const HousingBlockPage({
    required this.hostelId,
    required this.blockId,
    super.key,
  });

  final String hostelId;
  final String blockId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingBlockTitle,
      subtitle: l10n.housingBlockSubtitle,
      breadcrumb: [l10n.housingToolHostelsTitle],
      builder: (context, state) =>
          BlockRoomsBody(state: state, hostelId: hostelId, blockId: blockId),
    );
  }
}
