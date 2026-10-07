import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../models/accommodation_models.dart';
import 'accommodation_labels.dart';

/// "Swap beds with another student": a collapsed card that opens into a matric
/// lookup and a proposal.
///
/// The typed number is local; the lookup result belongs to the cubit.
class SwapComposerCard extends StatefulWidget {
  const SwapComposerCard({
    required this.lookup,
    required this.onVerify,
    required this.onPropose,
    super.key,
  });

  final SwapLookup lookup;
  final ValueChanged<String> onVerify;
  final VoidCallback onPropose;

  @override
  SwapComposerCardState createState() => SwapComposerCardState();
}

/// State of [SwapComposerCard].
class SwapComposerCardState extends State<SwapComposerCard> {
  final TextEditingController _controller = TextEditingController();
  bool _isOpen = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final lookup = widget.lookup;
    final target = lookup.target;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _isOpen = !_isOpen),
            child: Row(
              children: [
                Icon(
                  Icons.published_with_changes,
                  size: AppDimensions.iconDense,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.accommodationSwapTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Icon(_isOpen ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          if (_isOpen) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              l10n.accommodationSwapIntro,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.characters,
              style: AppTextStyles.codeMedium,
              decoration: InputDecoration(
                labelText: l10n.accommodationSwapMatricLabel,
                hintText: l10n.accommodationSwapMatricHint,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            OutlinedButton(
              onPressed: () => widget.onVerify(_controller.text),
              child: Text(l10n.accommodationSwapVerify),
            ),
            if (lookup.status == SwapLookupStatus.notFound) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              ToneCallout(
                tone: AppTone.danger,
                icon: Icons.error_outline,
                body: l10n.accommodationSwapNotFound,
              ),
            ],
            if (lookup.status == SwapLookupStatus.found && target != null) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              ToneCallout(
                tone: AppTone.success,
                icon: Icons.verified_outlined,
                title: l10n.accommodationSwapFound(target.name),
                body: AccommodationLabels.bedFull(l10n, target.location),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              FilledButton.icon(
                onPressed: widget.onPropose,
                icon: const Icon(Icons.send_outlined),
                label: Text(l10n.accommodationSwapPropose),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
