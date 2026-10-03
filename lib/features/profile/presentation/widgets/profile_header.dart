import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/widgets/user_avatar.dart';

/// Avatar, name and email of the signed-in student.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SectionCard(
      icon: Icons.person_outline,
      title: context.l10n.profileTitle,
      child: Row(
        children: [
          UserAvatar(user: user, size: AppDimensions.avatarLarge),
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
                AppSpacing.verticalGap(AppSpacing.xs),
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
