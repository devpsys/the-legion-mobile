import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/housing_page_scaffold.dart';
import '../../widgets/staff/upload_body.dart';

/// The upload screen of the housing office.
class HousingUploadPage extends StatelessWidget {
  const HousingUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolUploadTitle,
      subtitle: l10n.housingUploadSubtitle,
      builder: (context, state) => UploadBody(state: state),
    );
  }
}
