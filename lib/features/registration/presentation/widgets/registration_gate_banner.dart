import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../models/registration_models.dart';
import 'registration_labels.dart';

/// Resource-gate and window notices above the registration summary.
///
/// Unverified ("Not tracked") is amber and non-blocking. Blocked is danger
/// and disables submit. Add/drop-only is informational.
class RegistrationGateBanner extends StatelessWidget {
  const RegistrationGateBanner({
    required this.gate,
    required this.window,
    super.key,
  });

  final ResourceGate gate;
  final RegistrationWindow window;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final children = <Widget>[];

    switch (gate.kind) {
      case ResourceGateKind.allowed:
        break;
      case ResourceGateKind.unverified:
        children.add(
          ToneCallout(
            tone: AppTone.warning,
            icon: Icons.schedule_outlined,
            title: l10n.registrationGateNotTracked,
            body: gate.unverifiedDetail ?? l10n.registrationGateNotTracked,
          ),
        );
      case ResourceGateKind.blocked:
        children.add(
          ToneCallout(
            tone: AppTone.danger,
            icon: Icons.account_balance_wallet_outlined,
            body: gate.blockingReason ?? l10n.errorsServer,
          ),
        );
    }

    if (window.state == WindowState.addDropOnly) {
      children.add(
        ToneCallout(
          tone: AppTone.info,
          icon: Icons.info_outline,
          title: RegistrationLabels.windowState(l10n, window),
          body: l10n.registrationAddDropBanner,
        ),
      );
    }

    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) AppSpacing.verticalGap(AppSpacing.md),
          children[i],
        ],
      ],
    );
  }
}
