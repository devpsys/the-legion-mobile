import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../models/accommodation_models.dart';

/// The accommodation terms: the numbered covenants and the box that accepts
/// them. Accepting records this version against the student's account.
class AccommodationTermsBody extends StatefulWidget {
  const AccommodationTermsBody({
    required this.agreement,
    required this.termLabel,
    required this.alreadyAccepted,
    required this.onAccept,
    super.key,
  });

  final AccommodationAgreement agreement;
  final String termLabel;

  /// The student has no term waiting on the agreement, so there is nothing to
  /// accept; the covenants are shown for reading.
  final bool alreadyAccepted;
  final VoidCallback onAccept;

  @override
  AccommodationTermsBodyState createState() => AccommodationTermsBodyState();
}

/// State of [AccommodationTermsBody]: the tick and whether a submit has been
/// attempted without it.
class AccommodationTermsBodyState extends State<AccommodationTermsBody> {
  bool _isAccepted = false;
  bool _showError = false;

  void _submit() {
    if (!_isAccepted) {
      setState(() => _showError = true);
      return;
    }
    widget.onAccept();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final agreement = widget.agreement;

    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.gavel_outlined,
                    size: AppDimensions.iconHero,
                    color: theme.colorScheme.primary,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.accommodationTermsGovernance,
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: AppTextStyles.trackingCaps,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              Text(
                l10n.accommodationTermsHeadline,
                style: theme.textTheme.headlineSmall,
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                l10n.accommodationTermsGate,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.accommodationTermsTitle,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          l10n.accommodationTermsVersion(agreement.version),
                          style: AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.accommodationTermsIntro(
                        agreement.version,
                        widget.termLabel,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.lg),
                    for (var i = 0; i < agreement.clauses.length; i++) ...[
                      if (i > 0) AppSpacing.verticalGap(AppSpacing.lg),
                      AgreementClauseTile(
                        number: i + 1,
                        clause: agreement.clauses[i],
                      ),
                    ],
                  ],
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              if (widget.alreadyAccepted)
                ToneCallout(
                  tone: AppTone.success,
                  icon: Icons.verified_outlined,
                  body: l10n.accommodationTermsAccepted(agreement.version),
                )
              else ...[
                CheckboxListTile(
                  value: _isAccepted,
                  onChanged: (value) => setState(() {
                    _isAccepted = value ?? false;
                    if (_isAccepted) _showError = false;
                  }),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.accommodationTermsCheckbox),
                ),
                if (_showError) ...[
                  AppSpacing.verticalGap(AppSpacing.sm),
                  ToneCallout(
                    tone: AppTone.danger,
                    icon: Icons.error_outline,
                    body: l10n.accommodationTermsTickError,
                  ),
                ],
                AppSpacing.verticalGap(AppSpacing.md),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(l10n.accommodationTermsAccept),
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                Row(
                  children: [
                    Icon(
                      Icons.verified_outlined,
                      size: AppDimensions.iconSmall,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.accommodationTermsRecordNote,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              AppSpacing.verticalGap(AppSpacing.lg),
              Center(
                child: Text(
                  l10n.accommodationTermsSeal(agreement.reference),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One numbered covenant of the agreement.
class AgreementClauseTile extends StatelessWidget {
  const AgreementClauseTile({
    required this.number,
    required this.clause,
    super.key,
  });

  final int number;
  final AgreementClause clause;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppDimensions.marker,
          height: AppDimensions.marker,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: AppRadii.checkboxRadius,
          ),
          child: Text(number.toString(), style: AppTextStyles.codeSmall),
        ),
        AppSpacing.horizontalGap(AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clause.title,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                clause.body,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
              if (clause.isLoadBearing) ...[
                AppSpacing.verticalGap(AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      size: AppDimensions.iconSmall,
                      color: AppTone.warning.foreground(theme.brightness),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.xs),
                    Expanded(
                      child: Text(
                        l10n.accommodationClauseLoadBearing,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTone.warning.foreground(theme.brightness),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
