import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/registration_models.dart';
import 'registration_card.dart';
import 'registration_labels.dart';

/// Segmented week: day pills Mon–Sat, detail for the selected day.
class RegistrationWeekSection extends StatefulWidget {
  const RegistrationWeekSection({required this.meetings, super.key});

  final List<WeekMeeting> meetings;

  @override
  RegistrationWeekSectionState createState() => RegistrationWeekSectionState();
}

/// State of [RegistrationWeekSection].
class RegistrationWeekSectionState extends State<RegistrationWeekSection> {
  /// Monday = 1 … Saturday = 6.
  late int _selectedWeekday;

  @override
  void initState() {
    super.initState();
    _selectedWeekday = _initialWeekday(widget.meetings);
  }

  @override
  void didUpdateWidget(covariant RegistrationWeekSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.meetings != widget.meetings) {
      _selectedWeekday = _initialWeekday(widget.meetings);
    }
  }

  static int _initialWeekday(List<WeekMeeting> meetings) {
    for (var day = 1; day <= 6; day++) {
      if (meetings.any((m) => m.weekday == day)) return day;
    }
    return 1;
  }

  List<WeekMeeting> _forDay(int day) =>
      widget.meetings.where((m) => m.weekday == day).toList(growable: false);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final selectedMeetings = _forDay(_selectedWeekday);
    final showActiveDay = _selectedWeekday == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.registrationYourWeekTitle.toUpperCase(),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: AppTextStyles.trackingCaps,
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
            ),
            Text(
              l10n.registrationLectureLabSchedule,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        WeekDaySegmentBar(
          selectedWeekday: _selectedWeekday,
          meetings: widget.meetings,
          onSelected: (day) => setState(() => _selectedWeekday = day),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        SurfaceCard(
          borderRadius: AppRadii.blockRadius,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                RegistrationLabels.weekdayLong(
                                  l10n,
                                  _selectedWeekday,
                                ).toUpperCase(),
                                style: AppTextStyles.codeSmall.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: selectedMeetings.isEmpty
                                      ? theme.colorScheme.onSurfaceVariant
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            AppSpacing.horizontalGap(AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHigh,
                                borderRadius: AppRadii.tagRadius,
                              ),
                              child: Text(
                                selectedMeetings.isEmpty
                                    ? l10n.registrationFree
                                    : l10n.registrationEventsCount(
                                        selectedMeetings.length,
                                      ),
                                style: AppTextStyles.codeSmall.copyWith(
                                  color:
                                      showActiveDay &&
                                          selectedMeetings.isNotEmpty
                                      ? AppTone.success.foreground(
                                          theme.brightness,
                                        )
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (showActiveDay)
                        Text(
                          l10n.registrationActiveDay,
                          style: AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              if (selectedMeetings.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: AppRadii.elementRadius,
                  ),
                  child: Text(
                    l10n.registrationNoLecturesLab,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              else
                for (var i = 0; i < selectedMeetings.length; i++) ...[
                  if (i > 0) AppSpacing.verticalGap(AppSpacing.sm),
                  WeekMeetingRow(meeting: selectedMeetings[i]),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Six-day segmented control for the week strip.
class WeekDaySegmentBar extends StatelessWidget {
  const WeekDaySegmentBar({
    required this.selectedWeekday,
    required this.meetings,
    required this.onSelected,
    super.key,
  });

  final int selectedWeekday;
  final List<WeekMeeting> meetings;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return RegistrationCard(
      clip: false,
      color: theme.colorScheme.surfaceContainerLowest,
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Row(
        children: [
          for (var day = 1; day <= 6; day++) ...[
            if (day > 1) AppSpacing.horizontalGap(AppSpacing.xs),
            Expanded(
              child: WeekDaySegment(
                weekday: day,
                eventCount: meetings.where((m) => m.weekday == day).length,
                isSelected: day == selectedWeekday,
                onTap: () => onSelected(day),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One day pill in [WeekDaySegmentBar].
class WeekDaySegment extends StatelessWidget {
  const WeekDaySegment({
    required this.weekday,
    required this.eventCount,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final int weekday;
  final int eventCount;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final short = RegistrationLabels.weekdayShort(l10n, weekday);
    final countLabel = eventCount == 0
        ? l10n.registrationFree
        : l10n.registrationEventCountShort(eventCount);
    final countColor = eventCount == 0
        ? theme.colorScheme.onSurfaceVariant
        : isSelected
        ? AppTone.success.foreground(theme.brightness)
        : theme.colorScheme.onSurfaceVariant;

    return Material(
      color: isSelected
          ? theme.colorScheme.surfaceContainerHigh
          : theme.colorScheme.surface.withValues(alpha: 0),
      borderRadius: AppRadii.elementRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.elementRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadii.elementRadius,
            border: isSelected
                ? Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
              horizontal: AppSpacing.xs,
            ),
            child: Column(
              children: [
                Text(
                  short.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.codeSmall.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: isSelected
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  countLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: countColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One lecture slot for the selected day — time left, course · venue right.
class WeekMeetingRow extends StatelessWidget {
  const WeekMeetingRow({required this.meeting, super.key});

  final WeekMeeting meeting;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.elementRadius,
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            size: AppDimensions.iconSmall,
            color: theme.colorScheme.primary,
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Text(
              l10n.registrationMeetingTime(
                meeting.endLabel,
                meeting.startLabel,
              ),
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            l10n.registrationMeetingCourseVenue(
              meeting.courseCode,
              meeting.venue,
            ),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
