import '../models/streak_model.dart';

abstract class StreakRepository {
  Future<StreakModel?> getStreak();
  Future<DateTime?> getLastActivityDate();
  Future<void> updateLastActivityDate(DateTime date);
  Future<void> updateStreak(StreakModel streak);
}
