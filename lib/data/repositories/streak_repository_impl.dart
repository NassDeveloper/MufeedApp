import '../../core/errors/app_error.dart';
import '../../domain/models/streak_model.dart';
import '../../domain/repositories/streak_repository.dart';
import '../database/daos/streak_dao.dart';

class StreakRepositoryImpl implements StreakRepository {
  StreakRepositoryImpl(this._dao);

  final StreakDao _dao;

  @override
  Future<StreakModel?> getStreak() async {
    try {
      final streak = await _dao.getStreak();
      if (streak == null) return null;
      return StreakModel(
        id: streak.id,
        currentStreak: streak.currentStreak,
        longestStreak: streak.longestStreak,
        lastActivityDate: streak.lastActivityDate,
        freezeAvailable: streak.freezeAvailable,
        freezeUsedDate: streak.freezeUsedDate,
      );
    } catch (e) {
      throw DatabaseError('Failed to get streak', debugInfo: '$e');
    }
  }

  @override
  Future<DateTime?> getLastActivityDate() async {
    try {
      return await _dao.getLastActivityDate();
    } catch (e) {
      throw DatabaseError(
        'Failed to get last activity date',
        debugInfo: '$e',
      );
    }
  }

  @override
  Future<void> updateLastActivityDate(DateTime date) async {
    try {
      await _dao.updateLastActivityDate(date);
    } catch (e) {
      throw DatabaseError(
        'Failed to update last activity date',
        debugInfo: '$e',
      );
    }
  }

  @override
  Future<void> updateStreak(StreakModel streak) async {
    try {
      await _dao.updateStreak(
        id: streak.id,
        currentStreak: streak.currentStreak,
        longestStreak: streak.longestStreak,
        lastActivityDate: streak.lastActivityDate,
        freezeAvailable: streak.freezeAvailable,
        freezeUsedDate: streak.freezeUsedDate,
      );
    } catch (e) {
      throw DatabaseError('Failed to update streak', debugInfo: '$e');
    }
  }
}
