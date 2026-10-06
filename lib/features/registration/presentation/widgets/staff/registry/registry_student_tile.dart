import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/status_tag.dart';
import '../../../models/staff/registry_models.dart';
import '../staff_labels.dart';

/// One row of the students directory: select, status and open the record.
class RegistryStudentTile extends StatelessWidget {
  const RegistryStudentTile({
    required this.student,
    required this.onToggle,
    required this.onOpen,
    super.key,
  });

  final RegistryDirectoryStudent student;
  final VoidCallback onToggle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs),
          child: Checkbox(
            value: student.selected,
            onChanged: student.isSelectable ? (_) => onToggle() : null,
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          student.name,
                          style: AppTextStyles.codeMedium.copyWith(
                            fontWeight: AppTextStyles.semiBold,
                          ),
                        ),
                      ),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      StatusTag(
                        label: StaffRegistrationLabels.directoryStatus(
                          l10n,
                          student.status,
                        ),
                        tone: student.status.tone,
                      ),
                    ],
                  ),
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    l10n.staffRegistryStudentMeta(
                      student.matricNumber,
                      student.programmeCode,
                      l10n.registrationLevel(student.level),
                    ),
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    student.email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
