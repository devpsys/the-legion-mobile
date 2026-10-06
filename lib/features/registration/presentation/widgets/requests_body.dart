import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/registration_cubit.dart';
import '../bloc/registration_state.dart';
import '../models/registration_models.dart';
import 'academic_request_card.dart';
import 'academic_request_form.dart';
import 'registration_card.dart';
import 'registration_chrome.dart';

/// Scrollable body of the Requests tab.
class RequestsBody extends StatelessWidget {
  const RequestsBody({
    required this.state,
    required this.cubit,
    super.key,
  });

  final RegistrationState state;
  final RegistrationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final student = state.student;
    final window = state.window;
    if (student == null || window == null) {
      return const SizedBox.shrink();
    }

    final theme = context.theme;
    final l10n = context.l10n;
    final requests = state.academicRequests;

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
              const RequestsPageHeader(),
              AppSpacing.verticalGap(AppSpacing.md),
              RequestsIdentityBanner(student: student),
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.requestsSubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              IdCardEntryCard(
                onOpen: () => context.goNamed(Routes.registrationIdCardName),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationSectionHeader(
                title: l10n.requestsExistingTitle,
                countLabel: l10n.requestsExistingCount(requests.length),
                trailing: Text(
                  l10n.requestsSessionLabel(window.session),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              if (requests.isEmpty)
                ToneCallout(
                  tone: AppTone.info,
                  icon: Icons.inbox_outlined,
                  title: l10n.requestsEmptyTitle,
                  body: l10n.requestsEmptyBody,
                )
              else
                RegistrationCard(
                  child: Column(
                    children: [
                      for (var i = 0; i < requests.length; i++) ...[
                        if (i > 0)
                          Divider(
                            height: 1,
                            color: theme.colorScheme.outlineVariant,
                          ),
                        AcademicRequestCard(
                          request: requests[i],
                          onWithdraw: requests[i].canWithdraw
                              ? () =>
                                    cubit.requestWithdrawAcademic(requests[i].id)
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),
              AppSpacing.verticalGap(AppSpacing.lg),
              AcademicRequestForm(draft: state.academicDraft, cubit: cubit),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationAboutCard(
                title: l10n.requestsAboutTitle,
                body: l10n.requestsAboutBody,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Breadcrumb and title for the Requests tab.
class RequestsPageHeader extends StatelessWidget {
  const RequestsPageHeader({super.key});

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
                l10n.requestsBreadcrumb,
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
        Text(l10n.requestsTitle, style: theme.textTheme.headlineMedium),
      ],
    );
  }
}

/// Banded student identity strip for the Requests tab.
class RequestsIdentityBanner extends StatelessWidget {
  const RequestsIdentityBanner({required this.student, super.key});

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
                    Icons.assignment_outlined,
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
                    student.programme,
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
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              l10n.registrationStudentProgramme(
                student.programme,
                student.faculty,
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Entry card from Requests into the ID card sibling screen.
class IdCardEntryCard extends StatelessWidget {
  const IdCardEntryCard({required this.onOpen, super.key});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: Material(
        color: theme.colorScheme.surface,
        child: InkWell(
          onTap: onOpen,
          child: Padding(
            padding: AppSpacing.card,
            child: Row(
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
                    color: theme.colorScheme.primary,
                    size: AppDimensions.iconDense,
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.requestsIdCardEntryTitle,
                        style: AppTextStyles.codeMedium.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        l10n.requestsIdCardEntryBody,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: AppTextStyles.relaxedLineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Icon(
                  Icons.chevron_right,
                  size: AppDimensions.iconDense,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
