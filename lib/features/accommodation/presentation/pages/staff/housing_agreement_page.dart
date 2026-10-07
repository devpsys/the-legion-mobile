import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/agreement_body.dart';
import '../../widgets/staff/housing_page_scaffold.dart';

/// The agreement screen of the housing office.
class HousingAgreementPage extends StatelessWidget {
  const HousingAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolAgreementTitle,
      subtitle: l10n.housingAgreementSubtitle,
      builder: (context, state) => AgreementBody(state: state),
    );
  }
}
