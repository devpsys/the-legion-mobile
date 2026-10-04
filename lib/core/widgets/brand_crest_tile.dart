import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../utils/responsive.dart';

/// The university's mark on a document or a public page: a gold tile with
/// the shield.
///
/// Gold rather than navy because these are the places the mark stands for
/// the institution to somebody outside it — a letterhead, a verification page
/// a landlord opens, the form an applicant fills in before they have an
/// account — and honey gold is the brand's attention anchor. Solid, not the
/// designs' gradient: the system does not draw gradients, and a crest that
/// prints the same in every copy is the point of a crest.
class BrandCrestTile extends StatelessWidget {
  const BrandCrestTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.crestTile,
      height: AppDimensions.crestTile,
      decoration: const BoxDecoration(
        color: AppColors.honeyGold,
        borderRadius: AppRadii.elementRadius,
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.shield,
        size: AppDimensions.iconHero,
        color: AppColors.onGoldLight,
      ),
    );
  }
}
