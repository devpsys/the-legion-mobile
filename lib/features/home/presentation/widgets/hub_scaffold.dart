import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/notification_bell.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/widgets/user_avatar.dart';
import '../mock/hub_fixtures.dart';
import '../models/hub_models.dart';
import 'account_services_panel.dart';
import 'announcement_board.dart';
import 'hub_drawer.dart';
import 'hub_header.dart';
import 'hub_hero_card.dart';
import 'module_directory.dart';
import 'next_step_timeline.dart';
import 'sign_out_sheet.dart';

/// The hub's screen: fixed task bar, drawer, and the scrolling sections.
/// The hub itself, which needs the session's [User] for the greeting, the
/// avatar and the drawer header.

class HubScaffold extends StatelessWidget {
  const HubScaffold({required this.user, required this.now, super.key});

  final User user;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final term = HubFixtures.term;

    return Scaffold(
      backgroundColor: AppColors.canvas(context.colors.brightness),
      appBar: HubHeader(
        termLabel: '${term.session} · ${term.semesterShort}',
        avatar: UserAvatar(user: user, size: AppDimensions.avatarSmall),
        onNotifications: () => showNotificationsSheet(context),
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
                onSeeAll: () => showNotificationsSheet(context),
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
  void _onModuleTap(BuildContext context, Object target) {
    // A portal that names a route is a screen; the rest are not built yet.
    if (target is PortalModule && target.routeName != null) {
      context.goNamed(target.routeName!);
      return;
    }
    context.showMessage(context.l10n.commonComingSoon);
  }
}
