import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/widgets/user_avatar.dart';

/// Profile tab of the authenticated area.
///
/// Presentation-only feature: it renders the session that the auth feature
/// already owns, so it needs neither its own repository nor use cases.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static final DateFormat _dateFormat = DateFormat.yMMMd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileTitle)),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state.user;
          if (user == null) {
            return EmptyView(message: context.l10n.profileNotAvailable);
          }

          return SingleChildScrollView(
            child: ResponsiveContent(
              maxWidth: AppDimensions.maxContentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileHeader(user: user),
                  AppSpacing.verticalGap(AppSpacing.md),
                  SectionCard(
                    icon: Icons.badge_outlined,
                    title: context.l10n.profileSignedInAs,
                    child: Column(
                      children: [
                        ValueChip(
                          label: context.l10n.loginEmailLabel,
                          value: user.email,
                        ),
                        if (user.createdAt != null)
                          ValueChip(
                            label: context.l10n.profileMemberSince,
                            value: _dateFormat.format(user.createdAt!),
                          ),
                      ],
                    ),
                  ),
                  AppSpacing.verticalGap(AppSpacing.md),
                  OutlinedButton.icon(
                    onPressed: state.status == AuthStatus.signingOut
                        ? null
                        : () => context.read<AuthCubit>().signOut(),
                    icon: const Icon(Icons.logout),
                    label: Text(context.l10n.profileSignOut),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SectionCard(
      icon: Icons.person_outline,
      title: context.l10n.profileTitle,
      child: Row(
        children: [
          UserAvatar(user: user, size: 56),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalGap(AppSpacing.xxs),
                Text(
                  user.email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
