import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/categories_body.dart';
import '../../widgets/staff/housing_page_scaffold.dart';

/// The categories screen of the housing office.
class HousingCategoriesPage extends StatelessWidget {
  const HousingCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingPageScaffold(
      title: l10n.housingToolCategoriesTitle,
      subtitle: l10n.housingCategoriesSubtitle,
      builder: (context, state) => CategoriesBody(state: state),
    );
  }
}
