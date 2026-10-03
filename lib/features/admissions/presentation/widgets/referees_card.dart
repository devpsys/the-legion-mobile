import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../models/application_detail_models.dart';
import 'referee_invite_form.dart';
import 'referee_row.dart';
import 'section_surface.dart';

/// "Referees" — who has been invited, who has answered, and the form that
/// invites the rest.
///
/// The list and the form share one card because they are one task: the
/// checklist row for referees counts this list, and the candidate comes back
/// to this card to change the number it quotes.
class RefereesCard extends StatelessWidget {
  const RefereesCard({
    required this.referees,
    required this.formKey,
    required this.onResend,
    required this.onRemove,
    required this.onSendInvitation,
    super.key,
  });

  final List<Referee> referees;

  /// Owned by the body so the checklist's "Invite" action can bring the
  /// candidate here without a second scroll view to negotiate with.
  final GlobalKey<RefereeInviteFormState> formKey;

  final ValueChanged<Referee> onResend;

  final ValueChanged<Referee> onRemove;

  final VoidCallback onSendInvitation;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(title: l10n.admissionsRefereesTitle),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.admissionsRefereesSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          for (final referee in referees) ...[
            RefereeRow(
              referee: referee,
              onResend: () => onResend(referee),
              onRemove: () => onRemove(referee),
            ),
            const Divider(height: AppSpacing.xs),
          ],
          if (referees.isNotEmpty) AppSpacing.verticalGap(AppSpacing.lg),
          RefereeInviteForm(key: formKey, onSend: onSendInvitation),
        ],
      ),
    );
  }
}
