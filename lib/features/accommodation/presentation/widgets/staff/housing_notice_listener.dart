import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/l10n/gen/app_localizations.dart';
import '../../../../../core/widgets/message_feedback.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';

/// Tells the officer the outcome of what they just did, once, then clears it.
class HousingNoticeListener extends StatelessWidget {
  const HousingNoticeListener({required this.child, super.key});

  final Widget child;

  /// The sentence that reports [notice].
  static String message(AppLocalizations l10n, HousingNotice notice) {
    return switch (notice) {
      HousingNotice.allocationCancelled => l10n.housingNoticeCancelled,
      HousingNotice.roomSaved => l10n.housingNoticeRoomSaved,
      HousingNotice.roomsAdded => l10n.housingNoticeRoomsAdded,
      HousingNotice.agreementPublished => l10n.housingNoticePublished,
      HousingNotice.noticeSaved => l10n.housingNoticeWordingSaved,
      HousingNotice.categorySaved => l10n.housingNoticeCategorySaved,
      HousingNotice.categoryRemoved => l10n.housingNoticeCategoryRemoved,
      HousingNotice.banAdded => l10n.housingNoticeBanAdded,
      HousingNotice.banLifted => l10n.housingNoticeBanLifted,
      HousingNotice.refundSaved => l10n.housingNoticeRefundSaved,
      HousingNotice.priceSaved => l10n.housingNoticePriceSaved,
      HousingNotice.openingSaved => l10n.housingNoticeOpeningSaved,
      HousingNotice.drawRun => l10n.housingNoticeDrawRun,
      HousingNotice.autoRun => l10n.housingNoticeAutoRun,
      HousingNotice.keepSent => l10n.housingNoticeKeepSent,
      HousingNotice.uploadDone => l10n.housingNoticeUploadDone,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HousingCubit, HousingState>(
      listenWhen: (previous, current) =>
          previous.notice != current.notice && current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        context.showMessage(message(context.l10n, notice));
        context.read<HousingCubit>().clearNotice();
      },
      child: child,
    );
  }
}
