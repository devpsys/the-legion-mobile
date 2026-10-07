import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/dates.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import 'housing_confirm_dialog.dart';
import 'housing_field.dart';
import 'housing_section.dart';

/// Publishes a new version of the accommodation agreement.
///
/// A new version means every student accepts it afresh before booking, so
/// publishing asks for confirmation.
class AgreementBody extends StatefulWidget {
  const AgreementBody({required this.state, super.key});

  final HousingState state;

  @override
  AgreementBodyState createState() => AgreementBodyState();
}

/// State of [AgreementBody]: the summary being drafted.
class AgreementBodyState extends State<AgreementBody> {
  final TextEditingController _summary = TextEditingController();

  @override
  void dispose() {
    _summary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final dates = AppDateFormats.long(l10n.localeName);
    final current = widget.state.currentAgreement;
    final next = (current?.version ?? 0) + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (current != null)
          HousingSection(
            title: l10n.housingAgreementCurrent,
            description: l10n.housingAgreementPublished(
              current.version,
              dates.format(current.publishedOn),
            ),
            children: [
              Text(current.summary, style: theme.textTheme.bodyMedium),
            ],
          ),
        AppSpacing.verticalGap(AppSpacing.md),
        HousingSection(
          title: l10n.housingAgreementPublishTitle(next),
          description: l10n.housingAgreementPublishBody,
          children: [
            HousingField(
              label: l10n.housingAgreementSummary,
              controller: _summary,
              maxLines: 5,
              onChanged: (_) => setState(() {}),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ToneCallout(
              tone: AppTone.warning,
              icon: Icons.warning_amber_outlined,
              body: l10n.housingAgreementWarning,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            FilledButton(
              onPressed: _summary.text.trim().isEmpty
                  ? null
                  : () async {
                      final cubit = context.read<HousingCubit>();
                      final confirmed = await confirmHousingAction(
                        context,
                        title: l10n.housingAgreementConfirmTitle(next),
                        body: l10n.housingAgreementConfirmBody,
                        confirmLabel: l10n.housingAgreementPublish,
                      );
                      if (!confirmed) return;
                      cubit.publishAgreement(_summary.text);
                      _summary.clear();
                      setState(() {});
                    },
              child: Text(l10n.housingAgreementPublish),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.xl),
        Text(l10n.housingAgreementHistory, style: theme.textTheme.titleMedium),
        AppSpacing.verticalGap(AppSpacing.md),
        for (final version in widget.state.agreements) ...[
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.accommodationTermsVersion(version.version),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                        ),
                      ),
                    ),
                    if (version.isCurrent)
                      StatusTag(
                        label: l10n.housingAgreementLive,
                        tone: AppTone.success,
                      ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  dates.format(version.publishedOn),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(version.summary, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
      ],
    );
  }
}
