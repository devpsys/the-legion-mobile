import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/registration_cubit.dart';
import '../models/registration_models.dart';
import 'registration_card.dart';
import 'registration_chrome.dart';
import 'registration_labels.dart';

/// Draft form for filing a new academic petition.
class AcademicRequestForm extends StatefulWidget {
  const AcademicRequestForm({
    required this.draft,
    required this.cubit,
    super.key,
  });

  final AcademicRequestDraft draft;
  final RegistrationCubit cubit;

  @override
  AcademicRequestFormState createState() => AcademicRequestFormState();
}

/// State of [AcademicRequestForm].
class AcademicRequestFormState extends State<AcademicRequestForm> {
  late final TextEditingController _courseController;
  late final TextEditingController _prerequisiteController;
  late final TextEditingController _reasonsController;

  @override
  void initState() {
    super.initState();
    _courseController = TextEditingController(text: widget.draft.courseCode);
    _prerequisiteController = TextEditingController(
      text: widget.draft.prerequisiteCode,
    );
    _reasonsController = TextEditingController(text: widget.draft.reasons);
  }

  @override
  void didUpdateWidget(covariant AcademicRequestForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.draft.courseCode != widget.draft.courseCode &&
        _courseController.text != widget.draft.courseCode) {
      _courseController.text = widget.draft.courseCode;
    }
    if (oldWidget.draft.prerequisiteCode != widget.draft.prerequisiteCode &&
        _prerequisiteController.text != widget.draft.prerequisiteCode) {
      _prerequisiteController.text = widget.draft.prerequisiteCode;
    }
    if (oldWidget.draft.reasons != widget.draft.reasons &&
        _reasonsController.text != widget.draft.reasons) {
      _reasonsController.text = widget.draft.reasons;
    }
  }

  @override
  void dispose() {
    _courseController.dispose();
    _prerequisiteController.dispose();
    _reasonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final draft = widget.draft;
    final cubit = widget.cubit;
    final isWaive = draft.type == AcademicRequestType.waivePrerequisite;
    final fieldStyle = AppTextStyles.codeSmall.copyWith(
      fontWeight: AppTextStyles.medium,
      color: theme.colorScheme.onSurface,
    );
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: AppRadii.elementRadius),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );

    return RegistrationCard(
      clip: false,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RegistrationFormHeader(
            title: l10n.requestsNewTitle,
            subtitle: l10n.requestsNewSubtitle,
            icon: Icons.edit_note_outlined,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          RegistrationFieldLabel(l10n.requestsWhatDoYouNeed),
          AppSpacing.verticalGap(AppSpacing.xs),
          DropdownButtonFormField<AcademicRequestType>(
            initialValue: draft.type,
            isExpanded: true,
            isDense: true,
            style: fieldStyle,
            iconSize: AppDimensions.iconSmall,
            decoration: inputDecoration,
            items: [
              for (final type in AcademicRequestType.values)
                DropdownMenuItem(
                  value: type,
                  child: Text(
                    RegistrationLabels.academicRequestType(l10n, type),
                    style: fieldStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
            selectedItemBuilder: (context) => [
              for (final type in AcademicRequestType.values)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    RegistrationLabels.academicRequestType(l10n, type),
                    style: fieldStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
            onChanged: (value) {
              if (value != null) cubit.setAcademicDraftType(value);
            },
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          ToneCallout(
            tone: AppTone.info,
            icon: Icons.info_outline,
            body: RegistrationLabels.academicRequestTypeHint(l10n, draft.type),
          ),
          if (isWaive) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            RegistrationFieldLabel(l10n.requestsCourseLabel),
            AppSpacing.verticalGap(AppSpacing.xs),
            TextFormField(
              controller: _courseController,
              style: fieldStyle,
              textCapitalization: TextCapitalization.characters,
              decoration: inputDecoration.copyWith(
                hintText: l10n.requestsCourseLabel,
                hintStyle: AppTextStyles.codeSmall.copyWith(
                  fontWeight: AppTextStyles.regular,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              onChanged: cubit.setAcademicDraftCourse,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            RegistrationFieldLabel(l10n.requestsPrerequisiteLabel),
            AppSpacing.verticalGap(AppSpacing.xs),
            TextFormField(
              controller: _prerequisiteController,
              style: fieldStyle,
              textCapitalization: TextCapitalization.characters,
              decoration: inputDecoration.copyWith(
                hintText: l10n.requestsPrerequisiteLabel,
                hintStyle: AppTextStyles.codeSmall.copyWith(
                  fontWeight: AppTextStyles.regular,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              onChanged: cubit.setAcademicDraftPrerequisite,
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              l10n.requestsWaiveNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
          AppSpacing.verticalGap(AppSpacing.md),
          RegistrationFieldLabel(l10n.requestsReasonsLabel),
          AppSpacing.verticalGap(AppSpacing.xs),
          TextFormField(
            controller: _reasonsController,
            style: fieldStyle,
            minLines: 3,
            maxLines: 6,
            decoration: inputDecoration.copyWith(
              hintText: l10n.requestsReasonsHint,
              hintStyle: AppTextStyles.codeSmall.copyWith(
                fontWeight: AppTextStyles.regular,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            onChanged: cubit.setAcademicDraftReasons,
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          FilledButton.icon(
            onPressed: () {
              final sent = cubit.submitAcademicRequest();
              if (sent) {
                context.showMessage(l10n.requestsSent);
              } else {
                context.showErrorMessage(l10n.requestsReasonsRequired);
              }
            },
            icon: const Icon(Icons.send_outlined),
            label: Text(l10n.requestsSend),
          ),
        ],
      ),
    );
  }
}
