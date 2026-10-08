import 'package:flutter/material.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../registration/presentation/widgets/registration_task_bar.dart';

/// Fixed top bar of the student Examinations & Results portal: the session
/// pill, the bell and the student's avatar.
///
/// It is the portal's session bar, drawn the same way as Registration &
/// Records so moving between the two keeps the student's bearings.
class ExaminationsTaskBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ExaminationsTaskBar({
    required this.sessionLabel,
    required this.user,
    required this.onNotifications,
    required this.onAvatarTap,
    super.key,
  });

  /// The session, e.g. `2025/2026 • 2nd Sem`.
  final String sessionLabel;
  final User? user;
  final VoidCallback onNotifications;
  final VoidCallback onAvatarTap;

  @override
  Size get preferredSize =>
      const Size.fromHeight(RegistrationTaskBar.barHeight);

  @override
  Widget build(BuildContext context) {
    return RegistrationTaskBar(
      sessionLabel: sessionLabel,
      user: user,
      onNotifications: onNotifications,
      onAvatarTap: onAvatarTap,
    );
  }
}
