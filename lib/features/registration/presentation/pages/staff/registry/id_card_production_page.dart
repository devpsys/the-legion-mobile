import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/router/route_names.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/loading_view.dart';
import '../../../../../../core/widgets/message_feedback.dart';
import '../../../../../../core/widgets/state_views.dart';
import '../../../bloc/staff/registry_cubit.dart';
import '../../../bloc/staff/registry_state.dart';
import '../../../mock/staff/registry_fixtures.dart';
import '../../../models/staff/registry_models.dart';
import '../../../widgets/staff/approvals/staff_reject_sheet.dart';
import '../../../widgets/staff/registry/id_card_production_body.dart';
import '../../../widgets/staff/staff_chrome.dart';

/// Registry production queue for student ID cards.
class IdCardProductionPage extends StatefulWidget {
  const IdCardProductionPage({super.key});

  @override
  IdCardProductionPageState createState() => IdCardProductionPageState();
}

/// State of [IdCardProductionPage].
class IdCardProductionPageState extends State<IdCardProductionPage> {
  @override
  void initState() {
    super.initState();
    context.read<RegistryCubit>().load();
  }

  void _preview(IdCardProductionItem item) {
    context.goNamed(
      Routes.staffIdCardPreviewName,
      pathParameters: {Routes.staffIdCardSerialParam: item.serial},
    );
  }

  void _markPrinted(IdCardProductionItem item) {
    final l10n = context.l10n;
    if (context.read<RegistryCubit>().markPrinted(item.serial)) {
      context.showMessage(l10n.staffRegistryPrintedMessage(item.serial));
    } else {
      context.showErrorMessage(l10n.staffRegistryMarkPrintedBlocked);
    }
  }

  void _markCollected(IdCardProductionItem item) {
    final l10n = context.l10n;
    if (context.read<RegistryCubit>().markCollected(item.serial)) {
      context.showMessage(l10n.staffRegistryCollectedMessage(item.serial));
    } else {
      context.showErrorMessage(l10n.errorsServer);
    }
  }

  void _requestCancel(IdCardProductionItem item) {
    context.read<RegistryCubit>().requestCancelIdCard(item.serial);
  }

  Future<void> _presentSheet(RegistryState state) async {
    if (state.sheet != RegistrySheet.cancelIdCard) return;
    final cubit = context.read<RegistryCubit>();
    final serial = state.sheetId;
    if (serial == null) {
      cubit.cancelSheet();
      return;
    }

    final l10n = context.l10n;
    await StaffRejectSheet.show(
      context,
      title: l10n.staffRegistryCancelTitle,
      body: l10n.staffRegistryCancelBody(serial),
      confirmLabel: l10n.staffRegistryCancelConfirm,
      reasonLabel: l10n.staffRegistryCancelReasonLabel,
      reasonHint: l10n.staffRegistryCancelReasonHint,
      initialReason: state.cancelDraft,
      onReasonChanged: cubit.setCancelDraft,
      onConfirm: () {
        final confirmed = cubit.confirmCancelIdCard();
        if (!mounted) return;
        if (confirmed) {
          context.showMessage(l10n.staffRegistryCancelledMessage(serial));
        } else {
          context.showErrorMessage(l10n.staffRegistryCancelReasonRequired);
        }
      },
      onDismissed: () {
        if (cubit.state.sheet != null) cubit.cancelSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<RegistryCubit, RegistryState>(
      listenWhen: (previous, current) =>
          previous.sheet != current.sheet && current.sheet != null,
      listener: (context, state) => _presentSheet(state),
      builder: (context, state) {
        final cubit = context.read<RegistryCubit>();

        return Scaffold(
          backgroundColor: AppColors.canvas(context.theme.brightness),
          appBar: StaffRegistrationTaskBar(
            title: l10n.staffRegistryIdCardsTaskTitle,
            subtitle: RegistryFixtures.officerDesk,
            onBack: () => context.goNamed(Routes.staffStudentsName),
          ),
          body: switch (state.status) {
            RegistryStatus.initial ||
            RegistryStatus.loading => const LoadingView(),
            RegistryStatus.failure => ErrorView(
              message: state.failureMessage ?? l10n.errorsServer,
              onRetry: cubit.load,
            ),
            RegistryStatus.ready => IdCardProductionBody(
              state: state,
              cubit: cubit,
              onPreview: _preview,
              onMarkPrinted: _markPrinted,
              onMarkCollected: _markCollected,
              onCancel: _requestCancel,
            ),
          },
        );
      },
    );
  }
}
