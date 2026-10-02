import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/widgets/user_avatar.dart';
import '../mock/hub_fixtures.dart';
import '../widgets/account_services_panel.dart';
import '../widgets/announcement_board.dart';
import '../widgets/hub_drawer.dart';
import '../widgets/hub_header.dart';
import '../widgets/hub_hero_card.dart';
import '../widgets/module_directory.dart';
import '../widgets/next_step_timeline.dart';
import '../widgets/notifications_sheet.dart';
import '../widgets/sign_out_sheet.dart';

/// The student's landing hub: who they are, what blocks them, and everything
/// else the portal exposes.
///
/// Composition only. The content comes from `presentation/mock/` because the
/// hub's endpoints are still pending, so this page reads fixtures and forwards
/// every tap either to a real route or to the "coming soon" message — no
/// datasource is reachable from here.
class HomeOverviewPage extends StatefulWidget {
  const HomeOverviewPage({this.now, super.key});

  /// Injected so the greeting and the term maths are deterministic in tests.
  final DateTime? now;

  @override
  State<HomeOverviewPage> createState() => _HomeOverviewPageState();
}

class _HomeOverviewPageState extends State<HomeOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.user;
        if (user == null) {
          // The router only reaches the hub for an authenticated session, so
          // this is a transient state while the session is being restored.
          return Scaffold(
            appBar: AppBar(),
            body: EmptyView(message: context.l10n.profileNotAvailable),
          );
        }

        return _HubScaffold(user: user, now: widget.now ?? DateTime.now());
      },
    );
  }
}

/// The hub itself, which needs the session's [User] for the greeting, the
/// avatar and the drawer header.
class _HubScaffold extends StatelessWidget {
  const _HubScaffold({required this.user, required this.now});

  final User user;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final term = HubFixtures.term;

    return Scaffold(
      backgroundColor: AppColors.canvas(context.colors.brightness),
      appBar: HubHeader(
        termLabel: '${term.session} · ${term.semesterShort}',
        unreadCount: HubFixtures.unreadAnnouncements,
        avatar: UserAvatar(user: user, size: 32),
        onNotifications: () => NotificationsSheet.show(
          context,
          announcements: HubFixtures.announcements,
        ),
        onAvatarTap: () => context.goNamed(Routes.profileName),
      ),
      drawer: HubDrawer(
        user: user,
        clusters: HubFixtures.clusters,
        onModuleTap: (module) => _onModuleTap(context, module),
      ),
      body: SingleChildScrollView(
        child: ResponsiveContent(
          maxWidth: AppDimensions.maxContentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.verticalGap(AppSpacing.lg),
              HubHeroCard(
                user: user,
                term: term,
                standing: HubFixtures.standing,
                now: now,
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              NextStepTimeline(
                steps: HubFixtures.nextSteps,
                onStepTap: (step) => _onModuleTap(context, step),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              ModuleDirectory(
                clusters: HubFixtures.clusters,
                onModuleTap: (module) => _onModuleTap(context, module),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              AnnouncementBoard(
                announcements: HubFixtures.announcements,
                onSeeAll: () => NotificationsSheet.show(
                  context,
                  announcements: HubFixtures.announcements,
                ),
                onAnnouncementTap: (_) =>
                    context.showMessage(context.l10n.commonComingSoon),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              AccountServicesPanel(
                utilities: HubFixtures.accountUtilities,
                onUtilityTap: (utility) {
                  final routeName = utility.routeName;
                  if (routeName != null) {
                    context.goNamed(routeName);
                    return;
                  }
                  context.showMessage(context.l10n.commonComingSoon);
                },
                onSignOut: () => SignOutSheet.show(
                  context,
                  onConfirm: () => context.read<AuthCubit>().signOut(),
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  /// Portals and timeline steps share one handler until each has a route.
  void _onModuleTap(BuildContext context, Object target) =>
      context.showMessage(context.l10n.commonComingSoon);
}
