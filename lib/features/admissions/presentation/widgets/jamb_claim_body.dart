import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../bloc/admissions_state.dart';
import '../bloc/jamb_claim_cubit.dart';
import '../bloc/jamb_claim_state.dart';
import 'jamb_claim_form.dart';
import 'jamb_claim_header.dart';
import 'jamb_record_card.dart';
import 'tone_callout.dart';

/// The loaded body of the JAMB tab: the form until the result is linked, the
/// record after.
///
/// Split from the page so the page decides only *which* state to show while
/// this decides what the ready state contains — the same division the other
/// three tabs use. Reads the claim cubit itself; the page hands it the
/// portal's state and the actions, because those are the page's to own.
class JambClaimBody extends StatelessWidget {
  const JambClaimBody({
    required this.admissions,
    required this.controllers,
    required this.onRegistrationNumberChanged,
    required this.onSurnameChanged,
    required this.onPickDateOfBirth,
    required this.onMatch,
    required this.onConfirm,
    required this.onHelp,
    super.key,
  });

  final AdmissionsState admissions;
  final JambClaimControllers controllers;
  final ValueChanged<String> onRegistrationNumberChanged;
  final ValueChanged<String> onSurnameChanged;
  final VoidCallback onPickDateOfBirth;
  final VoidCallback onMatch;
  final VoidCallback onConfirm;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reference = admissions.jambLinkApplication?.trackingCode;
    final linked = admissions.linkedJambResult;

    return SingleChildScrollView(
      child: ResponsiveContent(
        maxWidth: AppDimensions.maxFormWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSpacing.verticalGap(AppSpacing.lg),
            const JambClaimHeader(),
            AppSpacing.verticalGap(AppSpacing.lg),
            if (linked != null)
              // Claimed: the record, and nothing left to type.
              JambRecordCard(
                result: linked,
                isLinked: true,
                linkedReference: reference,
              )
            else
              BlocBuilder<JambClaimCubit, JambClaimState>(
                builder: (context, state) {
                  final result = state.result;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      JambClaimForm(
                        controllers: controllers,
                        state: state,
                        onRegistrationNumberChanged:
                            onRegistrationNumberChanged,
                        onSurnameChanged: onSurnameChanged,
                        onPickDateOfBirth: onPickDateOfBirth,
                        onSubmit: onMatch,
                      ),
                      if (state.status == JambClaimStatus.matched &&
                          result != null) ...[
                        AppSpacing.verticalGap(AppSpacing.lg),
                        JambRecordCard(
                          result: result,
                          isLinked: false,
                          linkedReference: reference,
                        ),
                      ],
                      if (state.status == JambClaimStatus.notFound) ...[
                        AppSpacing.verticalGap(AppSpacing.lg),
                        ToneCallout(
                          tone: AppTone.danger,
                          icon: Icons.error_outline,
                          title: l10n.admissionsJambNotFoundTitle,
                          body: l10n.admissionsJambNotFoundBody,
                        ),
                      ],
                      AppSpacing.verticalGap(AppSpacing.lg),
                      JambPrimaryAction(
                        state: state,
                        onMatch: onMatch,
                        onConfirm: onConfirm,
                      ),
                    ],
                  );
                },
              ),
            AppSpacing.verticalGap(AppSpacing.sm),
            TextButton(
              onPressed: onHelp,
              child: Text(
                l10n.admissionsJambHelpLink,
                textAlign: TextAlign.center,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

/// The one button under the form, which changes its question as the claim
/// progresses: find the record, then — once it is on screen — bind it.
///
/// One button rather than two because the two actions are never both
/// available: there is nothing to confirm until a record is found, and once
/// one is found, finding it again is pointless.
class JambPrimaryAction extends StatelessWidget {
  const JambPrimaryAction({
    required this.state,
    required this.onMatch,
    required this.onConfirm,
    super.key,
  });

  final JambClaimState state;
  final VoidCallback onMatch;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isMatched = state.canConfirm;
    final isMatching = state.status == JambClaimStatus.matching;

    final VoidCallback? onPressed;
    if (isMatched) {
      onPressed = onConfirm;
    } else if (state.canMatch) {
      onPressed = onMatch;
    } else {
      onPressed = null;
    }

    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          AppDimensions.primaryActionHeight,
        ),
      ),
      icon: Icon(
        isMatched ? Icons.arrow_forward : Icons.search,
        size: AppDimensions.iconMedium,
      ),
      iconAlignment: isMatched ? IconAlignment.end : IconAlignment.start,
      label: Text(
        isMatched
            ? l10n.admissionsJambConfirmAction
            : isMatching
            ? l10n.admissionsJambMatching
            : l10n.admissionsJambFindAction,
      ),
    );
  }
}
