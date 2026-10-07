import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/accommodation_models.dart';
import 'accommodation_labels.dart';

/// The compact docket of one bed: its status, the hostel and block, the room
/// and bed, and the room's type, floor and wing — with whatever the phase
/// needs under it (fee, slip, actions) drawn as ruled sections.
class BedDocketCard extends StatelessWidget {
  const BedDocketCard({
    required this.bed,
    required this.statusLabel,
    required this.tone,
    this.eyebrow,
    this.banner,
    this.sections = const [],
    super.key,
  });

  final BedLocation bed;
  final String statusLabel;
  final AppTone tone;

  /// Small mono caption on the right of the status tag, e.g. `PORTAL LOCK`.
  final String? eyebrow;

  /// A countdown or notice drawn between the status row and the bed.
  final Widget? banner;

  /// Ruled sections under the bed.
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final eyebrow = this.eyebrow;
    final banner = this.banner;
    final meta = [
      if (bed.roomType.isNotEmpty) (Icons.people_outline, bed.roomType),
      if (bed.floor.isNotEmpty) (Icons.stairs_outlined, bed.floor),
      if (bed.wing.isNotEmpty) (Icons.explore_outlined, bed.wing),
    ];

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StatusTag(label: statusLabel, tone: tone),
              if (eyebrow != null)
                Text(
                  eyebrow.toUpperCase(),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
            ],
          ),
          if (banner != null) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            banner,
          ],
          AppSpacing.verticalGap(AppSpacing.lg),
          Row(
            children: [
              Icon(
                Icons.apartment_outlined,
                size: AppDimensions.iconMedium,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  bed.hostelBlock,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.single_bed_outlined,
                size: AppDimensions.iconMedium,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  AccommodationLabels.roomBed(l10n, bed),
                  style: AppTextStyles.codeLarge.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          if (meta.isNotEmpty) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.xs,
              children: [
                for (final (icon, label) in meta)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: AppDimensions.iconSmall,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      AppSpacing.horizontalGap(AppSpacing.xs),
                      Text(
                        label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
          for (final section in sections) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Divider(color: theme.colorScheme.outlineVariant),
            AppSpacing.verticalGap(AppSpacing.md),
            section,
          ],
        ],
      ),
    );
  }
}
