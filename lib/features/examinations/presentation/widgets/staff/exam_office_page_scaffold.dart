import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/loading_view.dart';
import '../../../../../core/widgets/responsive_content.dart';
import '../../../../../core/widgets/state_views.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../bloc/staff/exam_office_state.dart';
import 'exam_office_chrome.dart';
import 'exam_office_notice_listener.dart';
import 'exam_office_section_bar.dart';
import 'exam_office_shell.dart';

/// The frame every examinations office screen shares: task bar, header,
/// loading and failure states, and a scrolling, width-capped body built from
/// the state.
///
/// Keeps the screens themselves down to their content. It asks the cubit to
/// load once, and reports the outcome of each action through a snackbar. A
/// list screen passes its [section] to show the strip that moves between
/// lists.
class ExamOfficePageScaffold extends StatefulWidget {
  const ExamOfficePageScaffold({
    required this.title,
    required this.subtitle,
    required this.builder,
    this.breadcrumb = const [],
    this.section,
    super.key,
  });

  final String title;
  final String subtitle;

  /// Segments before [title] in the breadcrumb; the title is the last.
  final List<String> breadcrumb;
  final ExamOfficeSection? section;

  final Widget Function(BuildContext context, ExamOfficeState state) builder;

  @override
  ExamOfficePageScaffoldState createState() => ExamOfficePageScaffoldState();
}

/// State of [ExamOfficePageScaffold].
class ExamOfficePageScaffoldState extends State<ExamOfficePageScaffold> {
  @override
  void initState() {
    super.initState();
    context.read<ExamOfficeCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final section = widget.section;

    return ExamOfficeNoticeListener(
      child: Scaffold(
        backgroundColor: AppColors.canvas(context.colors.brightness),
        appBar: ExamOfficeTaskBar(
          title: l10n.examOfficeTaskBarTitle,
          subtitle: l10n.examOfficeTaskBarSubtitle,
          onBack: () => goBackFromExamOffice(
            context,
            GoRouterState.of(context).matchedLocation,
          ),
        ),
        body: BlocBuilder<ExamOfficeCubit, ExamOfficeState>(
          builder: (context, state) {
            return switch (state.status) {
              ExamOfficeStatus.initial ||
              ExamOfficeStatus.loading => const LoadingView(),
              ExamOfficeStatus.failure => ErrorView(
                message: state.failureMessage ?? l10n.errorsServer,
                onRetry: context.read<ExamOfficeCubit>().load,
              ),
              ExamOfficeStatus.ready => SingleChildScrollView(
                child: ResponsiveContent(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.md,
                      bottom: AppSpacing.xxl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (section != null) ...[
                          ExamOfficeSectionBar(selected: section),
                          AppSpacing.verticalGap(AppSpacing.md),
                        ],
                        ExamOfficePageHeader(
                          breadcrumb: [
                            l10n.examOfficeBreadcrumbRoot,
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
