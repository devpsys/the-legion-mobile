import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Identifier input of the request step: label, field, and the helper line that
/// tells applicants which address to use.
class IdentifierField extends StatelessWidget {
  const IdentifierField({
    required this.controller,
    required this.enabled,
    required this.onChanged,
    required this.onSubmitted,
    this.errorText,
    super.key,
  });

  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.l10n.recoveryIdentifierLabel} *',
          style: context.textStyles.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        TextField(
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: context.l10n.recoveryIdentifierHint,
            suffixIcon: const Icon(
              Icons.badge_outlined,
              size: AppDimensions.iconMedium,
            ),
            errorText: errorText,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          context.l10n.recoveryIdentifierHelper,
          style: context.textStyles.bodySmall,
        ),
      ],
    );
  }
}
