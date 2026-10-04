import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/fee_gateway_return_cubit.dart';
import '../bloc/fee_gateway_return_state.dart';
import '../widgets/gateway_return_card.dart';

/// Screen after Pay: awaiting confirmation by default, never a success until
/// the gateway says so.
class FeeGatewayReturnPage extends StatefulWidget {
  const FeeGatewayReturnPage({required this.reference, super.key});

  final String reference;

  @override
  FeeGatewayReturnPageState createState() => FeeGatewayReturnPageState();
}

/// State of [FeeGatewayReturnPage].
class FeeGatewayReturnPageState extends State<FeeGatewayReturnPage> {
  @override
  void initState() {
    super.initState();
    context.read<FeeGatewayReturnCubit>().load(widget.reference);
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

  void _viewReceipt(String receiptId) {
    context.goNamed(
      Routes.feesReceiptName,
      pathParameters: {Routes.feesReceiptIdParam: receiptId},
    );
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
          tooltip: l10n.feesGatewayReturnBackTooltip,
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _notAvailable,
            tooltip: l10n.feesGatewayReturnShareTooltip,
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<FeeGatewayReturnCubit, FeeGatewayReturnState>(
          builder: (context, state) {
            return switch (state.loadStatus) {
              FeeGatewayReturnLoadStatus.initial ||
              FeeGatewayReturnLoadStatus.loading => const LoadingView(),
              FeeGatewayReturnLoadStatus.notFound => EmptyView(
                message: l10n.feesGatewayReturnNotFound,
                icon: Icons.search_off_outlined,
              ),
              FeeGatewayReturnLoadStatus.ready =>
                state.payment == null
                    ? EmptyView(message: l10n.feesGatewayReturnNotFound)
                    : SingleChildScrollView(
                        child: ResponsiveContent(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.xl,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                GatewayReturnCard(
                                  payment: state.payment!,
                                  onCopy: (value) =>
                                      copyGatewayReference(context, value),
                                ),
                                AppSpacing.verticalGap(AppSpacing.xl),
                                if (state.canViewReceipt)
                                  FilledButton.icon(
                                    onPressed: () =>
                                        _viewReceipt(state.payment!.receiptId!),
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size.fromHeight(
                                        AppDimensions.primaryActionHeight,
                                      ),
                                    ),
                                    icon: const Icon(Icons.receipt_long),
                                    label: Text(l10n.feesViewOfficialReceipt),
                                  ),
                                if (state.canViewReceipt) ...[
                                  AppSpacing.verticalGap(AppSpacing.md),
                                  OutlinedButton.icon(
                                    onPressed: _notAvailable,
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(
                                        AppDimensions.primaryActionHeight,
                                      ),
                                    ),
                                    icon: const Icon(Icons.arrow_forward),
                                    iconAlignment: IconAlignment.end,
                                    label: Text(l10n.feesProceedToRegistration),
                                  ),
                                ],
                                AppSpacing.verticalGap(AppSpacing.xl),
                                Text(
                                  l10n.feesGatewayVerifiedStamp.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    letterSpacing: AppTextStyles.trackingCaps,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                AppSpacing.verticalGap(AppSpacing.sm),
                                Text(
                                  l10n.feesGatewaySupport,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
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
