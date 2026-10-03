/// Calendar arithmetic the portal repeats in several models.
///
/// Whole days by calendar, not by dividing a `Duration`: a deadline is a date
/// a person reads ("closes in 10 days"), and dividing hours says "closes in 9
/// days" every morning before lunchtime.
library;

/// Days from [now] until [deadline]; never negative.
///
/// Midnight-to-midnight counting, so the answer is the number of midnights
/// crossed — which is what "closes in 10 days" means to somebody reading it.
///
/// Clamped at zero because every caller renders a countdown, and a negative one
/// is not information a candidate can act on: the deadline has passed, and
/// "closes in -3 days" says nothing the date above it did not already. Callers
/// that need to know whether it has passed compare the dates themselves.
int daysUntil(DateTime now, DateTime deadline) {
  final today = DateTime(now.year, now.month, now.day);
  final lastDay = DateTime(deadline.year, deadline.month, deadline.day);
  final remaining = lastDay.difference(today).inDays;

  return remaining > 0 ? remaining : 0;
}
