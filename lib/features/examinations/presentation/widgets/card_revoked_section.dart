import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/examinations_models.dart';
import 'examinations_labels.dart';

/// A withdrawn card as a split dossier: the credential banner, the audit
/// rows, the hall-door warning and the two next steps.
///
/// A withdrawn card is never drawn as a card.
class CardRevokedSection extends StatelessWidget {
  const CardRevokedSection({
    required this.student,
    required this.card,
    super.key,
  });

  final ExamStudent student;
  final ExaminationCard card;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final reason = card.revokedReason;
    final danger = AppTone.danger.foreground(theme.brightness);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            RevokedMetaPill(
              label: card.examinationName,
              pip: theme.colorScheme.primary,
              background: theme.colorScheme.surfaceContainerHigh,
              foreground: theme.colorScheme.primary,
            ),
            RevokedMetaPill(
              label: l10n.examCardStatusRevoked,
              pip: danger,
              background: AppTone.danger.surface(theme.brightness),
              foreground: danger,
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        SurfaceCard(
          padding: EdgeInsets.zero,
          borderRadius: AppRadii.blockRadius,
          child: ClipRRect(
            borderRadius: AppRadii.blockRadius,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                color: AppTone.danger.surface(theme.brightness),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      size: AppDimensions.iconMedium,
                      color: danger,
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.examRevokedCredentialId.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: muted,
                              fontWeight: AppTextStyles.semiBold,
                              letterSpacing: AppTextStyles.trackingCaps,
                            ),
                          ),
                          Text(
                            card.cardNumber,
                            style: AppTextStyles.codeMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: danger,
                        borderRadius: AppRadii.chipRadius,
                      ),
                      child: Text(
                        l10n.examCardStatusRevoked,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onError,
                          fontWeight: AppTextStyles.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: AppSpacing.card,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppTone.danger.surface(theme.brightness),
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(AppRadii.element),
                        ),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: AppDimensions.accentStripe,
                              color: danger,
                            ),
                            Expanded(
                              child: Padding(
                                padding: AppSpacing.card,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.examRevokedReasonLabel.toUpperCase(),
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: danger,
                                        fontWeight: AppTextStyles.bold,
                                        letterSpacing:
                                            AppTextStyles.trackingCaps,
                                      ),
                                    ),
                                    if (reason != null) ...[
                                      AppSpacing.verticalGap(AppSpacing.xs),
                                      Text(
                                        ExaminationsLabels.revokedReason(
                                          l10n,
                                          reason,
                                        ),
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                          color: danger,
                                          fontWeight: AppTextStyles.bold,
                                        ),
                                      ),
                                    ],
                                    AppSpacing.verticalGap(AppSpacing.xs),
                                    Text(
                                      l10n.examRevokedSpeakOffice,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: AppTextStyles.medium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    Text(
                      l10n.examRevokedBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: muted,
                        height: AppTextStyles.relaxedLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            ),
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        SurfaceCard(
          padding: EdgeInsets.zero,
          borderRadius: AppRadii.blockRadius,
          child: ClipRRect(
            borderRadius: AppRadii.blockRadius,
            child: Column(
            children: [
              RevokedFactRow(
                label: l10n.examRevokedExaminations,
                value: card.examinationName,
                shaded: true,
              ),
              RevokedFactRow(
                label: l10n.examRevokedSessionLabel,
                value: card.sessionLabel,
                isCode: true,
              ),
              RevokedFactRow(
                label: l10n.examRevokedStudentLabel,
                value: l10n.examRevokedStudent(
                  student.matricNumber,
                  student.name,
                ),
                shaded: true,
              ),
              RevokedFactRow(
                label: l10n.examCardCheckCodeLabel,
                value: card.checkCode,
                isCode: true,
                tracked: true,
              ),
            ],
            ),
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        Container(
          padding: AppSpacing.card,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: AppRadii.elementRadius,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.sensor_door_outlined,
                size: AppDimensions.iconMedium,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.examRevokedHallNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: AppTextStyles.relaxedLineHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        FilledButton.icon(
          onPressed: () => context.goNamed(Routes.feesName),
          icon: const Icon(Icons.account_balance_wallet_outlined),
          label: Text(l10n.examRevokedViewFees),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        FilledButton.icon(
          onPressed: () => context.showMessage(l10n.commonComingSoon),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceContainerHigh,
            foregroundColor: theme.colorScheme.onSurface,
          ),
          icon: const Icon(Icons.mail_outline),
          label: Text(l10n.examRevokedContact),
        ),
      ],
    );
  }
}

/// A status pip and a short label above the withdrawn dossier.
class RevokedMetaPill extends StatelessWidget {
  const RevokedMetaPill({
    required this.label,
    required this.pip,
    required this.background,
    required this.foreground,
    super.key,
  });

  final String label;
  final Color pip;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.indicator,
            height: AppDimensions.indicator,
            decoration: BoxDecoration(color: pip, shape: BoxShape.circle),
          ),
          AppSpacing.horizontalGap(AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}

/// One row of the withdrawn card's audit ledger.
class RevokedFactRow extends StatelessWidget {
  const RevokedFactRow({
    required this.label,
    required this.value,
    this.shaded = false,
    this.isCode = false,
    this.tracked = false,
    super.key,
  });

  final String label;
  final String value;
  final bool shaded;
  final bool isCode;
  final bool tracked;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final valueStyle = isCode
        ? AppTextStyles.codeMedium.copyWith(
            fontWeight: tracked ? AppTextStyles.bold : AppTextStyles.medium,
            letterSpacing: tracked ? AppTextStyles.trackingCapsWide : null,
          )
        : theme.textTheme.labelLarge?.copyWith(
            fontWeight: AppTextStyles.medium,
          );

    return Container(
      color: shaded ? theme.colorScheme.surfaceContainerLow : null,
      padding: AppSpacing.card,
      child: Row(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              textAlign: TextAlign.end,
              style: valueStyle,
            ),
          ),
        ],
      ),
    );
  }
}
