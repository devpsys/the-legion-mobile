import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/user.dart';

/// Circular user avatar: remote image when available, initials otherwise.
class UserAvatar extends StatelessWidget {
  const UserAvatar({required this.user, this.size = 56, super.key});

  final User user;
  final double size;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.avatarUrl;

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          avatarUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _initials(context),
        ),
      );
    }

    return _initials(context);
  }

  Widget _initials(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Text(
        user.initials,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
