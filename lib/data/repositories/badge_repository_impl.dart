import '../../core/errors/app_error.dart';
import '../../domain/models/badge_model.dart';
import '../../domain/models/badge_type.dart';
import '../../domain/repositories/badge_repository.dart';
import '../database/daos/badge_dao.dart';

class BadgeRepositoryImpl implements BadgeRepository {
  BadgeRepositoryImpl(this._dao);

  final BadgeDao _dao;

  @override
  Future<List<BadgeModel>> getAllBadges() async {
    try {
      final rows = await _dao.getAllBadges();
      return rows
          .map((row) {
            final type = BadgeType.fromKey(row.badgeType);
            if (type == null) return null;
            return BadgeModel(
              id: row.id,
              badgeType: type,
              unlockedAt: row.unlockedAt,
              displayed: row.displayed,
            );
          })
          .whereType<BadgeModel>()
          .toList();
    } catch (e) {
      throw DatabaseError('Failed to get badges', debugInfo: '$e');
    }
  }

  @override
  Future<BadgeModel?> getBadge(BadgeType type) async {
    try {
      final row = await _dao.getBadge(type.key);
      if (row == null) return null;
      return BadgeModel(
        id: row.id,
        badgeType: type,
        unlockedAt: row.unlockedAt,
        displayed: row.displayed,
      );
    } catch (e) {
      throw DatabaseError('Failed to get badge', debugInfo: '$e');
    }
  }

  @override
  Future<void> unlockBadge(BadgeType type, DateTime at) async {
    try {
      await _dao.unlockBadge(type.key, at);
    } catch (e) {
      throw DatabaseError('Failed to unlock badge', debugInfo: '$e');
    }
  }

  @override
  Future<void> markDisplayed(BadgeType type) async {
    try {
      await _dao.markDisplayed(type.key);
    } catch (e) {
      throw DatabaseError('Failed to mark badge displayed', debugInfo: '$e');
    }
  }
}
