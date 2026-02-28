import 'package:flutter/foundation.dart';

@immutable
class UpcomingReviewsModel {
  const UpcomingReviewsModel({
    required this.dueToday,
    required this.dueTomorrow,
    required this.dueThisWeek,
  });

  /// Items with next_review <= end of today.
  final int dueToday;

  /// Items with next_review in [tomorrow start, tomorrow end].
  final int dueTomorrow;

  /// Total items with next_review <= 7 days from now (includes today and tomorrow).
  final int dueThisWeek;
}
