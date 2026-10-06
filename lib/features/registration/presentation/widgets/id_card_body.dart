import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../bloc/registration_cubit.dart';
import '../bloc/registration_state.dart';
import '../models/registration_models.dart';
import 'id_card_active_section.dart';
import 'id_card_history_section.dart';
import 'id_card_request_form.dart';
import 'registration_card.dart';
import 'registration_chrome.dart';

/// Scrollable body of the Student ID card screen.
class IdCardBody extends StatelessWidget {
  const IdCardBody({
    required this.state,
    required this.cubit,
    super.key,
  });

  final RegistrationState state;
  final RegistrationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final student = state.student;
    final record = state.idCard;
    if (student == null || record == null) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final active = record.activeRequest;
    final canCancel = active != null &&
        active.canCancel &&
        active.status == IdCardStatus.requested;

    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            AppSpacing.md,
            0,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const IdCardPageHeader(),
              AppSpacing.verticalGap(AppSpacing.md),
              IdCardIdentityBanner(student: student),
              AppSpacing.verticalGap(AppSpacing.lg),
              IdCardActiveSection(
                record: record,
                onCancel: canCancel ? cubit.requestCancelIdCard : null,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              IdCardRequestForm(record: record, cubit: cubit),
              AppSpacing.verticalGap(AppSpacing.lg),
              IdCardHistorySection(record: record),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationAboutCard(
                title: l10n.idCardAboutTitle,
                body: l10n.idCardAboutBody,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Breadcrumb and title for the ID card screen.
class IdCardPageHeader extends StatelessWidget {
  const IdCardPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              l10n.registrationBreadcrumbStudent,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Icon(
              Icons.chevron_right,
              size: AppDimensions.iconMicro,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Flexible(
              child: Text(
                l10n.idCardBreadcrumb,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Text(l10n.idCardTitle, style: theme.textTheme.headlineMedium),
      ],
    );
  }
}

/// Banded student identity strip under the ID card title.
class IdCardIdentityBanner extends StatelessWidget {
  const IdCardIdentityBanner({required this.student, super.key});

  final RegistrationStudent student;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh.withValues(
                alpha: 0.3,
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimensions.avatarSmall,
                  height: AppDimensions.avatarSmall,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: AppRadii.elementRadius,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Icon(
                    Icons.badge_outlined,
                    size: AppDimensions.iconDense,
                    color: theme.colorScheme.primary,
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: AppTextStyles.codeMedium.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        l10n.registrationMatricLevel(
                          l10n.registrationLevel(student.level),
                          student.matricNumber,
                        ),
                        style: AppTextStyles.codeSmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Flexible(
                  child: Text(
                    l10n.idCardProgrammeLevel(
                      student.programme,
                      l10n.registrationLevel(student.level),
                    ),
                    textAlign: TextAlign.right,
                    style: AppTextStyles.codeSmall.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
