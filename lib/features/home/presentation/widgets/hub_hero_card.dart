import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/widgets/user_avatar.dart';
import '../models/hub_models.dart';

/// Time of day the greeting belongs to.
///
/// Kept as an enum so the clock decides the period and the localized strings
/// stay in the ARB, and so the boundaries are unit testable without a
/// widget tree.
enum GreetingPeriod {
  morning,
  afternoon,
  evening;

  /// Morning before noon, afternoon until 17:00, evening after that.
  static GreetingPeriod forHour(int hour) {
    if (hour < 12) return GreetingPeriod.morning;
    if (hour < 17) return GreetingPeriod.afternoon;
    return GreetingPeriod.evening;
  }

  /// Localized greeting for the period.
  String localize(AppLocalizations l10n) => switch (this) {
    GreetingPeriod.morning => l10n.homeGreetingMorning,
    GreetingPeriod.afternoon => l10n.homeGreetingAfternoon,
    GreetingPeriod.evening => l10n.homeGreetingEvening,
  };
}

/// Hero of the hub: who the student is, and how much of the term is left.
///
/// One of the two places the design system allows a gradient, because the
/// designs make the navy-to-deep-navy panel the page's anchor. The honey gold
/// stays the single accent, used for the date eyebrow, the term label and the
/// leading edge of the progress track.
class HubHeroCard extends StatelessWidget {
  const HubHeroCard({
    required this.user,
    required this.term,
    required this.standing,
    required this.now,
    super.key,
  });

  final User user;
  final HubTerm term;
  final HubStanding standing;

  /// Injected so the greeting and the term maths are deterministic in tests.
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final firstName = user.displayName.split(' ').first;
    final greeting = GreetingPeriod.forHour(now.hour).localize(l10n);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.card + 4),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navyDeep],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, d MMMM y', l10n.localeName).format(now),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.honeyGold,
                        letterSpacing: 1,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      '$greeting, $firstName',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      standing.summary,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              _HeroAvatar(user: user),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xl),
          TermMetricPanel(term: term, now: now),
        ],
      ),
    );
  }
}

/// Term progress block inside the hero: label, day count and track.
class TermMetricPanel extends StatelessWidget {
  const TermMetricPanel({required this.term, required this.now, super.key});

  final HubTerm term;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final daysLeft = term.daysRemainingAt(now);
    final endsOn = DateFormat.MMMd(l10n.localeName).format(term.endsOn);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: AppRadii.rowRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // A static dot rather than the designs' CSS pulse: an endlessly
              // repeating animation never settles, which would hang every
              // widget test that pumps this screen.
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.honeyGold,
                  shape: BoxShape.circle,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.sm,
                  children: [
                    Text(
                      l10n.homeCurrentTerm.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.honeyGold,
                      ),
                    ),
                    Text(
                      '${term.session} · ${term.semesterLong}',
                      style: AppTextStyles.codeMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Text(
                '$daysLeft',
                style: AppTextStyles.codeMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Text(
                l10n.homeDaysLeft,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          _TermProgressTrack(progress: term.progressAt(now)),
          AppSpacing.verticalGap(AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.homeTermInProgress,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ),
              Text(
                l10n.homeTermEndsOn(endsOn),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Horizontal term track, filled gold the way the design shows progress.
class _TermProgressTrack extends StatelessWidget {
  const _TermProgressTrack({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.chipRadius,
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: Colors.black.withValues(alpha: 0.25),
        valueColor: const AlwaysStoppedAnimation(AppColors.honeyGold),
      ),
    );
  }
}

/// Side of the hero's avatar.
const double _avatarSize = 56;

/// Avatar with the design's online marker.
class _HeroAvatar extends StatelessWidget {
  const _HeroAvatar({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final online = AppColors.successTextLight;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        UserAvatar(
          user: user,
          size: _avatarSize,
          borderRadius: BorderRadius.circular(AppRadii.element + 2),
          border: Border.all(
            color: AppColors.honeyGold.withValues(alpha: 0.7),
            width: AppDimensions.hairline + 1,
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: online,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.navyDeep, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
