import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import '../../models/staff/housing_models.dart';
import 'housing_field.dart';
import 'housing_labels.dart';
import 'housing_section.dart';

/// The wording of each message the housing office sends students.
class NoticesBody extends StatelessWidget {
  const NoticesBody({required this.state, super.key});

  final HousingState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final notice in state.notices) ...[
          NoticeEditor(notice: notice),
          AppSpacing.verticalGap(AppSpacing.md),
        ],
      ],
    );
  }
}

/// One message and the field to reword it.
class NoticeEditor extends StatefulWidget {
  const NoticeEditor({required this.notice, super.key});

  final HousingNoticeText notice;

  @override
  NoticeEditorState createState() => NoticeEditorState();
}

/// State of [NoticeEditor]: the draft wording.
class NoticeEditorState extends State<NoticeEditor> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.notice.body,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final changed =
        _controller.text.trim() != widget.notice.body &&
        _controller.text.trim().isNotEmpty;

    return HousingSection(
      title: HousingLabels.noticeKey(l10n, widget.notice.key),
      children: [
        HousingField(
          label: l10n.housingNoticeWording,
          controller: _controller,
          maxLines: 4,
          onChanged: (_) => setState(() {}),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        FilledButton(
          onPressed: changed
              ? () => context.read<HousingCubit>().saveNotice(
                  widget.notice.key,
                  _controller.text,
                )
              : null,
          child: Text(l10n.housingSave),
        ),
      ],
    );
  }
}
