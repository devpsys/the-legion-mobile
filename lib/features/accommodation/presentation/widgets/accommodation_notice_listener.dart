import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../bloc/accommodation_cubit.dart';
import '../bloc/accommodation_state.dart';

/// Tells the student the outcome of what they just did, once, then clears it.
///
/// [onNotice] lets a screen follow the outcome with a navigation (accepting
/// the terms leaves the terms screen, holding a bed leaves the room list).
class AccommodationNoticeListener extends StatelessWidget {
  const AccommodationNoticeListener({
    required this.child,
    this.onNotice,
    super.key,
  });

  final Widget child;
  final void Function(BuildContext context, AccommodationNotice notice)?
  onNotice;

  /// The sentence that reports [notice].
  static String message(AppLocalizations l10n, AccommodationNotice notice) {
    return switch (notice) {
      AccommodationNotice.termsAccepted => l10n.accommodationNoticeTerms,
      AccommodationNotice.bedHeld => l10n.accommodationNoticeHeld,
      AccommodationNotice.bookingCancelled => l10n.accommodationNoticeCancelled,
      AccommodationNotice.offerAccepted => l10n.accommodationNoticeAccepted,
      AccommodationNotice.offerDeclined => l10n.accommodationNoticeDeclined,
      AccommodationNotice.swapAccepted => l10n.accommodationNoticeSwapDone,
      AccommodationNotice.swapDeclined => l10n.accommodationNoticeSwapDeclined,
      AccommodationNotice.swapProposed => l10n.accommodationNoticeSwapSent,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccommodationCubit, AccommodationState>(
      listenWhen: (previous, current) =>
          previous.notice != current.notice && current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        context.showMessage(message(context.l10n, notice));
        context.read<AccommodationCubit>().clearNotice();
        onNotice?.call(context, notice);
      },
      child: child,
    );
  }
}
