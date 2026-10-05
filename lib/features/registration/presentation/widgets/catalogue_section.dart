import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/registration_models.dart';
import 'catalogue_course_card.dart';

/// Departmental catalog with search, matching the segmented-deck layout.
class CatalogueSection extends StatefulWidget {
  const CatalogueSection({
    required this.catalogue,
    required this.onAdd,
    required this.onRequestWaiver,
    super.key,
  });

  final List<CatalogueCourse> catalogue;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRequestWaiver;

  @override
  CatalogueSectionState createState() => CatalogueSectionState();
}

/// State of [CatalogueSection].
class CatalogueSectionState extends State<CatalogueSection> {
  final TextEditingController _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<CatalogueCourse> get _filtered {
    final q = _query.text.trim().toLowerCase();
    if (q.isEmpty) return widget.catalogue;
    return widget.catalogue
        .where(
          (c) =>
              c.code.toLowerCase().contains(q) ||
              c.title.toLowerCase().contains(q) ||
              c.section.toLowerCase().contains(q),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    if (widget.catalogue.isEmpty) return const SizedBox.shrink();

    final filtered = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.registrationAddCoursesTitle.toUpperCase(),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: AppTextStyles.trackingCaps,
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
            ),
            Text(
              l10n.registrationCatalogueDepartmental,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        SurfaceCard(
          borderRadius: AppRadii.blockRadius,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _query,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.registrationCatalogueSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.elementRadius,
                  ),
                  isDense: true,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              if (filtered.isEmpty)
                Text(
                  l10n.registrationEmptyCoursesBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                for (var i = 0; i < filtered.length; i++) ...[
                  if (i > 0) ...[
                    AppSpacing.verticalGap(AppSpacing.sm),
                    Divider(
                      height: 1,
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.sm),
                  ],
                  CatalogueCourseCard(
                    course: filtered[i],
                    onAdd: () => widget.onAdd(filtered[i].id),
                    onRequestWaiver: () =>
                        widget.onRequestWaiver(filtered[i].id),
                  ),
                ],
            ],
          ),
        ),
      ],
    );
  }
}
