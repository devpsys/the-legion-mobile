import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/notification_bell.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/admissions_cubit.dart';
import '../bloc/admissions_state.dart';
import '../bloc/jamb_claim_cubit.dart';
import '../bloc/jamb_claim_state.dart';
import '../widgets/admissions_tab_bar.dart';
import '../widgets/admissions_task_bar.dart';
import '../widgets/jamb_claim_body.dart';
import '../widgets/jamb_claim_form.dart';

/// The JAMB tab: claiming the UTME result CAPS sent the university.
///
/// Design: `ui-designs/admissions/claim_jamb_result_light/code.html`.
///
/// Composition only, like the other three tabs, and under the same chrome:
/// the design draws a focused back-chevron bar, but this is a section of the
/// portal and wears the portal's bar so the four tabs read as one place.
///
/// Two cubits meet here and the
/// page is what joins them: [JambClaimCubit] answers whose result the typed
/// facts name, and [AdmissionsCubit] — the portal's record — is what the
/// result is linked to once the candidate confirms. The page forwards input
/// to the first and the decision to the second; it validates nothing itself.
class JambClaimPage extends StatefulWidget {
  const JambClaimPage({this.now, super.key});

  /// Injected so the date picker's bounds are deterministic.
  final DateTime? now;

  @override
  JambClaimPageState createState() => JambClaimPageState();
}

/// State of [JambClaimPage].
///
/// Public because private widget classes are banned.
class JambClaimPageState extends State<JambClaimPage> {
  final _controllers = JambClaimControllers();

  /// The oldest birthday the picker offers. Nobody sitting the UTME was born
  /// before this; the bound keeps the year wheel short.
  static const int pickerSpanYears = 80;

  /// Where the picker opens with nothing chosen: eighteen years back, the
  /// age most candidates are.
  static const int typicalCandidateAge = 18;

  @override
  void initState() {
    super.initState();
    // Idempotent: the overview has usually loaded the portal already, and
    // going back to it must not throw the record away.
    context.read<AdmissionsCubit>().load();
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    FocusScope.of(context).unfocus();
    final cubit = context.read<JambClaimCubit>();
    final now = widget.now ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      helpText: context.l10n.admissionsJambDateOfBirthPickerTitle,
      initialDate:
          cubit.state.dateOfBirth ??
          DateTime(now.year - typicalCandidateAge, now.month, now.day),
      firstDate: DateTime(now.year - pickerSpanYears),
      lastDate: now,
    );
    if (picked == null) return;
    cubit.dateOfBirthChanged(picked);
  }

  void _match() {
    FocusScope.of(context).unfocus();
    context.read<JambClaimCubit>().match();
  }

  /// Binds the matched record to the application — the one irreversible act
  /// on this screen, and the one the warning on the form is about.
  void _confirm() {
    final result = context.read<JambClaimCubit>().state.result;
    if (result == null) return;
    context.read<AdmissionsCubit>().linkJambResult(result);
    context.showMessage(context.l10n.admissionsJambLinkedMessage);
  }

  void _help() => context.showMessage(context.l10n.commonComingSoon);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Back is handled by `AdmissionsShell`, which sits in the root navigator.
    return BlocListener<JambClaimCubit, JambClaimState>(
      // The date lives on the cubit; the field only shows it.
      listenWhen: (previous, current) =>
          previous.dateOfBirth != current.dateOfBirth,
      listener: (context, state) {
        final date = state.dateOfBirth;
        _controllers.dateOfBirth.text = date == null
            ? ''
            : AppDateFormats.field(l10n.localeName).format(date);
      },
      child: BlocBuilder<AdmissionsCubit, AdmissionsState>(
        builder: (context, state) {
          final claim = context.read<JambClaimCubit>();
          return Scaffold(
            backgroundColor: AppColors.canvas(context.colors.brightness),
            // The portal's own bar, as on the other three tabs: the design
            // draws a back chevron here, but a tab is a section, not a step,
            // and back is the system gesture — handled by `AdmissionsShell`.
            appBar: AdmissionsTaskBar(
              cycleLabel: state.cycleLabelFor(l10n.admissionsTitle),
              user: context.select((AuthCubit cubit) => cubit.state.user),
              onAvatarTap: () => context.goNamed(Routes.profileName),
              onNotifications: () => showNotificationsSheet(context),
            ),
            body: switch (state.status) {
              AdmissionsStatus.initial ||
              AdmissionsStatus.loading => const LoadingView(),
              AdmissionsStatus.failure => EmptyView(message: l10n.errorsServer),
              AdmissionsStatus.ready => JambClaimBody(
                admissions: state,
                controllers: _controllers,
                onRegistrationNumberChanged: claim.registrationNumberChanged,
                onSurnameChanged: claim.surnameChanged,
                onPickDateOfBirth: _pickDateOfBirth,
                onMatch: _match,
                onConfirm: _confirm,
                onHelp: _help,
              ),
            },
            bottomNavigationBar: AdmissionsTabBar(
              // The last of the portal's four tabs.
              selectedIndex: 3,
              jambBadge: state.jambResultPending,
              onDestinationSelected: (index) =>
                  selectAdmissionsTab(context, index),
            ),
          );
        },
      ),
    );
  }
}
