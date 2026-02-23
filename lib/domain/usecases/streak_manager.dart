import '../models/streak_model.dart';

class StreakManager {
  const StreakManager();

  static DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime _mondayOf(DateTime d) {
    final normalized = _normalize(d);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  /// Returns true if the user has been absent for [thresholdDays] or more.
  ///
  /// Compares calendar days between [lastActivityDate] and [now].
  bool isAbsenceProlonged({
    required DateTime lastActivityDate,
    required DateTime now,
    int thresholdDays = 3,
  }) {
    final lastDate = _normalize(lastActivityDate);
    final today = _normalize(now);
    return today.difference(lastDate).inDays >= thresholdDays;
  }

  /// Calculates the updated streak state based on the current streak and now.
  ///
  /// - Same day → unchanged
  /// - Yesterday → increment (+1), update longest if needed
  /// - 2 days ago + freeze available → use freeze, increment
  /// - Otherwise → reset to 0
  StreakModel calculateStreakUpdate({
    required StreakModel currentStreak,
    required DateTime now,
  }) {
    final lastDate = _normalize(currentStreak.lastActivityDate);
    final today = _normalize(now);
    final daysDiff = today.difference(lastDate).inDays;

    // Already active today or clock went backwards
    if (daysDiff <= 0) return currentStreak;

    // Refresh freeze availability if new week started
    final streak = refreshFreezeAvailability(streak: currentStreak, now: now);

    // Yesterday → increment
    if (daysDiff == 1) {
      final newCurrent = streak.currentStreak + 1;
      return streak.copyWith(
        currentStreak: newCurrent,
        longestStreak:
            newCurrent > streak.longestStreak ? newCurrent : streak.longestStreak,
        lastActivityDate: now,
      );
    }

    // Day before yesterday (missed 1 day) → use freeze if available
    if (daysDiff == 2 && streak.freezeAvailable) {
      final newCurrent = streak.currentStreak + 1;
      return streak.copyWith(
        currentStreak: newCurrent,
        longestStreak:
            newCurrent > streak.longestStreak ? newCurrent : streak.longestStreak,
        lastActivityDate: now,
        freezeAvailable: false,
        freezeUsedDate: now,
      );
    }

    // More than 1 day gap without valid freeze → reset
    return streak.copyWith(
      currentStreak: 0,
      lastActivityDate: now,
    );
  }

  /// Returns true if the streak should be reset (more than 1 calendar day gap).
  bool shouldResetStreak({
    required DateTime lastActivityDate,
    required DateTime now,
  }) {
    final lastDate = _normalize(lastActivityDate);
    final today = _normalize(now);
    return today.difference(lastDate).inDays > 1;
  }

  /// Returns true if the freeze is available (considering weekly renewal).
  bool isFreezeAvailable({
    required StreakModel streak,
    required DateTime now,
  }) {
    final refreshed = refreshFreezeAvailability(streak: streak, now: now);
    return refreshed.freezeAvailable;
  }

  /// Renews freeze availability if a new ISO week has started since last use.
  StreakModel refreshFreezeAvailability({
    required StreakModel streak,
    required DateTime now,
  }) {
    if (streak.freezeAvailable) return streak;
    if (streak.freezeUsedDate == null) return streak;

    final usedMonday = _mondayOf(streak.freezeUsedDate!);
    final currentMonday = _mondayOf(now);

    if (currentMonday.isAfter(usedMonday)) {
      return streak.copyWith(freezeAvailable: true);
    }

    return streak;
  }
}
