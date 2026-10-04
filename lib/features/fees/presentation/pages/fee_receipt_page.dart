import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/status_tag.dart';
import '../bloc/fee_receipt_cubit.dart';
import '../bloc/fee_receipt_state.dart';
import '../models/fees_models.dart';
import '../widgets/receipt_document.dart';

/// Official e-receipt: dark chrome around an always-light paper document.
class FeeReceiptPage extends StatefulWidget {
  const FeeReceiptPage({required this.receiptId, super.key});

  final String receiptId;

  @override
  FeeReceiptPageState createState() => FeeReceiptPageState();
}

/// State of [FeeReceiptPage].
class FeeReceiptPageState extends State<FeeReceiptPage> {
  @override
  void initState() {
    super.initState();
    context.read<FeeReceiptCubit>().load(widget.receiptId);
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.goNamed(Routes.feesName);
  }

  void _notAvailable() {
    context.showMessage(context.l10n.commonComingSoon);
  }

  Future<void> _copyCode(OfficialReceipt receipt) async {
    await Clipboard.setData(
      ClipboardData(
        text: formatReceiptVerificationCode(receipt.verificationCode),
      ),
    );
    if (!mounted) return;
    context.showMessage(context.l10n.feesReceiptCodeCopied);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.canvas(theme.brightness),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: AppColors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: _back,
          tooltip: l10n.feesReceiptBackTooltip,
          icon: const Icon(Icons.arrow_back),
        ),
        title: BlocBuilder<FeeReceiptCubit, FeeReceiptState>(
          builder: (context, state) {
            final number = state.receipt?.receiptNumber;
            return Text(
              number == null
                  ? l10n.feesHistoryHeading
                  : l10n.feesReceiptTitle(number),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: StatusTag(
              label: l10n.feesReceiptVerifiedCleared,
              tone: AppTone.success,
              isUppercase: true,
              icon: Icons.verified_outlined,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<FeeReceiptCubit, FeeReceiptState>(
          builder: (context, state) {
            return switch (state.loadStatus) {
              FeeReceiptLoadStatus.initial ||
              FeeReceiptLoadStatus.loading => const LoadingView(),
              FeeReceiptLoadStatus.notFound => EmptyView(
                message: l10n.feesReceiptNotFound,
                icon: Icons.receipt_long_outlined,
              ),
              FeeReceiptLoadStatus.ready =>
                state.receipt == null
                    ? EmptyView(message: l10n.feesReceiptNotFound)
                    : SingleChildScrollView(
                        child: ResponsiveContent(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.xl,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  l10n.feesReceiptKeepNote,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: AppTextStyles.relaxedLineHeight,
                                  ),
                                ),
                                AppSpacing.verticalGap(AppSpacing.lg),
                                Wrap(
                                  spacing: AppSpacing.sm,
                                  runSpacing: AppSpacing.sm,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: _notAvailable,
                                      icon: const Icon(
                                        Icons.picture_as_pdf_outlined,
                                      ),
                                      label: Text(l10n.feesReceiptSavePdf),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: _notAvailable,
                                      icon: const Icon(Icons.share_outlined),
                                      label: Text(l10n.feesReceiptShare),
                                    ),
                                    FilledButton.tonalIcon(
                                      onPressed: () =>
                                          _copyCode(state.receipt!),
                                      icon: const Icon(Icons.copy_all_outlined),
                                      label: Text(l10n.feesReceiptCopyCode),
                                    ),
                                  ],
                                ),
                                AppSpacing.verticalGap(AppSpacing.xl),
                                ReceiptDocument(receipt: state.receipt!),
                              ],
                            ),
                          ),
                        ),
                      ),
            };
          },
        ),
      ),
    );
  }
}
