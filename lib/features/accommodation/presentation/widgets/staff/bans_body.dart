import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/dates.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import 'housing_confirm_dialog.dart';
import 'housing_empty_card.dart';
import 'housing_field.dart';
import 'housing_section.dart';

/// Students barred from booking a bed, and the form to bar another.
class BansBody extends StatefulWidget {
  const BansBody({required this.state, super.key});

  final HousingState state;

  @override
  BansBodyState createState() => BansBodyState();
}

/// State of [BansBody]: the ban being drafted.
class BansBodyState extends State<BansBody> {
  final TextEditingController _matric = TextEditingController();
  final TextEditingController _reason = TextEditingController();
  bool _rejected = false;

  @override
  void dispose() {
    _matric.dispose();
    _reason.dispose();
    super.dispose();
  }

  void _add() {
    final added = context.read<HousingCubit>().addBan(
      matricNumber: _matric.text,
      reason: _reason.text,
    );
    setState(() => _rejected = !added);
    if (added) {
      _matric.clear();
      _reason.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final dates = AppDateFormats.medium(l10n.localeName);
    final bans = widget.state.bans;
    final ready =
        _matric.text.trim().isNotEmpty && _reason.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (bans.isEmpty)
          HousingEmptyCard(
            icon: Icons.verified_user_outlined,
            title: l10n.housingBansEmptyTitle,
            body: l10n.housingBansEmptyBody,
          ),
        for (final ban in bans) ...[
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  ban.studentName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.housingBanSince(
                    ban.matricNumber,
                    dates.format(ban.since),
                  ),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(ban.reason, style: theme.textTheme.bodySmall),
                AppSpacing.verticalGap(AppSpacing.sm),
                OutlinedButton(
                  onPressed: () async {
                    final cubit = context.read<HousingCubit>();
                    final confirmed = await confirmHousingAction(
                      context,
                      title: l10n.housingBanLiftTitle(ban.studentName),
                      body: l10n.housingBanLiftBody,
                      confirmLabel: l10n.housingBanLift,
                    );
                    if (confirmed) cubit.liftBan(ban.id);
                  },
                  child: Text(l10n.housingBanLift),
                ),
              ],
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
        AppSpacing.verticalGap(AppSpacing.md),
        HousingSection(
          title: l10n.housingBanAddTitle,
          description: l10n.housingBanAddBody,
          children: [
            HousingField(
              label: l10n.housingAllocateMatric,
              controller: _matric,
              hint: l10n.accommodationSwapMatricHint,
              errorText: _rejected ? l10n.housingBanRejected : null,
              onChanged: (_) => setState(() => _rejected = false),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            HousingField(
              label: l10n.housingBanReason,
              controller: _reason,
              maxLines: 3,
              onChanged: (_) => setState(() {}),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            FilledButton(
              onPressed: ready ? _add : null,
              child: Text(l10n.housingBanAdd),
            ),
          ],
        ),
      ],
    );
  }
}
