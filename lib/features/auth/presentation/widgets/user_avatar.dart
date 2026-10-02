import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/user.dart';

/// Profile picture of a user, with a deterministic fallback chain:
/// remote image → bundled portrait → initials.
///
/// [User.avatarUrl] may hold a remote URL or the key of a bundled asset, so the
/// fake backend can ship a portrait without the widget knowing where it came
/// from. Anything that resolves to neither (null, empty, broken) falls back to
/// the initials, so the avatar never renders empty.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.user,
    this.size = 56,
    this.borderRadius,
    this.border,
    super.key,
  });

  final User user;
  final double size;

  /// Square the picture off; `null` keeps the circular shape.
  final BorderRadius? borderRadius;

  /// Optional ring drawn around the picture, as the hub's hero has.
  final BoxBorder? border;

  /// Whether [reference] is a bundled asset rather than a remote URL.
  static bool isAsset(String reference) => reference.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.all(Radius.circular(size / 2));
    final image = _resolveImage(context);

    final content = border == null
        ? ClipRRect(borderRadius: radius, child: image)
        : Container(
            decoration: BoxDecoration(borderRadius: radius, border: border),
            child: ClipRRect(
              borderRadius: radius,
              child: SizedBox(width: size, height: size, child: image),
            ),
          );

    return SizedBox(width: size, height: size, child: content);
  }

  Widget _resolveImage(BuildContext context) {
    final reference = user.avatarUrl;

    if (reference != null && reference.isNotEmpty) {
      return isAsset(reference)
          ? Image.asset(
              reference,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _initials(context),
            )
          : Image.network(
              reference,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _initials(context),
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
        borderRadius:
            borderRadius ?? BorderRadius.all(Radius.circular(size / 2)),
      ),
      child: Text(
        user.initials,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontSize: size / 2.5,
        ),
      ),
    );
  }
}
