import 'package:flutter/foundation.dart';

@immutable
class DailyActivityModel {
  const DailyActivityModel({required this.date, required this.count});

  /// Midnight (local time) of the day this entry represents.
  final DateTime date;

  /// Number of items reviewed on this day.
  final int count;
}
