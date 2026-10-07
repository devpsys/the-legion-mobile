import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import 'housing_confirm_dialog.dart';
import 'housing_empty_card.dart';
import 'housing_field.dart';
import 'housing_section.dart';

/// Housing categories and the weight each carries in a priority draw.
class CategoriesBody extends StatefulWidget {
  const CategoriesBody({required this.state, super.key});

  final HousingState state;

  @override
  CategoriesBodyState createState() => CategoriesBodyState();
}

/// State of [CategoriesBody]: the category being drafted.
class CategoriesBodyState extends State<CategoriesBody> {
  final TextEditingController _name = TextEditingController();
  int _weight = 1;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final categories = widget.state.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (categories.isEmpty)
          HousingEmptyCard(
            icon: Icons.category_outlined,
            title: l10n.housingCategoriesEmptyTitle,
            body: l10n.housingCategoriesEmptyBody,
          ),
        for (final category in categories) ...[
          SurfaceCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        l10n.housingCategoryLine(
                          category.weight,
                          category.studentCount,
                        ),
                        style: AppTextStyles.codeSmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final cubit = context.read<HousingCubit>();
                    final confirmed = await confirmHousingAction(
                      context,
                      title: l10n.housingCategoryRemoveTitle(category.name),
                      body: l10n.housingCategoryRemoveBody,
                      confirmLabel: l10n.housingCategoryRemove,
                    );
                    if (confirmed) cubit.removeCategory(category.id);
                  },
                  tooltip: l10n.housingCategoryRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
        AppSpacing.verticalGap(AppSpacing.md),
        HousingSection(
          title: l10n.housingCategoryAddTitle,
          children: [
            HousingField(
              label: l10n.housingCategoryName,
              controller: _name,
              onChanged: (_) => setState(() {}),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            HousingStepper(
              label: l10n.housingCategoryWeight,
              value: _weight,
              min: 1,
              max: 10,
              onChanged: (value) => setState(() => _weight = value),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            FilledButton(
              onPressed: _name.text.trim().isEmpty
                  ? null
                  : () {
                      context.read<HousingCubit>().addCategory(
                        name: _name.text,
                        weight: _weight,
                      );
                      _name.clear();
                      setState(() {});
                    },
              child: Text(l10n.housingCategoryAdd),
            ),
          ],
        ),
      ],
    );
  }
}
