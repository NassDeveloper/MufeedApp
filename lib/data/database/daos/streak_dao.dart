import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/streaks_table.dart';

part 'streak_dao.g.dart';

@DriftAccessor(tables: [Streaks])
class StreakDao extends DatabaseAccessor<AppDatabase> with _$StreakDaoMixin {
  StreakDao(super.db);

  /// Returns the single streak record, or null if none exists.
  Future<Streak?> getStreak() async {
    final query = select(streaks)..limit(1);
    final results = await query.get();
    return results.isEmpty ? null : results.first;
  }

  /// Returns the last activity date from the streak record.
  Future<DateTime?> getLastActivityDate() async {
    final streak = await getStreak();
    return streak?.lastActivityDate;
  }

  /// Updates the last_activity_date to the given date.
  /// If no streak record exists, creates one with default values.
  Future<void> updateLastActivityDate(DateTime date) async {
    final streak = await getStreak();
    if (streak != null) {
      await (update(streaks)..where((s) => s.id.equals(streak.id))).write(
        StreaksCompanion(lastActivityDate: Value(date)),
      );
    } else {
      await into(streaks).insert(
        StreaksCompanion.insert(lastActivityDate: date),
      );
    }
  }

  /// Updates all fields of the streak record.
  Future<void> updateStreak({
    required int id,
    required int currentStreak,
    required int longestStreak,
    required DateTime lastActivityDate,
    required bool freezeAvailable,
    required DateTime? freezeUsedDate,
  }) async {
    await (update(streaks)..where((s) => s.id.equals(id))).write(
      StreaksCompanion(
        currentStreak: Value(currentStreak),
        longestStreak: Value(longestStreak),
        lastActivityDate: Value(lastActivityDate),
        freezeAvailable: Value(freezeAvailable),
        freezeUsedDate: Value(freezeUsedDate),
      ),
    );
  }
}
