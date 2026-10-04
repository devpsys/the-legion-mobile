import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/notification_bell.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/admissions_cubit.dart';
import '../bloc/admissions_state.dart';
import '../models/application_detail_models.dart';
import '../widgets/admission_letter_actions.dart';
import '../widgets/admission_letter_document.dart';
import '../widgets/application_choices_card.dart';
import '../widgets/application_detail_top_bar.dart';
import '../widgets/faculty_filter_chips.dart';

/// The admission letter, one step above the application it belongs to.
///
/// Opened from the offer ("read the letter first") and from the matriculated
/// card ("download your admission letter"): both lead here, because the
/// letter is the same document either way and this is the screen it is read
/// and saved from. Back returns to the detail, not the record.
class AdmissionLetterPage extends StatefulWidget {
  const AdmissionLetterPage({required this.applicationId, super.key});

  /// The record's id as it appears in the path, e.g. `app-00042`.
  final String applicationId;

  @override
  AdmissionLetterPageState createState() => AdmissionLetterPageState();
}

/// State of [AdmissionLetterPage].
///
/// Public because private widget classes are banned, and so the copy action
/// can be named by a test.
class AdmissionLetterPageState extends State<AdmissionLetterPage> {
  @override
  void initState() {
    super.initState();
    // Idempotent, as on the detail: a deep link to the letter may be the
    // first thing this session renders.
    context.read<AdmissionsCubit>().load();
  }

  /// Puts the verification code on the clipboard and says so — the one action
  /// on this screen with a service behind it.
  Future<void> copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    context.showMessage(context.l10n.admissionsLetterCodeCopied);
  }

  /// Saving and sharing have no service behind them yet, so a tap reports
  /// that rather than landing in silence.
  void _notLiveYet() => context.showMessage(context.l10n.commonComingSoon);

  void _back() => context.goNamed(
    Routes.admissionsApplicationDetailName,
    pathParameters: {'id': widget.applicationId},
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<AdmissionsCubit, AdmissionsState>(
      builder: (context, state) {
        final detail = state.detailFor(widget.applicationId);

        return Scaffold(
          backgroundColor: AppColors.canvas(context.colors.brightness),
          appBar: ApplicationDetailTopBar(
            reference: detail?.application.trackingCode,
            caption: l10n.admissionsLetterCaption,
            backTooltip: l10n.admissionsLetterBackTooltip,
            onBack: _back,
            user: context.select((AuthCubit cubit) => cubit.state.user),
            onNotifications: () => showNotificationsSheet(context),
            onAvatarTap: () => context.goNamed(Routes.profileName),
          ),
          body: SafeArea(
            top: false,
            child: switch (state.status) {
              AdmissionsStatus.initial ||
              AdmissionsStatus.loading => const LoadingView(),
              AdmissionsStatus.failure => EmptyView(
                message: l10n.errorsServer,
                icon: Icons.cloud_off_outlined,
              ),
              AdmissionsStatus.ready => _ready(state, detail),
            },
          ),
        );
      },
    );
  }

  Widget _ready(AdmissionsState state, ApplicationDetail? detail) {
    final l10n = context.l10n;
    // A stale link, or a record whose detail has not been ported.
    if (detail == null) {
      return EmptyView(message: l10n.admissionsDetailNotFound);
    }
    // A record that has one, but no letter yet — nothing is invented.
    final letter = detail.letter;
    if (letter == null) {
      return EmptyView(
        message: l10n.admissionsLetterNotIssued,
        icon: Icons.description_outlined,
      );
    }

    final application = detail.application;
    final programme = applicationChoiceById(
      state.programmes,
      detail.firstChoiceProgrammeId,
    );
    final theme = context.theme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.canvasGutter,
        vertical: AppSpacing.xl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.maxFormWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdmissionLetterActions(
                onSavePdf: _notLiveYet,
                onShare: _notLiveYet,
                onCopyCode: () => copyCode(letter.verificationCode),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.admissionsLetterKeepNote,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              AdmissionLetterDocument(
                letter: letter,
                reference: application.trackingCode,
                // The candidate the portal is signed in as.
                addresseeName: state.candidate?.displayName,
                programmeName: application.programmeName,
                department: application.department,
                faculty: programme == null
                    ? null
                    : facultyLabel(l10n, programme.faculty),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
