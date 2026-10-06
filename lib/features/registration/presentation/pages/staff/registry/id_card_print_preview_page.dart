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
import '../../../models/staff/registry_models.dart';
import '../../../widgets/staff/registry/id_card_print_preview_body.dart';
import '../../../widgets/staff/staff_chrome.dart';

/// Print preview of one ID card, with Mark printed for the registry officer.
class IdCardPrintPreviewPage extends StatefulWidget {
  const IdCardPrintPreviewPage({required this.serial, super.key});

  /// The card serial as it arrives in the route (percent-encoded).
  final String serial;

  @override
  IdCardPrintPreviewPageState createState() => IdCardPrintPreviewPageState();
}

/// State of [IdCardPrintPreviewPage].
class IdCardPrintPreviewPageState extends State<IdCardPrintPreviewPage> {
  String get _serial {
    try {
      return Uri.decodeComponent(widget.serial);
    } on FormatException {
      return widget.serial;
    }
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<RegistryCubit>();
    cubit
      ..load()
      ..openPreview(_serial);
  }

  @override
  void didUpdateWidget(IdCardPrintPreviewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.serial != widget.serial) {
      context.read<RegistryCubit>().openPreview(_serial);
    }
  }

  bool _canMarkPrinted(RegistryState state, String serial) {
    for (final card in state.idCards) {
      if (card.serial == serial) return card.canMarkPrinted;
    }
    return false;
  }

  void _markPrinted(String serial) {
    final l10n = context.l10n;
    if (context.read<RegistryCubit>().markPrinted(serial)) {
      context.showMessage(l10n.staffRegistryPrintedMessage(serial));
    } else {
      context.showErrorMessage(l10n.staffRegistryMarkPrintedBlocked);
    }
  }

  void _verify(IdCardPrintPreview preview) {
    final code = preview.verificationCode;
    if (code == null) return;
    context.goNamed(
      Routes.verifyIdCardName,
      queryParameters: {Routes.verifyIdCardCodeParam: code},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<RegistryCubit, RegistryState>(
      builder: (context, state) {
        final cubit = context.read<RegistryCubit>();
        final preview = state.preview;

        return Scaffold(
          backgroundColor: AppColors.canvas(context.theme.brightness),
          appBar: StaffRegistrationTaskBar(
            title: l10n.staffRegistryPreviewTaskTitle,
            subtitle: _serial,
            onBack: () => context.goNamed(Routes.staffIdCardsName),
          ),
          body: switch (state.status) {
            RegistryStatus.initial ||
            RegistryStatus.loading => const LoadingView(),
            RegistryStatus.failure => ErrorView(
              message: state.failureMessage ?? l10n.errorsServer,
              onRetry: cubit.load,
            ),
            RegistryStatus.ready =>
              preview == null
                  ? const LoadingView()
                  : IdCardPrintPreviewBody(
                      preview: preview,
                      canMarkPrinted: _canMarkPrinted(state, preview.serial),
                      onMarkPrinted: () => _markPrinted(preview.serial),
                      onVerify: () => _verify(preview),
                    ),
          },
        );
      },
    );
  }
}
