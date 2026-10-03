import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// The catalogue's free-text search.
///
/// Stateless and unowned: the query lives in [AdmissionsCubit] so the count in
/// the header and the filter chips agree with the list. That means this widget
/// does not read it back either — nothing in the portal rewrites the query
/// under the candidate's hands, so a controller would only be a second source
/// of truth to drift.
class ProgrammeSearchField extends StatelessWidget {
  const ProgrammeSearchField({required this.onChanged, super.key});

  /// Called on every keystroke with the raw field contents.
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextField(
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          hintText: l10n.admissionsProgrammesSearchHint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            // `outline` is the muted icon role; `outlineVariant` is the hairline.
            color: theme.colorScheme.outline,
            size: AppDimensions.iconMedium,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: AppDimensions.inputHeight,
            minHeight: AppDimensions.inputHeight,
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadii.elementRadius,
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadii.elementRadius,
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: AppDimensions.focusRingWidth,
            ),
          ),
        ),
      ),
    );
  }
}
