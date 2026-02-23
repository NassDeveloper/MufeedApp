import '../models/badge_model.dart';
import '../models/badge_type.dart';

abstract class BadgeRepository {
  Future<List<BadgeModel>> getAllBadges();
  Future<BadgeModel?> getBadge(BadgeType type);
  Future<void> unlockBadge(BadgeType type, DateTime at);
  Future<void> markDisplayed(BadgeType type);
}
