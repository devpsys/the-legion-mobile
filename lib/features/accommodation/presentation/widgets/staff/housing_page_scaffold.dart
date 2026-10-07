import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/loading_view.dart';
import '../../../../../core/widgets/responsive_content.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import 'housing_chrome.dart';
import 'housing_notice_listener.dart';
import 'housing_shell.dart';

/// The frame every housing screen shares: task bar, header, loading and
/// failure states, and a scrolling, width-capped body built from the state.
///
/// Keeps the screens themselves down to their content. It asks the cubit to
/// load once, and reports the outcome of each action through a snackbar.
class HousingPageScaffold extends StatefulWidget {
  const HousingPageScaffold({
    required this.title,
    required this.subtitle,
    required this.builder,
    this.breadcrumb = const [],
    super.key,
  });

  final String title;
  final String subtitle;

  /// Segments before [title] in the breadcrumb; the title is the last.
  final List<String> breadcrumb;

  final Widget Function(BuildContext context, HousingState state) builder;

  @override
  HousingPageScaffoldState createState() => HousingPageScaffoldState();
}

/// State of [HousingPageScaffold].
class HousingPageScaffoldState extends State<HousingPageScaffold> {
  @override
  void initState() {
    super.initState();
    context.read<HousingCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingNoticeListener(
      child: Scaffold(
        backgroundColor: AppColors.canvas(context.colors.brightness),
        appBar: HousingTaskBar(
          title: l10n.housingTaskBarTitle,
          subtitle: l10n.housingTaskBarSubtitle,
          onBack: () => goBackFromHousing(context),
        ),
        body: BlocBuilder<HousingCubit, HousingState>(
          builder: (context, state) {
            return switch (state.status) {
              HousingStatus.initial ||
              HousingStatus.loading => const LoadingView(),
              HousingStatus.failure => ErrorView(
                message: state.failureMessage ?? l10n.errorsServer,
                onRetry: context.read<HousingCubit>().load,
              ),
              HousingStatus.ready => SingleChildScrollView(
                child: ResponsiveContent(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.md,
                      bottom: AppSpacing.xxl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HousingPageHeader(
                          breadcrumb: [
                            l10n.housingBreadcrumbRoot,
                            ...widget.breadcrumb,
                            widget.title,
                          ],
                          title: widget.title,
                          subtitle: widget.subtitle,
                        ),
                        AppSpacing.verticalGap(AppSpacing.lg),
                        widget.builder(context, state),
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
