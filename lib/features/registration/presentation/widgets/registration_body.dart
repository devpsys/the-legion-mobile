import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../bloc/registration_cubit.dart';
import '../bloc/registration_state.dart';
import '../models/registration_models.dart';
import 'catalogue_section.dart';
import 'registered_courses_section.dart';
import 'registration_card.dart';
import 'registration_deck.dart';
import 'registration_declaration_card.dart';
import 'registration_gate_banner.dart';
import 'registration_header.dart';
import 'registration_view_tabs.dart';
import 'registration_week_section.dart';

/// Scrollable body: tabbed-ledger upper section, week / catalogue, then submit.
///
/// Gate banners appear only for non-default states. Declaration / submit scroll
/// with the page content.
class RegistrationBody extends StatefulWidget {
  const RegistrationBody({required this.state, required this.cubit, super.key});

  final RegistrationState state;
  final RegistrationCubit cubit;

  @override
  RegistrationBodyState createState() => RegistrationBodyState();
}

/// State of [RegistrationBody].
class RegistrationBodyState extends State<RegistrationBody> {
  RegistrationViewTab _tab = RegistrationViewTab.selected;

  bool _showSubmitBar(RegistrationState state) {
    final window = state.window;
    if (window == null) return false;
    return window.state == WindowState.open &&
        state.formStatus != CourseFormStatus.submitted &&
        !state.blocksRegistration;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = widget.cubit;
    final student = state.student;
    final window = state.window;
    final gate = state.gate;
    if (student == null || window == null || gate == null) {
      return const SizedBox.shrink();
    }

    final showGate =
        gate.kind != ResourceGateKind.allowed ||
        window.state == WindowState.addDropOnly;
    final showSubmit = _showSubmitBar(state);

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
              RegistrationHeader(student: student, window: window),
              if (showGate) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                RegistrationGateBanner(gate: gate, window: window),
              ],
              AppSpacing.verticalGap(AppSpacing.md),
              RegistrationDeck(state: state),
              AppSpacing.verticalGap(AppSpacing.lg),
              DisciplineEntryCard(
                onOpen: () =>
                    context.goNamed(Routes.registrationDisciplineName),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationViewTabs(
                selected: _tab,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              if (_tab == RegistrationViewTab.selected) ...[
                RegisteredCoursesSection(
                  state: state,
                  onDrop: cubit.requestDrop,
                  onReadd: cubit.requestReadd,
                ),
                AppSpacing.verticalGap(AppSpacing.xl),
                RegistrationWeekSection(
                  meetings: state.week,
                  session: window.session,
                  termLabel: window.termLabel,
                ),
              ] else
                CatalogueSection(
                  catalogue: state.catalogue,
                  onAdd: cubit.requestAdd,
                  onRequestWaiver: (_) =>
                      context.showMessage(context.l10n.commonComingSoon),
                ),
              if (showSubmit) ...[
                AppSpacing.verticalGap(AppSpacing.xl),
                RegistrationSubmitBar(
                  accepted: state.declarationAccepted,
                  canSubmit: state.canSubmitForm,
                  onChanged: cubit.declarationChanged,
                  onSubmit: () {
                    if (cubit.submitForm()) {
                      context.showMessage(
                        context.l10n.registrationFormSubmitted,
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Entry card from Registration into the Discipline sibling screen.
class DisciplineEntryCard extends StatelessWidget {
  const DisciplineEntryCard({required this.onOpen, super.key});

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
                    Icons.gavel_outlined,
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
                        l10n.disciplineEntryTitle,
                        style: AppTextStyles.codeMedium.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        l10n.disciplineEntryBody,
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
